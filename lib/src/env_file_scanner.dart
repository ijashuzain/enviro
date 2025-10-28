import 'dart:io';

/// Scans the project directory for .env files
class EnvFileScanner {
  /// Find all .env files in the project root
  Future<List<File>> findEnvFiles() async {
    final projectRoot = Directory.current;
    final envFiles = <File>[];

    // List all files in project root
    await for (final entity in projectRoot.list()) {
      if (entity is File) {
        final fileName = entity.path.split(Platform.pathSeparator).last;

        // Match .env and .env-* files
        if (fileName == '.env' || fileName.startsWith('.env-')) {
          envFiles.add(entity);
        }
      }
    }

    // Sort files: .env first, then alphabetically
    envFiles.sort((a, b) {
      final aName = a.path.split(Platform.pathSeparator).last;
      final bName = b.path.split(Platform.pathSeparator).last;

      if (aName == '.env') return -1;
      if (bName == '.env') return 1;

      return aName.compareTo(bName);
    });

    return envFiles;
  }
}