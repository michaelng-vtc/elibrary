# Project Structure - Organized by Features

## New Directory Structure

```
lib/
├── core/                          # Shared/common code
│   └── models/                    # Shared data models
│       ├── book.dart             # Book model
│       ├── user.dart             # User model
│       └── models.dart           # Barrel export file
│
├── features/                      # Feature-based modules
│   ├── auth/                     # Authentication feature (Pre-login)
│   │   ├── models/               # Auth-specific models
│   │   │   ├── auth_state.dart
│   │   │   ├── login_request.dart
│   │   │   ├── login_response.dart
│   │   │   └── user.dart
│   │   ├── pages/                # Auth pages
│   │   │   ├── login_page.dart   # Login screen (clean architecture)
│   │   │   └── register_page.dart # Registration screen
│   │   ├── providers/            # State management
│   │   │   └── auth_provider.dart # Riverpod auth provider
│   │   ├── repositories/         # Data layer
│   │   │   ├── auth_repository.dart
│   │   │   └── auth_local_datasource.dart
│   │   ├── widgets/              # Reusable auth widgets
│   │   │   ├── custom_text_field.dart
│   │   │   ├── primary_button.dart
│   │   │   ├── password_visibility_toggle.dart
│   │   │   └── dialogs.dart
│   │   └── auth.dart             # Barrel export file
│   │
│   ├── home/                     # Home feature (Post-login)
│   │   ├── pages/
│   │   │   └── home_page.dart    # Main dashboard
│   │   └── home.dart             # Barrel export file
│   │
│   └── books/                    # Book management feature (Post-login)
│       ├── pages/
│       │   ├── add_book_page.dart    # Add new book
│       │   └── all_books_page.dart   # View/edit books
│       └── books.dart            # Barrel export file
│
├── services/                      # Business logic services
│   ├── auth/                     # Authentication services
│   │   └── auth_service.dart
│   ├── book/                     # Book CRUD services
│   │   └── book_service.dart
│   └── services.dart             # Barrel export file
│
└── main.dart                      # App entry point

```

## Organization Principles

### 1. **Pre-Login vs Post-Login Separation**

#### Pre-Login Features (Unauthenticated)
- `features/auth/` - Login and registration
  - Uses clean architecture with Riverpod
  - Pop-up dialogs for feedback
  - Immutable models with freezed

#### Post-Login Features (Authenticated)
- `features/home/` - Dashboard/home page
- `features/books/` - Book management
  - Protected by AuthGuard
  - Access to full app functionality

### 2. **Feature-First Structure**

Each feature is self-contained with:
- **pages/** - UI screens
- **models/** (if needed) - Feature-specific models
- **providers/** (if using Riverpod) - State management
- **repositories/** (if needed) - Data access
- **widgets/** (if needed) - Reusable components
- **[feature].dart** - Barrel export file

### 3. **Core Directory**

Shared code used across features:
- **models/** - Data models (Book, User)
- Can be extended with:
  - utils/
  - constants/
  - theme/
  - config/

### 4. **Services Directory**

Business logic separated by domain:
- `auth/` - Authentication operations
- `book/` - Book CRUD operations

## Import Patterns

### Using Barrel Exports
```dart
// Instead of multiple imports
import 'features/books/pages/add_book_page.dart';
import 'features/books/pages/all_books_page.dart';

// Use barrel export
import 'features/books/books.dart';
```

### Direct Imports
```dart
// Core models
import 'core/models/book.dart';

// Specific page
import 'features/auth/pages/login_page.dart';

// Services
import 'services/book/book_service.dart';
```

## Benefits of This Structure

### 1. **Clear Separation**
- Pre-login (auth) and post-login (home, books) features are separated
- Easy to understand what requires authentication

### 2. **Scalability**
- Add new features as independent modules
- Each feature folder is self-contained

### 3. **Maintainability**
- Find code quickly by feature
- Changes in one feature don't affect others

### 4. **Clean Architecture**
- Login feature uses enterprise patterns (Riverpod + freezed)
- Other features can be gradually refactored

### 5. **Code Reusability**
- Shared models in `core/`
- Shared services available to all features

## Migration Notes

### Old Structure → New Structure

| Old Path | New Path |
|----------|----------|
| `lib/pages/login_page.dart` | `lib/features/auth/pages/login_page.dart` |
| `lib/pages/register_page.dart` | `lib/features/auth/pages/register_page.dart` |
| `lib/pages/home_page.dart` | `lib/features/home/pages/home_page.dart` |
| `lib/pages/add_book_page.dart` | `lib/features/books/pages/add_book_page.dart` |
| `lib/pages/all_books_page.dart` | `lib/features/books/pages/all_books_page.dart` |
| `lib/models/book.dart` | `lib/core/models/book.dart` |
| `lib/models/user.dart` | `lib/core/models/user.dart` |

### Import Updates

All imports have been updated to use the new paths. The app compiles without errors.

## Next Steps to Improve

### 1. **Refactor Other Features**
Apply clean architecture to books and home features:
- Create providers for state management
- Use freezed for models
- Extract widgets into reusable components

### 2. **Add More Core Utilities**
```
core/
├── constants/
│   └── api_constants.dart
├── theme/
│   └── app_theme.dart
└── utils/
    └── validators.dart
```

### 3. **Feature Modules**
Add more features as needed:
```
features/
├── profile/
├── settings/
└── search/
```

## Verification

✅ No compilation errors
✅ All imports updated
✅ Old files removed
✅ Clean separation of concerns
✅ Feature-first organization complete
