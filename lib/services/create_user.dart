import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

Future<void> createUser(BuildContext context, String displayName, String email,
    String password) async {
  final userCollection = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;

  String uid = auth.currentUser!.uid;

  //User a user map object in this case.We are going to create an actual data class of user
  // but for now we can do something like this
  Map<String, dynamic> user = {
    'display_name': displayName,
    'uid': uid,
    'password': password,
    'email': email,
    'avatar_url': null,
    'profession': 'student',
    'quote': 'Live. Laugh. Love'
  };

  userCollection.add(user);
}
