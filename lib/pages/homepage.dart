import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController foodController = TextEditingController();
  final TextEditingController transportController = TextEditingController();
  final TextEditingController electricityController = TextEditingController();

  Future<void> _updateScores() async {
    User? user = _auth.currentUser;

    if (user != null) {
      int foodScore = int.tryParse(foodController.text) ?? 0;
      int transportScore = int.tryParse(transportController.text) ?? 0;
      int electricityScore = int.tryParse(electricityController.text) ?? 0;

      // Update user scores in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'foodScore': foodScore,
        'transportScore': transportScore,
        'electricityScore': electricityScore,
        'points': FieldValue.increment(foodScore + transportScore + electricityScore),
      });

      // Update leaderboard
      _updateLeaderboard(user.uid, foodScore, transportScore, electricityScore);

      foodController.clear();
      transportController.clear();
      electricityController.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scores updated successfully!')));
    }
  }

  Future<void> _updateLeaderboard(String userId, int foodScore, int transportScore, int electricityScore) async {
    DocumentReference leaderboardDoc = _firestore.collection('leaderboard').doc(userId);

    // Update or create leaderboard entry for the user
    await leaderboardDoc.set({
      'userId': userId,
      'username': (await _firestore.collection('users').doc(userId).get()).data()?['username'],
      'points': FieldValue.increment(foodScore + transportScore + electricityScore),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carbon Footprint Tracker'),
      ),
      body: Column(
        children: [
          TextField(
            controller: foodController,
            decoration: InputDecoration(labelText: 'Enter Food Score'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: transportController,
            decoration: InputDecoration(labelText: 'Enter Transport Score'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: electricityController,
            decoration: InputDecoration(labelText: 'Enter Electricity Score'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: _updateScores,
            child: Text('Update Daily Score'),
          ),
        ],
      ),
    );
  }
}