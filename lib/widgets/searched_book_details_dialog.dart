import 'package:book_tracker_app/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchBookDetailDialog extends StatelessWidget {
  const SearchBookDetailDialog({
    Key? key,
    required this.book,
    required FirebaseAuth auth,
    required this.booksCollection,
  })  : _auth = auth,
        super(key: key);

  final Book book;
  final FirebaseAuth _auth;
  final CollectionReference<Object?> booksCollection;

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
            backgroundImage: NetworkImage(book.photoUrl),
            radius: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Category : ${book.categories}',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Page Count : ${book.pageCount}',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Author : ${book.author}',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Published  : ${book.publishedDate}',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: const Color(0xFF000000),
              width: 1.0,
              style: BorderStyle.solid,
            )),
            width: 200,
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  book.description.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
        TextButton(
            onPressed: () {
              Map<String, dynamic> updateBook = book.toMap();

              booksCollection.add(updateBook).then((value) {
                updateBook['user_id'] = _auth.currentUser!.uid;
                updateBook['id'] = value.id;

                booksCollection.doc(value.id).update(updateBook);
              });
              Navigator.of(context).pop();
            },
            child: Text('Save'))
      ],
    );
  }

  List<Widget> CreateBookCard(BuildContext context, List<Book> listOfBooks) {
    List<Widget> children = [];
    for (var book in listOfBooks) {
      children.add(Container(
        width: 160,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Card(
          elevation: 4,
          color: Color(0xFFF6F4FF),
          child: Column(
            children: [
              Expanded(
                child: Image(
                    image: NetworkImage(book.photoUrl),
                    alignment: Alignment.topCenter,
                    height: 120),
              ),
              ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SearchBookDetailDialog(
                            book: book,
                            auth: _auth,
                            booksCollection: booksCollection);
                      });
                },
              )
            ],
          ),
        ),
      ));
    }
    return children;
  }
}
