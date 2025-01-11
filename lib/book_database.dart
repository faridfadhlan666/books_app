import 'package:books_app/book.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookDatabase {
  // Instantiate new database object
  final database = Supabase.instance.client.from('books');

  // Insert a note into the database
  Future<void> insertBook(Book book) async {
    await database.insert(book.toJson());
  }

  // Get a stream of notes from the database
  Stream<List<Book>> getBooksStream(){
    return database.stream(primaryKey: ['id']).map(
      (data) => data.map((json) => Book.fromJson(json)).toList());
  }

  // Update a note in the database
  Future<void> updateBook(Book book) async {
    await database.update(book.toJson()).eq('id', book.id);
  }

  // Delete a note from the database
  Future<void> deleteBook(String id) async {
    await database.delete().eq('id', id);
  }
}