import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController(); // For registration

  bool isRegistering = false; // State to toggle between login and registration

  Future<void> _registerUser() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Add user data to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': usernameController.text,
        'email': emailController.text,
        'points': 0,
        'foodScore': 0,
        'transportScore': 0,
        'electricityScore': 0,
        'achievements': [],
        'competitions': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful!')));
      // Navigate to the home page or another page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to the home page or another page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isRegistering ? 'Register' : 'Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (isRegistering) ...[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ],
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRegistering ? _registerUser : _loginUser,
              child: Text(isRegistering ? 'Register' : 'Login'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isRegistering = !isRegistering; // Toggle between login and registration
                });
              },
              child: Text(isRegistering ? 'Already have an account? Login' : 'Need an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}