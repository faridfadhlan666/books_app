class Book {
  // Note properties
  String id;
  String title;
  String author;
  DateTime publishedDate;
  bool isAvailable;

  // Constructor with named parameters
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedDate,
    required this.isAvailable,
  });

  // Factory constructor to create a Book object from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      isAvailable: json['isAvailable'] as bool,
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author, 
      'publishedDate': publishedDate.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }
}