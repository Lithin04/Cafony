import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/homepage.dart';
import 'pages/loginpage.dart';
import 'pages/competitions.dart';
import 'pages/achievementspage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(  options: FirebaseOptions(
    apiKey: 'key',
    appId: 'id',
    messagingSenderId: 'sendid',
    projectId: 'myapp',
    storageBucket: 'myapp-b9yt18.appspot.com',
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carbon Footprint Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.active) {
        //   return snapshot.hasData ? HomePage() : LoginPage();
        // }
        return AchievementsPage();
      },
    );
  }
}