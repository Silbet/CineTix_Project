import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
       theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.white,
          secondary: Color(0xFFA52A2A),
        ),
        // textTheme: TextTheme(
        //   bodyText1: TextStyle(color: Colors.white),
        //   bodyText2: TextStyle(color: Colors.white),
        // ),
      ),
      home: LoginScreen(),
    );
  }
}
