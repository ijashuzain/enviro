# Enviro Package Example

This directory contains a complete example Flutter application demonstrating the `enviro` package usage.

## 📁 Directory Structure

```
example/
├── lib/
│   ├── gen/
│   │   └── enviro.gen.dart          # Generated environment code
│   └── main.dart                    # Main Flutter app
├── test/
│   ├── enviro_test.dart             # Tests for generated code
│   └── widget_test.dart             # Widget tests
├── assets/                          # Environment files go here
├── pubspec.yaml                     # Dependencies and configuration
├── build.yaml                       # Build configuration
├── analysis_options.yaml            # Linting rules
├── .gitignore                       # Git ignore rules
├── README.md                        # Example documentation
└── SETUP.md                         # Setup instructions
```

## 🚀 Quick Start

1. **Create Environment Files**: Copy the content from `SETUP.md` to create `.env` files
2. **Install Dependencies**: `flutter pub get`
3. **Generate Code**: `flutter pub run build_runner build`
4. **Run Example**: `flutter run`

## ✨ Features Demonstrated

- **Multi-Environment Support**: Switch between development, staging, and production
- **Type-Safe Access**: Automatic type detection for environment variables
- **Runtime Switching**: Change environments without app restart
- **Fallback Mechanism**: Missing keys fall back to DEFAULT environment
- **Error Handling**: Graceful handling of missing files or variables
- **Material Design 3**: Modern Flutter UI with proper theming

## 🔧 Environment Variables

The example uses these environment variables:
- `API_URL` (String) - API endpoint URL
- `DATABASE_URL` (String) - Database connection string
- `DEBUG` (bool) - Debug mode flag
- `PORT` (int) - Server port number
- `SECRET_KEY` (String) - Application secret key
- `ENVIRONMENT` (String) - Environment name
- `LOG_LEVEL` (String) - Logging level
- `TIMEOUT` (double) - Request timeout
- `MAX_RETRIES` (int) - Maximum retry attempts
- `ENABLE_ANALYTICS` (bool) - Analytics toggle

## 🧪 Testing

Run the example tests:
```bash
flutter test
```

## 📱 Screenshots

The example app provides:
- Environment selector dropdown
- Real-time environment variable display
- Error handling UI
- Success/error notifications
- Material Design 3 theming

## 🔗 Integration

This example shows how to integrate `enviro` into your Flutter projects:
1. Add `enviro` dependency
2. Create environment files
3. Add files to `pubspec.yaml` assets
4. Run build_runner
5. Import and use generated code

## 📚 Learn More

- [Main Package README](../README.md)
- [Pub.dev Package Page](https://pub.dev/packages/enviro)
- [GitHub Repository](https://github.com/yourusername/enviro)
