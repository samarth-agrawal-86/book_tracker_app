import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String? id;
  final String title;
  final String author;
  final String? notes;
  final String photoUrl;
  final String? categories;
  final String? publishedDate;
  final double? rating;
  final String? description;
  final int? pageCount;
  final String? userId;
  final Timestamp? startedReading;
  final Timestamp? finishedReading;

  Book(
      {this.id,
      required this.title,
      required this.author,
      this.notes,
      required this.photoUrl,
      this.categories,
      this.publishedDate,
      this.rating,
      this.description,
      this.pageCount,
      this.userId,
      this.startedReading,
      this.finishedReading});

  factory Book.fromDocument(DocumentSnapshot data) {
    return Book(
      id: data.id, //document id
      title: data.get('title'),
      author: data.get('author'),
      notes: data.get('notes'),
      photoUrl: data.get('photo_url'),
      categories: data.get('categories'),
      publishedDate: data.get('published_date'),
      description: data.get('description'),
      rating: data.get('rating'),
      pageCount: data.get('page_count'),
      userId: data.get('user_id'),
      startedReading: data.get('started_reading_at'),
      finishedReading: data.get('finished_reading_at'),
    );
  }

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      id: data['id'],
      title: data['title'],
      author: data['author'],
      notes: data['notes'],
      photoUrl: data['photoUrl'],
      categories: data['categories'],
      publishedDate: data['published_date'],
      description: data['description'],
      rating: data['rating'],
      pageCount: data['pageCount'],
      userId: data['UserId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'notes': notes,
      'photo_url': photoUrl,
      'categories': categories,
      'published_date': publishedDate,
      'description': description,
      'rating': rating,
      'page_count': pageCount,
      'user_id': userId,
      'started_reading_at': startedReading,
      'finished_reading_at': finishedReading,
    };
  }
}
