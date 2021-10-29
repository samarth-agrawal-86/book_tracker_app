import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String? id;
  final String uid;
  final String displayName;
  final String? quote;
  final String? email;
  final String? password;
  final String? profession;
  final String? avatarUrl;

  MUser(
      {this.id,
      required this.uid,
      required this.displayName,
      this.quote,
      this.email,
      this.password,
      this.profession,
      this.avatarUrl});

  factory MUser.fromDocument(DocumentSnapshot data) {
    return MUser(
      id: data.id, //document id
      uid: data.get('uid'),
      displayName: data.get('display_name'),
      quote: data.get('quote'),
      email: data.get('email'),
      password: data.get('password'),
      profession: data.get('profession'),
      avatarUrl: data.get('avatar_url'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'quote': quote,
      'email': email,
      'password': password,
      'profession': profession,
      'avatarUrl': avatarUrl
    };
  }
}
