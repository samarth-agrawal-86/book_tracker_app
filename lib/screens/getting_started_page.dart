import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker_app/screens/login_page.dart';

class GettingStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: Colors.black12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BOOK TRACKER APP',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              '"Read. Change Yourself"',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w200),
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ),
              icon: const Icon(
                Icons.vertical_align_center_sharp,
              ),
              label: const Text(
                'Sign in to your account',
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                padding: EdgeInsets.all(10),
                backgroundColor: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
