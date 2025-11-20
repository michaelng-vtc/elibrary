# Copilot Instructions - elibrary

## Project Overview
This is a Flutter multi-platform e-library application (Android, iOS, Web, Windows, Linux, macOS) with a PHP/MySQL backend for managing books and users. The Flutter frontend is in early development with minimal UI.

**Current State**: 
- Frontend: Bare-bones "Hello World" app with single entry point in `lib/main.dart`
- Backend: Complete PHP API with MySQL database schema in `server/` folder

## Development Environment

### Flutter SDK Requirements
- **SDK Version**: `^3.10.0` (specified in `pubspec.yaml`)
- Uses `flutter_lints: ^6.0.0` for code quality enforcement

### Platform Support
All platforms are configured and ready:
- **Android**: Kotlin-based, uses Gradle KTS build scripts
- **iOS/macOS**: Swift-based with Xcode projects
- **Web**: Standard HTML entry point
- **Desktop (Windows/Linux)**: CMake-based builds

### Key Configuration Details

**Android Build System**:
- Uses Gradle Kotlin DSL (`.kts` files, not `.gradle`)
- Namespace: `com.example.elibrary`
- Min SDK: Controlled by Flutter plugin
- Target SDK/Compile SDK: Controlled by Flutter plugin
- **Important**: Custom build directory structure places Android builds in `../../build` (outside the `android/` folder) to avoid workspace clutter. See `android/build.gradle.kts` lines 8-16.

**Application Identity**:
- Android: Package `com.example.elibrary`, label "elibrary"
- iOS: Display name "Elibrary", bundle name "elibrary"

## Project Structure & Conventions

### Current Architecture
```
lib/
  main.dart          # Single entry point, MaterialApp with StatelessWidget
```

**Note**: No architectural patterns established yet. As the app grows, consider:
- Feature-based folder structure (e.g., `lib/features/`)
- Separation of UI, business logic, and data layers
- State management solution (Provider, Riverpod, Bloc, etc.)

### Code Style
- Uses `package:flutter_lints/flutter.yaml` - follow all lint rules
- Const constructors are enforced where possible (e.g., `const MainApp()`)
- Prefer `super.key` parameter pattern in widget constructors

## Backend API (PHP/MySQL with Slim4)

### Framework & Structure
- **Framework**: Slim4 PHP micro-framework
- **Entry Point**: `api/public/index.php`
- **Services**: Located in `api/src/services/`
- **Database Class**: `api/Db.php` handles connections

### API Endpoints
Base URL: `http://192.168.1.195/elibrary/api/public`

- **GET** `/books/all` - Fetch all books
- **POST** `/books/add` - Add new book (JSON body: title, authors, publishers, date, isbn)
- **PUT** `/books/update/{book_id}` - Update book by ID (JSON body: title, authors, publishers, date, isbn)
- **DELETE** `/books/delete/{book_id}` - Delete book by ID

All endpoints return JSON. Success operations return `true`/`1`, failures return error messages.

### Database Schema
Located in `api/elibrary.sql` with two main tables:

**`users` table**:
- `user_id` (INT, auto-increment, primary key)
- `username` (VARCHAR(50), unique)
- `password` (VARCHAR(50)) - stores plain text or MD5 hashed passwords
- `is_admin` (INT, default 0) - 0 for regular users, 1 for admins

**`books` table**:
- `book_id` (INT, auto-increment, primary key)
- `title` (VARCHAR(50), unique)
- `authors` (VARCHAR(50))
- `publishers` (VARCHAR(50))
- `date` (VARCHAR(50)) - publication date
- `isbn` (VARCHAR(50), unique)
- `status` (INT, default 0) - 0 = available, 1 = borrowed
- `borrowed_by` (INT, default -1) - user_id of borrower, -1 if available
- `last_updated` (TIMESTAMP) - auto-updates on record changes

### Server Configuration
- **Host**: localhost
- **Database**: elibrary
- **Default credentials** (in Db.php): root/netlab123
- **Setup scripts**:
  - `CreateDb.php` - Creates the elibrary database
  - `CreateTableUsers.php` - Creates users table
  - `CreateTableBooks.php` - Creates books table
  - `elibrary.sql` - Complete schema with sample data

**Security Note**: PHP files contain hardcoded credentials. These should be secured before production deployment.

### Flutter Integration
- API service: `lib/services/book_service.dart`
- Base URL configured for: `http://192.168.1.195/elibrary/api/public`
- All CRUD operations use Slim4 RESTful routes
- Search functionality implemented client-side (filters all books locally)

## Development Workflows

### Running the App
```bash
# Development on default device
flutter run

# Specific platform
flutter run -d windows      # Windows
flutter run -d chrome       # Web
flutter run -d <device-id>  # Android/iOS device

# List available devices
flutter devices

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
```

### Building

```bash
# Android APK (debug)
flutter build apk

# Android App Bundle (release)
flutter build appbundle

# iOS (requires macOS)
flutter build ios

# Web
flutter build web

# Windows executable
flutter build windows
```

### Dependency Management
```bash
# Install dependencies after adding to pubspec.yaml
flutter pub get

# Add new package
flutter pub add <package_name>

# Add dev dependency
flutter pub add --dev <package_name>

# Update all packages
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

### Code Quality
```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Format code
dart format lib/
```

## Common Tasks

### Adding Dependencies
1. Edit `pubspec.yaml` under `dependencies:` or `dev_dependencies:`
2. Run `flutter pub get`
3. Import in Dart files: `import 'package:<package_name>/<file>.dart';`

### Creating New Screens/Widgets
- Place in `lib/` (for now) or organize by feature/module as project grows
- Use StatelessWidget for static content
- Use StatefulWidget for interactive/dynamic content
- Always include `const` constructors when widgets have no mutable fields

### Platform-Specific Code
- **Method Channels**: For native platform integration (iOS/Android)
- **Conditional imports**: For web vs mobile differences
- Check `defaultTargetPlatform` or use `Platform.isX` (dart:io)

### Testing
No test files exist yet. When adding tests:
- Unit tests: `test/unit/`
- Widget tests: `test/widget/`
- Integration tests: `integration_test/`
- Run with `flutter test`

## Important Notes

- **Build Output Location**: Android builds go to `build/` in project root, not `android/build/`, due to custom configuration in `android/build.gradle.kts`
- **No External Dependencies**: Project currently has zero third-party packages. Verify requirements before suggesting packages.
- **Material Design**: App uses Material Design by default (`uses-material-design: true` in pubspec.yaml)
- **Flutter Embedding v2**: Android uses Flutter Embedding v2 (see `AndroidManifest.xml`)

## Next Steps for Growth

As the app evolves, consider documenting:
- Navigation strategy (named routes, GoRouter, etc.)
- State management approach
- API integration patterns
- Asset management (images, fonts, etc.)
- Localization/internationalization
- Error handling and logging conventions
