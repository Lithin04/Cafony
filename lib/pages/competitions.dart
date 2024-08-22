import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompetitionPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _joinCompetition(String competitionId) async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentReference competitionDoc = _firestore.collection('competitions').doc(competitionId);
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

      // Add user to the competition leaderboard
      await competitionDoc.collection('participants').doc(user.uid).set({
        'username': user.displayName ?? 'Unknown User',
        'userId': user.uid,
        'points': 0, // Initial points for joining
      });

      // Update user's competition list
      await userDoc.update({
        'competitions': FieldValue.arrayUnion([competitionId]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Competitions'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Daily Challenge 1'),
            subtitle: Text('Join and reduce your carbon footprint by 10% today!'),
            trailing: ElevatedButton(
              onPressed: () {
                _joinCompetition('daily_challenge_1');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined Daily Challenge 1')));
              },
              child: Text('Join'),
            ),
          ),
          ListTile(
            title: Text('Daily Challenge 2'),
            subtitle: Text('Use public transport instead of driving.'),
            trailing: ElevatedButton(
              onPressed: () {
                _joinCompetition('daily_challenge_2');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined Daily Challenge 2')));
              },
              child: Text('Join'),
            ),
          ),
        ],
      ),
    );
  }
}