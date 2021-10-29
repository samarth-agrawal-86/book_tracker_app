import 'dart:ui';

import 'package:book_tracker_app/models/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker_app/constants.dart';

class ReadingListCard extends StatelessWidget {
  final Book book;
  final BuildContext context;

  final String buttonText;

  const ReadingListCard(
      {Key? key,
      required this.book,
      required this.context,
      this.buttonText = 'Reading'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 24, bottom: 0),
        width: 202,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 244,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: kShadowColor,
                        offset: Offset(10, 10),
                        blurRadius: 20,
                      )
                    ]),
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Image(
                  image: NetworkImage(book.photoUrl),
                  alignment: Alignment.topCenter,
                  height: 145),
            ),
            Positioned(
                top: 35,
                right: 10,
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.favorite_border)),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: kShadowColor,
                                offset: Offset(3, 7),
                                blurRadius: 30)
                          ]),
                      child: Column(
                        children: [
                          Icon(Icons.star, color: kIconColor, size: 15),
                          Text(
                            book.rating == null ? '0' : book.rating.toString(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                )),
            Positioned(
                top: 160,
                left: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                              style: TextStyle(color: kBlackColor),
                              children: [
                                TextSpan(
                                    text: '${book.title}\n',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                TextSpan(
                                    text: book.author,
                                    style: TextStyle(color: kLightBlackColor))
                              ])),
                    ),
                    Row(children: [
                      Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Details')),
                      Container(
                          width: 92,
                          height: 31,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            buttonText,
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              color: kLightPurple,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  bottomRight: Radius.circular(28)))),
                    ]),
                  ],
                )),
          ],
        ));
  }
}
