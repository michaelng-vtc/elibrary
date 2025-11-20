# Backend Connection Setup - Complete! ✅

## What I've Done:

### 1. Created PHP API Endpoints in `server/api/`:
- ✅ `get_all_books.php` - Retrieves all books from database
- ✅ `add_book.php` - Adds new books
- ✅ `update_book.php` - Updates existing books
- ✅ `delete_book.php` - Deletes books
- ✅ `search_books.php` - Searches books by title/author/ISBN

All APIs include:
- CORS headers for web access
- Proper error handling
- JSON responses
- Database connection using your credentials (root/netlab123)

### 2. Updated Flutter App:
- ✅ Changed API URL to: `http://192.168.1.195/elibrary/server/api`

## Setup Instructions:

### Step 1: Deploy PHP Files to Your Server
Copy the entire `server/` folder to your web server at `192.168.1.195`:
```
server/
├── api/
│   ├── get_all_books.php
│   ├── add_book.php
│   ├── update_book.php
│   ├── delete_book.php
│   └── search_books.php
├── CreateDb.php
├── CreateTableUsers.php
├── CreateTableBooks.php
└── elibrary.sql
```

The files should be accessible at:
`http://192.168.1.195/elibrary/server/api/`

### Step 2: Setup Database (if not already done)
1. Access your PHP files via browser:
   - `http://192.168.1.195/elibrary/server/CreateDb.php`
   - `http://192.168.1.195/elibrary/server/CreateTableUsers.php`
   - `http://192.168.1.195/elibrary/server/CreateTableBooks.php`

2. Or import the SQL file directly in phpMyAdmin/MySQL

### Step 3: Test API Endpoints
Open in browser to verify:
- `http://192.168.1.195/elibrary/server/api/get_all_books.php`

You should see a JSON array (empty or with books from elibrary.sql sample data)

### Step 4: Run Your Flutter App
```bash
flutter run -d chrome
```

## Testing the Connection:

1. **View Books**: Navigate to "All Books" page - should load books from database
2. **Add Book**: Go to "Add Book", fill in details, click "Add Book"
3. **Edit Book**: In "All Books", click three dots menu → Edit
4. **Delete Book**: Click three dots menu → Delete → Confirm
5. **Search**: Use search bar to filter books

## Troubleshooting:

### If you see "Error loading books":
1. Check server is accessible: `http://192.168.1.195/elibrary/server/api/get_all_books.php`
2. Verify database exists and has tables
3. Check MySQL credentials in PHP files (root/netlab123)
4. Check browser console for CORS errors

### CORS Issues (Chrome/Web):
If you see CORS errors, the PHP files already include CORS headers:
```php
header("Access-Control-Allow-Origin: *");
```
This should allow access from any domain.

### Database Connection Issues:
- Verify MySQL is running on 192.168.1.195
- Check credentials: root/netlab123
- Ensure database "elibrary" exists

## File Structure on Server:
```
/var/www/html/elibrary/  (or C:\xampp\htdocs\elibrary\ on Windows)
└── server/
    └── api/
        ├── get_all_books.php
        ├── add_book.php
        ├── update_book.php
        ├── delete_book.php
        └── search_books.php
```

## Quick Verification Commands:

Test from command line (optional):
```bash
# Get all books
curl http://192.168.1.195/elibrary/server/api/get_all_books.php

# Add a book (POST)
curl -X POST http://192.168.1.195/elibrary/server/api/add_book.php \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Book","authors":"Test Author","publishers":"Test Pub","date":"2025-01-01","isbn":"123-456"}'
```

Your app is now configured and ready to connect! 🚀
