# Enviro

[![pub package](https://img.shields.io/pub/v/enviro.svg)](https://pub.dev/packages/enviro)

A **build_runner** compatible package that generates **type-safe environment configuration** from `.env` files with **multi-environment support** for Flutter and Dart applications.

## ✨ Features

- 🔒 **Type-safe** environment variable access
- 🌍 **Multi-environment support** (development, staging, production, etc.)
- 🚀 **Build-time code generation** with build_runner
- 📝 **Automatic validation** of pubspec.yaml assets configuration
- 🔄 **Fallback mechanism** - missing keys fall back to DEFAULT environment
- 🎯 **Smart type detection** (String, int, bool, double)
- 📦 **Zero runtime dependencies** - pure Dart/Flutter
- ⚡ **Caching** for optimal performance
- 🛡️ **Error handling** with helpful messages

## 🚀 Getting Started

### Prerequisites

- Dart SDK `>=3.0.0`
- Flutter SDK (for Flutter projects)
- `build_runner` package

### Installation

Add `enviro` to your `pubspec.yaml`:

```yaml
dependencies:
  enviro: ^0.0.1

dev_dependencies:
  build_runner: ^2.4.0
```

Then run:

```bash
flutter pub get
```

## 📖 Usage

### 1. Create Environment Files

Create `.env` files in your project root:

**`.env`** (required - default environment):
```env
API_URL=https://api.example.com
DATABASE_URL=postgres://localhost:5432/production
DEBUG=false
PORT=3000
SECRET_KEY=your-secret-key
ENVIRONMENT=production
LOG_LEVEL=error
```

**`.env-development`**:
```env
API_URL=https://api-dev.example.com
DATABASE_URL=postgres://localhost:5432/development
DEBUG=true
PORT=3001
SECRET_KEY=dev-secret-key
ENVIRONMENT=development
LOG_LEVEL=debug
```

**`.env-staging`**:
```env
API_URL=https://api-staging.example.com
DATABASE_URL=postgres://localhost:5432/staging
DEBUG=false
PORT=3002
SECRET_KEY=staging-secret-key
ENVIRONMENT=staging
LOG_LEVEL=info
```

### 2. Add to pubspec.yaml Assets

Add your `.env` files to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - .env
    - .env-development
    - .env-staging
```

**Or use wildcard:**
```yaml
flutter:
  assets:
    - .env*
```

### 3. Generate Code

Run the build runner to generate type-safe code:

```bash
flutter pub run build_runner build
```

This creates `lib/gen/enviro.gen.dart` with your environment configuration.

### 4. Use in Your App

```dart
import 'package:your_app/gen/enviro.gen.dart';

void main() async {
  // Initialize with default environment (.env)
  await Enviro.initialize();
  
  // Or set a specific environment
  await Enviro.setEnvironment(EnviroEnvironment.DEVELOPMENT);
  
  // Access your environment variables with type safety
  final apiUrl = Enviro.apiUrl; // String
  final port = Enviro.port; // int
  final debug = Enviro.debug; // bool
  final logLevel = Enviro.logLevel; // String
  
  print('API URL: $apiUrl');
  print('Port: $port');
  print('Debug mode: $debug');
}
```

## 🎯 Advanced Usage

### Environment Switching

```dart
// Switch to staging environment
await Enviro.setEnvironment(EnviroEnvironment.STAGING);

// Switch to production
await Enviro.setEnvironment(EnviroEnvironment.DEFAULT);

// Check current environment
final currentEnv = Enviro.currentEnvironment;
print('Current environment: $currentEnv');
```

### Fallback Mechanism

If a key is missing in the current environment, it automatically falls back to the DEFAULT (`.env`) environment:

```dart
// If API_URL is missing in .env-development, 
// it will use the value from .env
final apiUrl = Enviro.apiUrl;
```

### Type Safety

Enviro automatically detects types based on values across all environments:

```dart
// These are automatically typed based on your .env values
final apiUrl = Enviro.apiUrl;        // String
final port = Enviro.port;           // int  
final debug = Enviro.debug;         // bool
final timeout = Enviro.timeout;     // double
```

## 🔧 Configuration

### Build Configuration

Add to your `build.yaml` (optional):

```yaml
targets:
  $default:
    builders:
      enviro:
        options:
          # Custom options can be added here
```

### Environment File Naming

- `.env` → `DEFAULT` environment
- `.env-development` → `DEVELOPMENT` environment  
- `.env-staging` → `STAGING` environment
- `.env-production` → `PRODUCTION` environment
- `.env-custom-name` → `CUSTOM_NAME` environment

## 🛠️ Development

### Running Build Runner

```bash
# One-time build
flutter pub run build_runner build

# Watch mode (rebuilds on changes)
flutter pub run build_runner watch

# Clean and rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

### Validation

Enviro automatically validates:
- ✅ All `.env` files are included in `pubspec.yaml` assets
- ✅ At least one `.env` file exists
- ✅ `.env` file exists as the default environment
- ✅ Key consistency across environments

## 📝 Generated Code Example

Here's what gets generated in `lib/gen/enviro.gen.dart`:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated by enviro package

import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

/// Available environments
enum EnviroEnvironment {
  DEFAULT,
  DEVELOPMENT,
  STAGING,
}

/// Main class for accessing environment variables
class Enviro {
  Enviro._(); // Private constructor

  /// Set the current environment
  static Future<void> setEnvironment(EnviroEnvironment environment) async {
    _currentEnvironment = environment;
    _isInitialized = false;
    await _loadEnvironment();
  }

  /// Get API_URL from current environment
  static String get apiUrl => _getValue('API_URL');

  /// Get PORT from current environment  
  static int get port => int.parse(_getValue('PORT'));

  /// Get DEBUG from current environment
  static bool get debug => _getValue('DEBUG').toLowerCase() == 'true';

  // ... more getters for each environment variable
}
```

## 🚨 Troubleshooting

### Common Issues

**1. Missing .env files in pubspec.yaml**
```
W [enviro] WARNING: Missing .env files in pubspec.yaml assets: .env-development, .env-staging
```
**Solution:** Add missing files to `pubspec.yaml` assets section.

**2. No .env files found**
```
[enviro] ERROR: No .env files found in project root
```
**Solution:** Create at least a `.env` file in your project root.

**3. .env file not found**
```
[enviro] ERROR: .env file not found in project root
```
**Solution:** Create a `.env` file as the default environment.

**4. Key not found**
```
Exception: Key "API_URL" not found in any environment
```
**Solution:** Add the missing key to your `.env` files.

### Debug Mode

Enable verbose logging by running build_runner with debug flag:

```bash
flutter pub run build_runner build --verbose
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the need for type-safe environment configuration in Flutter
- Built with [build_runner](https://pub.dev/packages/build_runner) and [build](https://pub.dev/packages/build) packages
- Thanks to the Dart and Flutter communities


---

**Made with ❤️ for the Flutter community**