import 'package:flutter/material.dart';
import 'movie_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Booking System',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MovieListScreen(),
    );
  }
}
