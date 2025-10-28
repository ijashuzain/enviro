# Environment Files Setup

This example requires you to create the following environment files in the `example/` directory:

## Required Files

### 1. `.env` (Default/Production)
```env
API_URL=https://api.example.com
DATABASE_URL=postgres://localhost:5432/production
DEBUG=false
PORT=3000
SECRET_KEY=prod-secret-key-12345
ENVIRONMENT=production
LOG_LEVEL=error
TIMEOUT=30.5
MAX_RETRIES=3
ENABLE_ANALYTICS=true
```

### 2. `.env-development`
```env
API_URL=https://api-dev.example.com
DATABASE_URL=postgres://localhost:5432/development
DEBUG=true
PORT=3001
SECRET_KEY=dev-secret-key-67890
ENVIRONMENT=development
LOG_LEVEL=debug
TIMEOUT=60.0
MAX_RETRIES=5
ENABLE_ANALYTICS=false
```

### 3. `.env-staging`
```env
API_URL=https://api-staging.example.com
DATABASE_URL=postgres://localhost:5432/staging
DEBUG=false
PORT=3002
SECRET_KEY=staging-secret-key-54321
ENVIRONMENT=staging
LOG_LEVEL=info
TIMEOUT=45.0
MAX_RETRIES=4
ENABLE_ANALYTICS=true
```

### 4. `.env-production`
```env
API_URL=https://api-prod.example.com
DATABASE_URL=postgres://localhost:5432/production
DEBUG=false
PORT=3000
SECRET_KEY=production-secret-key-98765
ENVIRONMENT=production
LOG_LEVEL=error
TIMEOUT=30.0
MAX_RETRIES=3
ENABLE_ANALYTICS=true
```

## Setup Instructions

1. Create the above files in the `example/` directory
2. Run `flutter pub get` to install dependencies
3. Run `flutter pub run build_runner build` to generate environment code
4. Run `flutter run` to see the example in action

## Features Demonstrated

- ✅ Environment switching at runtime
- ✅ Type-safe variable access
- ✅ Fallback mechanism (missing keys fall back to DEFAULT)
- ✅ Error handling for missing environments
- ✅ Real-time environment variable display
- ✅ Material Design 3 UI
