# E-Library Web Application - Setup Guide

## Application Overview

A complete Flutter web application for managing an e-library with the following features:

### Features Implemented ✅

1. **Home Page** - Welcome screen with quick navigation
2. **All Books Page** - View, search, edit, and delete books
3. **Add Book Page** - Add new books with complete information
4. **Navigation Drawer** - Accessible from all pages with consistent branding
5. **Book Management**:
   - Add books (title, authors, publishers, date, ISBN)
   - Edit book information
   - Delete books with confirmation
   - Search functionality (by title, author, ISBN)
   - View book availability status

### Project Structure

```
lib/
├── main.dart                    # App entry point with routing
├── models/
│   ├── book.dart               # Book model matching database schema
│   └── user.dart               # User model
├── services/
│   └── book_service.dart       # API client for book operations
└── pages/
    ├── home_page.dart          # Home screen
    ├── add_book_page.dart      # Add new book form
    └── all_books_page.dart     # Book list with CRUD operations
```

## How to Run

### 1. Run the Flutter Web App

```bash
# Make sure you're in the project directory
cd e:\AndroidApp\elibrary

# Run on Chrome (recommended for web)
flutter run -d chrome

# Or run on any available device
flutter devices
flutter run -d <device-id>
```

### 2. Set Up Backend API (Required)

The app is configured to call PHP APIs at `http://localhost/elibrary/api/`. You need to create these API endpoints:

#### Required API Endpoints:

1. **get_all_books.php** - GET request, returns JSON array of all books
2. **add_book.php** - POST request, receives book JSON, returns success status
3. **update_book.php** - PUT request, receives book JSON with book_id
4. **delete_book.php** - DELETE request, receives book_id parameter
5. **search_books.php** - GET request, receives query parameter

#### API Configuration:

Edit `lib/services/book_service.dart` line 6 to change the base URL:
```dart
static const String baseUrl = 'http://localhost/elibrary/api';
```

### 3. Database Setup

Use the existing files in `server/` folder:
- Run `CreateDb.php` to create database
- Run `CreateTableUsers.php` to create users table
- Run `CreateTableBooks.php` to create books table
- Or import `elibrary.sql` directly

## UI Features

### Icons Used:
- 🏠 Home - Home navigation
- 📚 Books - Library/book icons
- ➕ Add - Add book functionality
- ✏️ Edit - Edit book information
- 🗑️ Delete - Remove books
- 🔍 Search - Search functionality
- 📖 Book details
- 👤 Authors
- 🏢 Publishers
- 📅 Date
- 🔢 ISBN

### Color Scheme:
- **Primary**: Blue - Main theme and home
- **Green**: Add book functionality
- **Orange**: All books/list view
- **Red**: Delete operations
- **Grey**: Secondary information

### Input Hints:
All input fields include:
- Label text (e.g., "Title", "Authors")
- Hint text (e.g., "Enter book title")
- Icon prefixes for visual clarity
- Validation messages

## Navigation Structure

The app uses a consistent navigation drawer accessible from all pages:
1. **Home** - Welcome page
2. **All Books** - Browse and manage books
3. **Add Book** - Add new books
4. **About** - Application information

## Next Steps

1. **Create PHP API endpoints** in your server folder
2. **Configure API URL** in `book_service.dart` to match your setup
3. **Test the connection** by running the app and trying to load books
4. **Customize styling** if needed (colors, fonts, etc.)

## Tips

- Use the **search bar** on All Books page to filter books
- **Edit books** by clicking the three-dot menu on each book card
- **Delete confirmations** prevent accidental deletions
- **Refresh button** in All Books page reloads data from API

## Troubleshooting

If you see API errors:
1. Check that your PHP server is running
2. Verify the API URL in `book_service.dart`
3. Ensure CORS is configured on your PHP server for web access
4. Check browser console for detailed error messages

Enjoy managing your e-library! 📚
