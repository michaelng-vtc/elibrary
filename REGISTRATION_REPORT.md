# E-Library Registration System

**Developer**: NCW  
**Student ID**: 240437702

## 📋 Assignment Requirements Completed

### ✅ Basic Requirements

1. **Name and ID Display**
   - Clearly displayed on registration page in a prominent card
   - Shows "NCW" and "ID: 240437702"

2. **Registration Form Fields**
   - Username input
   - Password input (protected with *)
   - Confirm password input (protected with *)

3. **Password Protection**
   - Both password fields use `obscureText: true`
   - Characters displayed as asterisks (*)
   - Toggle visibility buttons available

4. **HTTP POST Request**
   - Sends registration data to API server
   - Endpoint: `POST /users/register`
   - Backend: Slim4 PHP framework

5. **Login Capability**
   - Registered users can log in
   - Redirects to home page after successful login
   - Session maintained using SharedPreferences

### ✅ Additional Features

1. **Registration Result Notification**
   - Success message with green SnackBar
   - Error message with red SnackBar
   - Displays specific error messages (username exists, etc.)

2. **Input Validation**
   - Username: 
     - Required field
     - Minimum 3 characters
     - Only letters, numbers, and underscore allowed
   - Password:
     - Required field
     - Minimum 6 characters
   - Confirm Password:
     - Must match password field
   - Real-time validation with error messages

3. **Password Encryption**
   - MD5 encryption using `crypto` package
   - Password encrypted before sending to server
   - Server stores encrypted password

4. **Username Availability Check**
   - Real-time checking via API endpoint
   - Endpoint: `GET /users/check/{username}`
   - Shows visual feedback (checkmark/error icon)
   - Prevents duplicate username registration

5. **Authentication Integration**
   - Complete login/logout system
   - Session management with SharedPreferences
   - Authentication guards on protected routes
   - User info displayed in navigation drawer
   - Automatic redirect to login if not authenticated

6. **Additional Reasonable Features**
   - Responsive design (max-width constraint)
   - Loading states during API calls
   - Navigation between login and register pages
   - Password visibility toggle
   - Professional UI with Material Design 3
   - Gradient header in navigation drawer
   - User-friendly error messages
   - Form validation before submission

## 🏗️ Architecture

### Backend (PHP with Slim4)

**API Endpoints:**
```
POST   /users/register          - Register new user
POST   /users/login             - Login user
GET    /users/check/{username}  - Check username availability
```

**Files:**
- `api/src/services/RegisterUser.php` - Registration logic
- `api/src/services/LoginUser.php` - Login authentication
- `api/src/services/CheckUsername.php` - Username validation
- `api/public/index.php` - Routes configuration

### Frontend (Flutter)

**Services:**
- `lib/services/auth_service.dart` - Authentication service with:
  - User registration
  - User login
  - Username checking
  - Password encryption (MD5)
  - Session management

**Pages:**
- `lib/pages/register_page.dart` - Registration UI
- `lib/pages/login_page.dart` - Login UI
- `lib/pages/home_page.dart` - Main page (authenticated)
- `lib/main.dart` - App entry with authentication guards

**Models:**
- `lib/models/user.dart` - User data model

## 🔐 Security Features

1. **Password Encryption**
   - MD5 hashing on client side
   - Encrypted passwords sent over network
   - Encrypted passwords stored in database

2. **Session Management**
   - SharedPreferences for session storage
   - User ID, username, and admin status stored
   - Automatic session checking on app start

3. **Input Validation**
   - Client-side validation
   - Server-side validation
   - Prevents SQL injection (using PDO prepared statements)

4. **CORS Protection**
   - Configured for web application
   - Allows cross-origin requests

## 📱 User Flow

1. **First Time User:**
   ```
   App Start → Login Page → Click "Register" → 
   Fill Registration Form → Submit → Success Message → 
   Login Page → Enter Credentials → Home Page
   ```

2. **Returning User:**
   ```
   App Start → Checks Session → If Valid: Home Page
   If Invalid: Login Page
   ```

3. **Logout:**
   ```
   Any Page → Open Drawer → Click "Logout" → 
   Clear Session → Login Page
   ```

## 🎨 UI Features

### Registration Page
- Purple theme for distinction
- Student info card (NCW - 240437702)
- Icon-based form fields
- Real-time username validation
- Password strength info
- Loading states
- Success/error notifications

### Login Page
- Blue theme
- Clean, minimal design
- Password visibility toggle
- Navigation to registration

### Authenticated Pages
- User greeting in home page
- Username in app bar
- Logout option in drawer
- Protected routes with auth guards

## 🚀 How to Use

### Setup Backend:
1. Ensure PHP server is running at 192.168.1.195
2. Database "elibrary" must exist with "users" table
3. API accessible at: `http://192.168.1.195/api`

### Run Application:
```bash
flutter run -d chrome
```

### Test Registration:
1. Click "Register" on login page
2. Enter username (min 3 chars, alphanumeric + underscore)
3. Enter password (min 6 chars)
4. Confirm password
5. Click "Register"
6. See success notification
7. Redirected to login page

### Test Login:
1. Enter registered username
2. Enter password
3. Click "Login"
4. Redirected to home page

### Test Features:
- Try duplicate username → Error message
- Try short username → Validation error
- Try mismatched passwords → Validation error
- Check username availability → Real-time feedback
- Toggle password visibility → See/hide password
- Login with account → Access protected pages
- Logout → Return to login page

## 📊 Database Schema

**users table:**
```sql
CREATE TABLE users (
  user_id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  is_admin INT(6) NOT NULL DEFAULT 0,
  UNIQUE (user_id, username)
);
```

## 🔧 Dependencies

**Flutter:**
- `http: ^1.1.0` - API requests
- `crypto: ^3.0.3` - Password encryption
- `shared_preferences: ^2.2.2` - Session management

**PHP:**
- Slim Framework 4
- PDO for MySQL
- JSON response handling

## ✨ Code Quality

- ✅ No compilation errors
- ✅ Proper error handling
- ✅ Clean code structure
- ✅ Responsive design
- ✅ Material Design 3
- ✅ Const constructors
- ✅ Type safety
- ✅ Null safety
- ✅ Proper state management
- ✅ Loading states
- ✅ User feedback

---

**Submission Date**: November 20, 2025  
**Platform**: Flutter Web Application  
**Backend**: PHP Slim4 Framework  
**Database**: MySQL (elibrary)
