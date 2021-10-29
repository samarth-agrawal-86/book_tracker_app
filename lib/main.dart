import 'package:book_tracker_app/screens/login_page.dart';
import 'package:book_tracker_app/screens/main_page.dart';
import 'package:book_tracker_app/screens/page_not_found.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker_app/screens/getting_started_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
            initialData: null,
            create: (context) => FirebaseAuth.instance.authStateChanges())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return RouteController(settingName: settings.name);
          });
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return PageNotFound();
          });
        },
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String? settingName;

  RouteController({required this.settingName});
  @override
  Widget build(BuildContext context) {
    final bool isUserSignedIn = Provider.of<User?>(context) != null;

    if (settingName == '/') {
      return GettingStartedPage();
    } else if (settingName == '/login') {
      return LoginPage();
    } else if (settingName == '/main' && isUserSignedIn == false) {
      return LoginPage();
    } else if (settingName == '/main' && isUserSignedIn == true) {
      return MainPage();
    } else {
      return PageNotFound();
    }
  }
}
