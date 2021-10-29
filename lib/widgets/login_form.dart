import 'package:flutter/material.dart';
import 'package:book_tracker_app/widgets/form_text_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_tracker_app/screens/main_page.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailTextController;
  final TextEditingController pwdTextController;

  LoginForm(
      {required this.formKey,
      required this.emailTextController,
      required this.pwdTextController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailTextController,
                decoration: FormTextInputDecoration(
                  inputIcon: Icons.email_outlined,
                  forhintText: 'John@example.com',
                  forlabelText: 'Email *',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (value) {
                  return (value!.isEmpty) ? 'Please add an email' : null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: pwdTextController,
                obscureText: true,
                decoration: FormTextInputDecoration(
                  inputIcon: Icons.vpn_key,
                  forhintText: 'Enter your password',
                  forlabelText: 'Password *',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (value) {
                  return (value!.isEmpty) ? 'Please provide password' : null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: emailTextController.text,
                      password: pwdTextController.text)
                  .then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              }).catchError((onError) {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Oops!'),
                        content: Text('${onError.message}'),
                      );
                    });
              });
            }
            ;
          },
          icon: const Icon(Icons.business_center_outlined),
          label: const Text('Sign in'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            backgroundColor: Colors.blue,
            primary: Colors.white,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
