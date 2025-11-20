class Book {
  final int? bookId;
  final String title;
  final String authors;
  final String publishers;
  final String date;
  final String isbn;
  final int status;
  final int borrowedBy;
  final String? lastUpdated;

  Book({
    this.bookId,
    required this.title,
    required this.authors,
    required this.publishers,
    required this.date,
    required this.isbn,
    this.status = 0,
    this.borrowedBy = -1,
    this.lastUpdated,
  });

  // Convert JSON to Book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'] != null
          ? int.tryParse(json['book_id'].toString())
          : null,
      title: json['title'] ?? '',
      authors: json['authors'] ?? '',
      publishers: json['publishers'] ?? '',
      date: json['date'] ?? '',
      isbn: json['isbn'] ?? '',
      status: json['status'] != null
          ? int.tryParse(json['status'].toString()) ?? 0
          : 0,
      borrowedBy: json['borrowed_by'] != null
          ? int.tryParse(json['borrowed_by'].toString()) ?? -1
          : -1,
      lastUpdated: json['last_updated'],
    );
  }

  // Convert Book object to JSON
  Map<String, dynamic> toJson() {
    return {
      if (bookId != null) 'book_id': bookId,
      'title': title,
      'authors': authors,
      'publishers': publishers,
      'date': date,
      'isbn': isbn,
      'status': status,
      'borrowed_by': borrowedBy,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    };
  }

  // Copy with method for updating book properties
  Book copyWith({
    int? bookId,
    String? title,
    String? authors,
    String? publishers,
    String? date,
    String? isbn,
    int? status,
    int? borrowedBy,
    String? lastUpdated,
  }) {
    return Book(
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      publishers: publishers ?? this.publishers,
      date: date ?? this.date,
      isbn: isbn ?? this.isbn,
      status: status ?? this.status,
      borrowedBy: borrowedBy ?? this.borrowedBy,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  String get statusText => status == 0 ? 'Available' : 'Borrowed';
}
