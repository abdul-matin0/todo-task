import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:todo_task/screens/homepage.dart';
import 'package:todo_task/screens/splashscreen.dart';
import 'package:todo_task/screens/taskpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //     textTheme: GoogleFonts.nunitoSansTextTheme()
      // ),
      initialRoute: '/splash',
      routes: {
        '/splash' : (context) => SplashScreen(),
        '/home' : (context) => HomePage(),
      },
    );
  }
}
