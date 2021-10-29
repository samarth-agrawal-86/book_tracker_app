import 'package:book_tracker_app/models/book.dart';
import 'package:book_tracker_app/screens/main_page.dart';
import 'package:book_tracker_app/widgets/profile_form_text_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker_app/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_tracker_app/utils.dart';

class BookDetailsAlertDialog extends StatefulWidget {
  final Book book;

  const BookDetailsAlertDialog({required this.book});

  @override
  State<BookDetailsAlertDialog> createState() => _BookDetailsAlertDialogState();
}

class _BookDetailsAlertDialogState extends State<BookDetailsAlertDialog> {
  bool isReading = false;
  bool isFinished = false;
  double? userDefinedRating;
  TextEditingController bookTitleController = TextEditingController();
  TextEditingController bookAuthorController = TextEditingController();
  TextEditingController bookURLController = TextEditingController();
  TextEditingController bookNotesController = TextEditingController();

  CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');
  @override
  void initState() {
    super.initState();
    bookTitleController = TextEditingController(text: widget.book.title);
    bookAuthorController = TextEditingController(text: widget.book.author);
    bookURLController = TextEditingController(text: widget.book.photoUrl);
    bookNotesController = TextEditingController(text: widget.book.notes);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Book Details',
        textAlign: TextAlign.center,
      ),
      content: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.book.photoUrl),
          ),
          Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: bookTitleController,
                    decoration: ProfileFormTextInputDecoration(
                        forhintText: 'Book Name', forlabelText: 'Book Name'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: bookAuthorController,
                    decoration: ProfileFormTextInputDecoration(
                        forhintText: 'Author', forlabelText: 'Author'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: bookURLController,
                    decoration: ProfileFormTextInputDecoration(
                        forhintText: 'Book Cover Link',
                        forlabelText: 'Book Cover Link'),
                  ),
                  (widget.book.startedReading != null || isReading)
                      ? TextButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.book,
                            color: Colors.grey,
                          ),
                          label: widget.book.startedReading == null
                              ? Text(
                                  'Started Reading... ',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : Text(
                                  'Started Reading at ${formatDate(widget.book.startedReading!)} ',
                                  style: TextStyle(color: Colors.grey),
                                ),
                        )
                      : TextButton.icon(
                          onPressed: () {
                            setState(() {
                              isReading = true;
                            });
                          },
                          icon: const Icon(
                            Icons.book,
                            color: Colors.blue,
                          ),
                          label: const Text(
                            'Start Reading',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                  (widget.book.finishedReading != null || isFinished)
                      ? TextButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            'Finished Reading : }',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : TextButton.icon(
                          onPressed: () {
                            setState(() {
                              isFinished = true;
                            });
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.blue,
                          ),
                          label: const Text(
                            'Mark as Read',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                  RatingBar.builder(
                      initialRating: widget.book.rating == null
                          ? 0
                          : widget.book.rating!.toDouble(),
                      itemCount: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemBuilder: (context, ix) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                      onRatingUpdate: (rating) => userDefinedRating = rating),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: bookNotesController,
                    decoration: ProfileFormTextInputDecoration(
                        forhintText: 'Your thoughts',
                        forlabelText: 'Your thoughts'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      actions: [
        TextButton.icon(
          style: TextButton.styleFrom(primary: Colors.grey.shade600),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                        'Are you sure you want to delete this book from your collection'),
                    actions: [
                      TextButton(
                          style: TextButton.styleFrom(
                              primary: Colors.grey.shade600),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No')),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              primary: Colors.white),
                          onPressed: () {
                            booksCollection.doc(widget.book.id).delete();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()));
                          },
                          child: Text('Yes')),
                    ],
                  );
                });
          },
          icon: Icon(Icons.delete_outline_outlined),
          label: Text('Delete'),
        ),
        TextButton.icon(
          onPressed: () {
            Map<String, dynamic> updateBook = {
              'title': bookTitleController.text,
              'author': bookAuthorController.text,
              'photo_url': bookURLController.text,
              'rating': userDefinedRating == null
                  ? widget.book.rating
                  : userDefinedRating,
              'notes': bookNotesController.text,
              'started_reading_at':
                  isReading ? Timestamp.now() : widget.book.startedReading,
              'finished_reading_at':
                  isFinished ? Timestamp.now() : widget.book.finishedReading,
            };
            booksCollection.doc(widget.book.id).update(updateBook);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          },
          icon: Icon(Icons.save_alt_outlined),
          label: Text('Update'),
          style: TextButton.styleFrom(
              backgroundColor: Colors.blue, primary: Colors.white),
        ),
      ],
    );
  }
}
