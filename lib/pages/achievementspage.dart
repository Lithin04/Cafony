import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementsPage extends StatefulWidget {
  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchLeaderboardData() async {
    QuerySnapshot snapshot = await _firestore.collection('leaderboard').orderBy('points', descending: true).get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchLeaderboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List<Map<String, dynamic>> leaderboard = snapshot.data!;

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Leaderboard',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    final user = leaderboard[index];
                    return ListTile(
                      title: Text(user['username'] ?? 'Unknown User'),
                      subtitle: Text('Points: ${user['points']}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}