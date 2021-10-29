import 'package:book_tracker_app/models/book.dart';
import 'package:book_tracker_app/widgets/profile_form_text_decoration.dart';
import 'package:book_tracker_app/widgets/searched_book_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class BookSearchPage extends StatefulWidget {
  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController _searchBookTextController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');
  List<Book> listOfBooks = [];

  @override
  void initState() {
    super.initState();
    _searchBookTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Book'),
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchBookTextController,
                  decoration: ProfileFormTextInputDecoration(
                      forhintText: 'The Alchemist', forlabelText: 'Search'),
                  onSubmitted: (value) async => _search(),
                ),
              ),
              (listOfBooks.isEmpty || listOfBooks == null)
                  ? Center(child: Text('Search for Books'))
                  : Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 300,
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: CreateBookCard(context, listOfBooks),
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
      //SizedBox(height: 4.0,),
    );
  }

  void _search() async {
    await fetchBooks(_searchBookTextController.text).then((value) {
      setState(() {
        listOfBooks = value;
      });
    }, onError: (err) {
      throw Exception('Failed to load books ${err.toString()}');
    });
  }

  Future<List<Book>> fetchBooks(String query) async {
    List<Book> books = [];

    var url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
    //var url = Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': query});
    //print(url);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      dynamic data = convert.jsonDecode(response.body);
      Iterable booksList = data['items'];
      for (Map b in booksList) {
        Map tmp = b['volumeInfo'];
        //print(tmp);
        //print(b['volumeInfo']['title']);
        //print(tmp.containsKey('imageLinks'));
        //print(tmp.containsKey('categories'));

        var updateBook = Book(
          title: b['volumeInfo']['title'] ?? 'N/A',
          author: b['volumeInfo']['authors'] == null
              ? 'N/A'
              : b['volumeInfo']['authors'][0],
          photoUrl: tmp.containsKey('imageLinks')
              ? b['volumeInfo']['imageLinks']['thumbnail']
              : kdefaultURIL,
          categories: tmp.containsKey('categories')
              ? b['volumeInfo']['categories'][0]
              : 'N/A',
          publishedDate: b['volumeInfo']['publishedDate'] ?? 'N/A',
          description: b['volumeInfo']['description'] ?? 'N/A',
          pageCount: b['volumeInfo']['pageCount'] ?? 0,
        );
        books.add(updateBook);
      }
      // print(books);
      return books;
    } else {
      throw ('Error: ${response.reasonPhrase}');
    }
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
