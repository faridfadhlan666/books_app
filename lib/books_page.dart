import 'package:books_app/book.dart';
import 'package:books_app/book_database.dart';
import 'package:flutter/material.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final textController = TextEditingController();
  final _bookDatabase = BookDatabase();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: StreamBuilder(
        stream: _bookDatabase.getBooksStream(),
        builder: (context, snapshot) {
          // loading ...
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          final books = snapshot.data!;

          // List of books
          return ListView.builder(
            itemCount: books.length,
            // Use ListTile widget to show books data
            itemBuilder: (context, index) => ListTile(
              title: Text(books[index].title),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => editBook(books[index]),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => deleteBook(books[index].id),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBook,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addNewBook() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new book'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Create a new book
              final book = Book(
                id: '',
                title: _titleController.text,
                author: _authorController.text,
                publishedDate: DateTime.now(),
                isAvailable: true,
              );

              // Save the book to the database
              _bookDatabase.insertBook(book);

              // Close the dialog
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void editBook(Book book) {
    // Set the text controllers to the book's title and author
    _titleController.text = book.title;
    _authorController.text = book.author;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Update the book
              book.title = _titleController.text;
              book.author = _authorController.text;
              _bookDatabase.updateBook(book);

              // Close the dialog
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Delete a book
  void deleteBook(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete book'),
        actions: [
          TextButton(
            onPressed: () {
              // Delete book data based on id
              _bookDatabase.deleteBook(id);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
