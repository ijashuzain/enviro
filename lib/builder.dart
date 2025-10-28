import 'package:build/build.dart';
import 'dart:io';
import 'src/enviro_generator_logic.dart';

/// Creates the builder for enviro package
Builder enviroBuilder(BuilderOptions options) {
  return EnviroBuilder();
}

/// Custom builder that generates enviro.gen.dart
class EnviroBuilder implements Builder {
  @override
  final buildExtensions = const {
    r'$lib$': ['gen/enviro.gen.dart']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Only run for the synthetic input
    if (!buildStep.inputId.path.endsWith(r'$lib$')) {
      return;
    }

    // Ensure gen directory exists
    final genDir = Directory('lib/gen');
    if (!await genDir.exists()) {
      await genDir.create(recursive: true);
    }

    // Generate code with validation
    final generator = EnviroGeneratorLogic();
    final output = await generator.generate();

    if (output != null) {
      final outputId = AssetId(
        buildStep.inputId.package,
        'lib/gen/enviro.gen.dart',
      );
      await buildStep.writeAsString(outputId, output);
    }
  }
}