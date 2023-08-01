import 'package:flutter/material.dart';
import 'homepage.dart';
import 'shalatpage.dart';
import 'testpage.dart';
import 'weatherpage.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/':(context) => const HomePage(),
          '/shalatpage':(context) => const ShalatPage(),
          '/weatherpage':(context) => const WeatherPage(),
          //'/testpage':(context) => const RequestGet()
        }
    );
  }
}
