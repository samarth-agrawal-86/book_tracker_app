import 'package:book_tracker_app/widgets/profile_form_text_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker_app/models/user.dart';

class UpdateProfileAlertDialog extends StatelessWidget {
  const UpdateProfileAlertDialog({
    Key? key,
    required this.curUser,
    required this.displayNameTextController,
    required this.professionTextController,
    required this.quoteTextController,
    required this.avatarUrlTextController,
  }) : super(key: key);

  final MUser curUser;
  final TextEditingController displayNameTextController;
  final TextEditingController professionTextController;
  final TextEditingController quoteTextController;
  final TextEditingController avatarUrlTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Profile',
        textAlign: TextAlign.center,
      ),
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: displayNameTextController,
                decoration: ProfileFormTextInputDecoration(
                  forhintText: 'John Doe',
                  forlabelText: 'Your Name',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: professionTextController,
                decoration: ProfileFormTextInputDecoration(
                  forhintText: 'Student, Instructor',
                  forlabelText: 'Profession',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: quoteTextController,
                decoration: ProfileFormTextInputDecoration(
                  forhintText: 'Live. Laugh. Love',
                  forlabelText: 'Favorite Quote',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: avatarUrlTextController,
                decoration: ProfileFormTextInputDecoration(
                  forhintText: 'https://picsum.photos/200/300',
                  forlabelText: 'Avatar URL',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final userChangedName =
                displayNameTextController.text != curUser.displayName;
            final userChangedQuote = quoteTextController.text != curUser.quote;
            final userChangedProfession =
                professionTextController.text != curUser.profession;
            final userChangedAvatar =
                avatarUrlTextController.text != curUser.avatarUrl;

            bool userChanged = userChangedName ||
                userChangedQuote ||
                userChangedProfession ||
                userChangedAvatar;

            if (userChanged) {
              var updateUser = MUser(
                      uid: curUser.uid,
                      displayName: displayNameTextController.text,
                      quote: quoteTextController.text,
                      profession: professionTextController.text,
                      avatarUrl: avatarUrlTextController.text)
                  .toMap();

              FirebaseFirestore.instance
                  .collection('users')
                  .doc(curUser.id)
                  .update(updateUser);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Update'),
          style: TextButton.styleFrom(),
        ),
      ],
    );
  }
}
