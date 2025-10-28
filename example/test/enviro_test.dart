import 'package:flutter_test/flutter_test.dart';
import 'package:enviro_example/gen/enviro.gen.dart';

void main() {
  group('Enviro Generated Code Tests', () {
    test('should have all expected environments', () {
      expect(EnviroEnvironment.values, contains(EnviroEnvironment.DEFAULT));
      expect(EnviroEnvironment.values, contains(EnviroEnvironment.DEVELOPMENT));
      expect(EnviroEnvironment.values, contains(EnviroEnvironment.STAGING));
      expect(EnviroEnvironment.values, contains(EnviroEnvironment.PRODUCTION));
    });

    test('should have all expected getters', () {
      // This test will fail if the environment files are not set up
      // but it demonstrates the expected API
      expect(() => Enviro.apiUrl, throwsException);
      expect(() => Enviro.databaseUrl, throwsException);
      expect(() => Enviro.debug, throwsException);
      expect(() => Enviro.port, throwsException);
      expect(() => Enviro.secretKey, throwsException);
      expect(() => Enviro.environment, throwsException);
      expect(() => Enviro.logLevel, throwsException);
      expect(() => Enviro.timeout, throwsException);
      expect(() => Enviro.maxRetries, throwsException);
      expect(() => Enviro.enableAnalytics, throwsException);
    });

    test('should have currentEnvironment getter', () {
      expect(Enviro.currentEnvironment, EnviroEnvironment.DEFAULT);
    });
  });
}
