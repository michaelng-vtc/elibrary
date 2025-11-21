import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/models/book.dart';

class BookService {
  // Configure this URL to point to your PHP API endpoint
  // Using Slim4 framework with public/index.php as entry point
  static const String baseUrl = 'http://192.168.1.33/api';

  // Get all books
  Future<List<Book>> getAllBooks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books/all'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  // Add a new book
  Future<bool> addBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Slim4 returns true/false or 1/0 for success
        final result = json.decode(response.body);
        return result == true || result == 1 || result == '1';
      }
      return false;
    } catch (e) {
      throw Exception('Error adding book: $e');
    }
  }

  // Update book information
  Future<bool> updateBook(Book book) async {
    try {
      if (book.bookId == null) {
        throw Exception('Book ID is required for update');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/books/update/${book.bookId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      if (response.statusCode == 200) {
        // Slim4 returns true/false or 1/0 for success
        final result = json.decode(response.body);
        return result == true || result == 1 || result == '1';
      }
      return false;
    } catch (e) {
      throw Exception('Error updating book: $e');
    }
  }

  // Delete a book
  Future<bool> deleteBook(int bookId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/books/delete/$bookId'),
      );

      if (response.statusCode == 200) {
        // Slim4 returns true/false or 1/0 for success
        final result = json.decode(response.body);
        return result == true || result == 1 || result == '1';
      }
      return false;
    } catch (e) {
      throw Exception('Error deleting book: $e');
    }
  }

  // Search books by title (client-side filtering as no search endpoint exists)
  Future<List<Book>> searchBooks(String query) async {
    try {
      // Get all books and filter locally since there's no search endpoint
      final allBooks = await getAllBooks();
      if (query.isEmpty) {
        return allBooks;
      }
      return allBooks
          .where(
            (book) =>
                book.title.toLowerCase().contains(query.toLowerCase()) ||
                book.authors.toLowerCase().contains(query.toLowerCase()) ||
                book.isbn.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }
}
