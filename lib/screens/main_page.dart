import 'package:book_tracker_app/models/book.dart';
import 'package:book_tracker_app/models/user.dart';
import 'package:book_tracker_app/widgets/book_details_dialog.dart';
import 'package:book_tracker_app/widgets/profile_alert_dialog.dart';
import 'package:book_tracker_app/widgets/profile_form_text_decoration.dart';
import 'package:book_tracker_app/widgets/reading_list_book_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'book_search_page.dart';
import 'login_page.dart';

class MainPage extends StatelessWidget {
  CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Book> savedBookList = [];
  List<Book> readingBookList = [];
  List<Book> readBookList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 1.0,
        centerTitle: false,
        title: const Text(
          'Reader App',
          style:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: userCollection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              var userListStream = snapshot.data!.docs
                  .map((DocumentSnapshot user) => MUser.fromDocument(user));

              var userList = userListStream
                  .where((user) => user.uid == _auth.currentUser!.uid)
                  .toList();

              MUser curUser = userList[0];

              return Column(
                children: [
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return buildProfileAlertDialog(
                                  context, curUser, readBookList);
                            });
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(curUser.avatarUrl != null
                            ? curUser.avatarUrl.toString()
                            : 'https://picsum.photos/200/300'),
                      ),
                    ),
                  ),
                  Text(
                    curUser.displayName,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              );
            },
          ),
          TextButton.icon(
            onPressed: () {
              _auth.signOut().then((value) {
                return Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              });
            },
            icon: Icon(Icons.logout),
            label: Text(''),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookSearchPage()),
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, size: 36),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 18, left: 18, bottom: 14),
            height: 60,
            width: double.infinity,
            child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.headline5,
                  children: const [
                    TextSpan(
                        text: 'Your reading \n activity ',
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                      text: 'right now...',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
          ),
          //SizedBox(height: 14,),
          StreamBuilder<QuerySnapshot>(
              stream: booksCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  var bookStream = snapshot.data!.docs
                      .map((DocumentSnapshot book) => Book.fromDocument(book));

                  readingBookList = bookStream
                      .where((book) =>
                          book.userId == _auth.currentUser!.uid &&
                          (book.startedReading != null) &&
                          (book.finishedReading == null))
                      .toList();

                  readBookList = bookStream
                      .where((book) =>
                          book.userId == _auth.currentUser!.uid &&
                          (book.startedReading != null) &&
                          (book.finishedReading != null))
                      .toList();
                } else {
                  readingBookList = [];
                  readBookList = [];
                }

                return Expanded(
                  flex: 1,
                  child: (readingBookList.length > 0)
                      ? ListView.builder(
                          itemCount: readingBookList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return BookDetailsAlertDialog(
                                          book: readingBookList[index]);
                                    });
                              },
                              child: ReadingListCard(
                                  context: context,
                                  book: readingBookList[index]),
                            );
                          })
                      : const Center(
                          child:
                              Text('Not reading any books. Read a book :-)')),
                );
              }),
          Container(
            margin: EdgeInsets.only(top: 18, left: 18, bottom: 14),
            height: 60,
            width: double.infinity,
            child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.headline5,
                  children: const [
                    TextSpan(
                      text: 'Your Saved\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                        text: 'Books...',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))
                  ]),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: booksCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  var bookStream = snapshot.data!.docs
                      .map((DocumentSnapshot book) => Book.fromDocument(book));

                  savedBookList = bookStream
                      .where((book) =>
                          book.userId == _auth.currentUser!.uid &&
                          (book.startedReading == null) &&
                          (book.finishedReading == null))
                      .toList();
                } else {
                  savedBookList = [];
                }
                return Expanded(
                  flex: 1,
                  child: (savedBookList.length > 0)
                      ? ListView.builder(
                          itemCount: savedBookList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return BookDetailsAlertDialog(
                                          book: savedBookList[index]);
                                    });
                              },
                              child: ReadingListCard(
                                book: savedBookList[index],
                                context: context,
                                buttonText: 'Not Started',
                              ),
                            );
                          })
                      : const Center(
                          child: Text('No books founds. Add a book :-)')),
                );
              }),
        ],
      ),
    );
  }
}
