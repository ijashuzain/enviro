import 'dart:io';
import 'env_file_parser.dart';
import 'env_file_scanner.dart';
import 'code_generator.dart';

/// Simple logger interface for enviro
class EnviroLogger {
  void severe(String message) => print('[enviro] ERROR: $message');
  void warning(String message) => print('[enviro] WARNING: $message');
  void info(String message) => print('[enviro] INFO: $message');
}

/// Main generator logic that orchestrates the environment file processing
class EnviroGeneratorLogic {
  final EnviroLogger _log;
  
  EnviroGeneratorLogic({EnviroLogger? logger}) : _log = logger ?? EnviroLogger();
  
  /// Generate the enviro.gen.dart content
  Future<String?> generate() async {
    try {
      // Step 1: Find all .env files
      final scanner = EnvFileScanner();
      final envFiles = await scanner.findEnvFiles();

      if (envFiles.isEmpty) {
        final errorMessage = '''
// ERROR: No .env files found in project root
// 
// Enviro requires at least a .env file to work.
// Please create a .env file in your project root directory.

class Enviro {
  Enviro._();
  
  static Future<void> setEnvironment(dynamic env) async {
    throw Exception('No .env files found. Please create a .env file in your project root.');
  }
}

enum EnviroEnvironment {
  DEFAULT,
}
''';
        _log.severe('No .env files found in project root');
        return errorMessage;
      }

      // Step 2: Check if DEFAULT (.env) exists
      final hasDefaultEnv = envFiles.any((file) {
        final fileName = file.path.split(Platform.pathSeparator).last;
        return fileName == '.env';
      });

      if (!hasDefaultEnv) {
        final errorMessage = '''
// ERROR: .env file not found
// 
// Enviro requires a .env file as the default environment.
// Other environment files (.env-staging, .env-production, etc.) 
// will use .env as fallback for missing keys.

class Enviro {
  Enviro._();
  
  static Future<void> setEnvironment(dynamic env) async {
    throw Exception('.env file not found. Please create a .env file in your project root.');
  }
}

enum EnviroEnvironment {
  DEFAULT,
}
''';
        _log.severe('.env file not found in project root');
        return errorMessage;
      }

      _log.info('Found ${envFiles.length} environment file(s)');

      // Step 3: Validate pubspec.yaml includes all found .env files
      await _validatePubspecAssets(envFiles);

      // Step 4: Parse all .env files
      final parser = EnvFileParser();
      final envData = <String, Map<String, String>>{};
      final allKeys = <String>{};
      final loadedEnvs = <String>[];

      for (final file in envFiles) {
        final content = await file.readAsString();
        final parsed = parser.parse(content);
        final envName = _extractEnvName(file.path);

        loadedEnvs.add('$envName (${parsed.length} vars)');
        envData[envName] = parsed;
        allKeys.addAll(parsed.keys);
      }

      _log.info('Loaded environments: ${loadedEnvs.join(', ')}');

      // Step 5: Validate keys across environments
      _validateKeys(envData, allKeys);

      // Step 6: Generate code
      final codeGen = CodeGenerator(
        environments: envData.keys.toList(),
        envData: envData,
        allKeys: allKeys.toList(),
      );

      _log.info('Code generation completed successfully');
      return codeGen.generate();
    } catch (e) {
      _log.severe('Generation failed: $e');
      return '''
// ERROR: $e

class Enviro {
  Enviro._();
  
  static Future<void> setEnvironment(dynamic env) async {
    throw Exception('Error during generation: $e');
  }
}

enum EnviroEnvironment {
  DEFAULT,
}
''';
    }
  }

  /// Validate that pubspec.yaml includes all .env files in assets
  Future<void> _validatePubspecAssets(List<File> envFiles) async {
    final pubspecFile = File('pubspec.yaml');

    if (!await pubspecFile.exists()) {
      _log.warning('pubspec.yaml not found');
      return;
    }

    final content = await pubspecFile.readAsString();

    // Check if flutter section exists
    if (!content.contains('flutter:')) {
      _logAssetInstructions(envFiles);
      return;
    }

    // Check if assets section exists
    if (!content.contains('assets:')) {
      _logAssetInstructions(envFiles);
      return;
    }

    // Check each .env file individually
    final missingFiles = <String>[];
    
    // Check for wildcard pattern
    final wildcardPatterns = [
      '    - .env*',  // 4 spaces (standard YAML indentation)
      '  - .env*',    // 2 spaces (alternative)
      '- .env*',      // no spaces (fallback)
    ];
    
    bool hasWildcard = false;
    for (final pattern in wildcardPatterns) {
      if (content.contains(pattern)) {
        hasWildcard = true;
        break;
      }
    }

    if (!hasWildcard) {
      for (final file in envFiles) {
        final fileName = file.path.split(Platform.pathSeparator).last;

        // Check if this specific file is in assets with proper YAML structure
        // Look for patterns like "    - .env" or "  - .env" (with proper indentation)
        final patterns = [
          '    - $fileName',  // 4 spaces (standard YAML indentation)
          '  - $fileName',    // 2 spaces (alternative)
          '- $fileName',      // no spaces (fallback)
        ];
        
        bool found = false;
        for (final pattern in patterns) {
          if (content.contains(pattern)) {
            found = true;
            break;
          }
        }
        
        if (!found) {
          missingFiles.add(fileName);
        }
      }

      if (missingFiles.isNotEmpty) {
        _log.warning('Missing .env files in pubspec.yaml assets: ${missingFiles.join(', ')}');
        _logAssetInstructions(envFiles);
      }
    }
  }

  /// Log detailed instructions for missing assets
  void _logAssetInstructions(List<File> envFiles) {
    final fileNames = envFiles.map((file) => file.path.split(Platform.pathSeparator).last).toList();
    _log.warning('Add missing .env files to pubspec.yaml assets: ${fileNames.join(', ')}');
    _log.warning('Example: flutter: assets: [${fileNames.map((name) => '    - $name').join(', ')}] or use wildcard: - .env*');
  }

  /// Extract environment name from file path
  /// .env -> DEFAULT
  /// .env-staging -> STAGING
  /// .env-production -> PRODUCTION
  String _extractEnvName(String path) {
    final fileName = path.split(Platform.pathSeparator).last;

    if (fileName == '.env') {
      return 'DEFAULT';
    }

    // Remove .env- prefix and convert to uppercase
    final envName = fileName.replaceFirst('.env-', '').toUpperCase();
    return envName.replaceAll('-', '_');
  }

  /// Validate that all environments have the same keys
  void _validateKeys(Map<String, Map<String, String>> envData, Set<String> allKeys) {
    final defaultKeys = envData['DEFAULT']?.keys.toSet() ?? <String>{};
    final warnings = <String>[];
    final infos = <String>[];

    for (final env in envData.keys) {
      if (env == 'DEFAULT') continue;

      final envKeys = envData[env]!.keys.toSet();
      final missingKeys = defaultKeys.difference(envKeys);
      final extraKeys = envKeys.difference(defaultKeys);

      if (missingKeys.isNotEmpty) {
        warnings.add('$env missing: ${missingKeys.join(", ")}');
      }

      if (extraKeys.isNotEmpty) {
        infos.add('$env extra: ${extraKeys.join(", ")}');
      }
    }

    if (warnings.isNotEmpty) {
      _log.warning('Key mismatches (will fallback to DEFAULT): ${warnings.join('; ')}');
    }

    if (infos.isNotEmpty) {
      _log.info('Extra keys found: ${infos.join('; ')}');
    }
  }
}