import 'package:flutter/material.dart';
import 'package:book_tracker_app/widgets/login_form.dart';
import 'package:book_tracker_app/widgets/sign_up_form.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _createAccount = false;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _pwdTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.green,
              )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  _createAccount
                      ? 'Enter details to Create account'
                      : 'Enter detials to Sign in',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                //_createAccount == true ? print('Create Account form') : print('Sign in form');
                SizedBox(height: 20),
                Container(
                    child: _createAccount
                        ? SignUpForm(
                            formKey: _formKey,
                            emailTextController: _emailTextController,
                            pwdTextController: _pwdTextController)
                        : LoginForm(
                            formKey: _formKey,
                            emailTextController: _emailTextController,
                            pwdTextController: _pwdTextController)),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _createAccount = !_createAccount;
                    });
                  },
                  icon: Icon(Icons.lock),
                  label: _createAccount
                      ? Text('Existing Account Sign in')
                      : Text('Create account'),
                  style: TextButton.styleFrom(
                      primary: Colors.amber,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Container(color: Colors.blue)),
        ],
      ),
    );
  }
}
