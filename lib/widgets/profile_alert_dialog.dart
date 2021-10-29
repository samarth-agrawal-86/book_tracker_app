import 'package:book_tracker_app/models/book.dart';
import 'package:book_tracker_app/utils.dart';
import 'package:book_tracker_app/widgets/update_profile_alert_dialog.dart';
import 'package:book_tracker_app/models/user.dart';
import 'package:book_tracker_app/widgets/profile_form_text_decoration.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker_app/constants.dart';

Widget buildProfileAlertDialog(
    BuildContext context, MUser curUser, List<Book> readBookList) {
  final TextEditingController displayNameTextController =
      TextEditingController(text: curUser.displayName);
  final TextEditingController professionTextController =
      TextEditingController(text: curUser.profession);
  final TextEditingController quoteTextController =
      TextEditingController(text: curUser.quote);
  final TextEditingController avatarUrlTextController =
      TextEditingController(text: curUser.avatarUrl);

  return AlertDialog(
    content: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                curUser.avatarUrl != null
                    ? curUser.avatarUrl.toString()
                    : 'https://picsum.photos/200/300',
              )),
          Text(
            'Books Read (${readBookList.length})',
            style: TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(curUser.displayName),
              TextButton.icon(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.black12,
                ),
                label: Text(''),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateProfileAlertDialog(
                            curUser: curUser,
                            displayNameTextController:
                                displayNameTextController,
                            professionTextController: professionTextController,
                            quoteTextController: quoteTextController,
                            avatarUrlTextController: avatarUrlTextController);
                      });
                  ;
                },
              ),
            ],
          ),
          Text(curUser.profession.toString()),
          Container(
            height: 2,
            width: 100,
            color: Colors.red,
          ),
          Container(
            //margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(12),
            height: 150,
            width: MediaQuery.of(context).size.width * 0.7,
            color: Color(0xFFF1F3F6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'My Favorite Quote',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.black,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    curUser.quote == null
                        ? kDefaultQuote
                        : curUser.quote.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: 12),
            width: MediaQuery.of(context).size.width * 0.7,
            child: ListView.builder(
                itemCount: readBookList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                            title: Text('${readBookList[index].title}'),
                            subtitle: Text('${readBookList[index].author}'),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(readBookList[index].photoUrl),
                              radius: 35,
                            )),
                        Text(
                            'Finished on : ${formatDate(readBookList[index].finishedReading!)}')
                      ],
                    ),
                  );
                }),
          ))
        ],
      ),
    ),
  );
}
