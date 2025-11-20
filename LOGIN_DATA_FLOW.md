# Login Feature - Data Flow Diagram

## User Login Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                         USER INTERACTION                          │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│                          LoginPage                                │
│  • Displays CustomTextField (username, password)                 │
│  • Displays PrimaryButton                                        │
│  • Handles form validation                                       │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 │ User clicks "Login"
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│              ref.read(authProvider.notifier).login()              │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│                       AuthNotifier (Provider)                     │
│  1. Validates input (username & password required)               │
│  2. Sets state: isLoading = true                                 │
│  3. Creates LoginRequest model                                   │
│  4. Calls AuthRepository.login()                                 │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│                      AuthRepository                               │
│  1. Encrypts password with MD5                                   │
│  2. Makes HTTP POST to /users/login                              │
│  3. Parses JSON response                                         │
│  4. Returns LoginResponse (freezed model)                        │
└──────────────────────────────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
                    ▼                         ▼
              ┌─────────┐               ┌─────────┐
              │ SUCCESS │               │  ERROR  │
              └─────────┘               └─────────┘
                    │                         │
                    ▼                         ▼
    ┌───────────────────────────┐   ┌──────────────────────┐
    │ AuthNotifier updates:     │   │ AuthNotifier updates:│
    │ • isLoading = false       │   │ • isLoading = false  │
    │ • isAuthenticated = true  │   │ • errorMessage = msg │
    │ • username = user.username│   └──────────────────────┘
    │ • userId = user.userId    │             │
    └───────────────────────────┘             │
                    │                         │
                    ▼                         ▼
    ┌───────────────────────────┐   ┌──────────────────────┐
    │ AuthLocalDataSource       │   │   LoginPage Listens  │
    │ Saves user to             │   │   Shows ErrorDialog  │
    │ SharedPreferences         │   └──────────────────────┘
    └───────────────────────────┘
                    │
                    ▼
    ┌───────────────────────────┐
    │     LoginPage Listens     │
    │   Shows SuccessDialog     │
    │   Navigates to HomePage   │
    └───────────────────────────┘
```

## State Management with Riverpod

```
┌─────────────────────────────────────────────────────────────┐
│                    LoginPage (Consumer)                      │
│                                                              │
│  ref.watch(authProvider) ──────────────┐                    │
│       │                                 │                    │
│       │ Rebuilds when state changes     │                    │
│       ▼                                 │                    │
│  Display UI based on:                   │                    │
│  • authState.isLoading  → Show loading  │                    │
│  • authState.errorMessage → Show dialog │                    │
│  • authState.isAuthenticated → Navigate │                    │
└─────────────────────────────────────────┼──────────────────┘
                                          │
                                          │
                    ┌─────────────────────▼─────────────────┐
                    │       authProvider                     │
                    │   (StateNotifierProvider)              │
                    │                                        │
                    │   Manages AuthState:                   │
                    │   • isLoading: bool                    │
                    │   • isAuthenticated: bool              │
                    │   • username: String?                  │
                    │   • userId: int?                       │
                    │   • isAdmin: bool                      │
                    │   • errorMessage: String?              │
                    └────────────────────────────────────────┘
```

## Component Hierarchy

```
LoginPage (ConsumerStatefulWidget)
├── Form
│   ├── Header (Icon + Title + Subtitle)
│   ├── CustomTextField (Username)
│   │   └── TextFormField + Decoration
│   ├── CustomTextField (Password)
│   │   ├── TextFormField + Decoration
│   │   └── PasswordVisibilityToggle
│   │       └── IconButton
│   ├── PrimaryButton (Login)
│   │   └── ElevatedButton
│   │       ├── Text (when not loading)
│   │       └── CircularProgressIndicator (when loading)
│   └── Register Link
│       └── Row > TextButton
│
└── Dialogs (shown via listeners)
    ├── ErrorDialog (on error)
    ├── SuccessDialog (on success)
    └── LoadingDialog (optional)
```

## Freezed Model Flow

```
API Response (JSON)
        │
        ▼
json_serializable
  fromJson()
        │
        ▼
LoginResponse (freezed)
        │
        ▼
   .toUser()
        │
        ▼
  User (freezed)
        │
        ▼
AuthLocalDataSource
  .saveUser()
        │
        ▼
SharedPreferences
```

## Key Benefits of This Architecture

1. **Unidirectional Data Flow**: UI → Provider → Repository → API
2. **Reactive UI**: State changes automatically update UI
3. **Separation of Concerns**: Each layer has single responsibility
4. **Testability**: Each component can be tested independently
5. **Type Safety**: Compile-time error detection
6. **Immutability**: State cannot be accidentally mutated
7. **Reusability**: Widgets and logic can be easily reused
