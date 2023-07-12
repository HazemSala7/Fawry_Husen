import 'package:fawri_app_refactor/pages/authentication/login_screen/login_screen.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Fawri());
}

class Fawri extends StatelessWidget {
  const Fawri({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fawri',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme:
                GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme)),
        home: LoginScreen());
  }
}
