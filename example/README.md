# Enviro Example

This example demonstrates how to use the `enviro` package for type-safe environment configuration in a Flutter app.

## Features Demonstrated

- ✅ Multi-environment configuration
- ✅ Type-safe environment variable access
- ✅ Environment switching at runtime
- ✅ Fallback mechanism
- ✅ Build-time code generation
- ✅ Error handling
- ✅ Material Design 3 UI

## Setup

1. **Create Environment Files**: Follow the instructions in [SETUP.md](SETUP.md) to create the required `.env` files
2. **Install Dependencies**: Run `flutter pub get` to install dependencies
3. **Generate Code**: Run `flutter pub run build_runner build` to generate environment code
4. **Run the App**: Run `flutter run` to see the example in action

## What You'll See

The example app provides:

- **Environment Selector**: A dropdown to switch between different environments
- **Real-time Display**: Shows all environment variables with their current values
- **Type Safety**: Demonstrates automatic type detection (String, int, bool, double)
- **Error Handling**: Shows how the app handles missing environments or variables
- **Fallback Mechanism**: Demonstrates how missing keys fall back to the DEFAULT environment

## Environment Files Required

The example uses four environment files:
- `.env` - Default/Production environment
- `.env-development` - Development environment  
- `.env-staging` - Staging environment
- `.env-production` - Production environment

## Key Features

### Environment Switching
```dart
// Switch to development environment
await Enviro.setEnvironment(EnviroEnvironment.DEVELOPMENT);

// Switch to staging
await Enviro.setEnvironment(EnviroEnvironment.STAGING);
```

### Type-Safe Access
```dart
// These are automatically typed based on your .env values
final apiUrl = Enviro.apiUrl;        // String
final port = Enviro.port;           // int  
final debug = Enviro.debug;         // bool
final timeout = Enviro.timeout;     // double
```

### Error Handling
The app demonstrates proper error handling for:
- Missing environment files
- Missing environment variables
- Invalid environment switching

## Running Tests

```bash
flutter test
```

## Troubleshooting

If you encounter issues:

1. **Missing .env files**: Make sure you've created all required environment files
2. **Build errors**: Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. **Import errors**: Ensure you've run `flutter pub get` after adding the enviro dependency

## Next Steps

After running this example, you can:
- Modify the environment files to see real-time changes
- Add your own environment variables
- Integrate enviro into your own Flutter projects
- Explore the generated code in `lib/gen/enviro.gen.dart`