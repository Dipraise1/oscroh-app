import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../widgets/profile_card.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  // Dummy list of matched users
  final List<User> _matches = [
    User(
      id: '3',
      username: 'Fatima',
      age: 26,
      gender: 'Female',
      city: 'Kano',
      state: 'Kano',
      bio:
          'Teacher by day, book lover by night. Looking for meaningful conversations.',
      interests: ['Reading', 'Education', 'Art', 'Hiking'],
      profileImage: null,
      isVerified: true,
    ),
    User(
      id: '5',
      username: 'Ngozi',
      age: 27,
      gender: 'Female',
      city: 'Enugu',
      state: 'Enugu',
      bio: 'Medical doctor with a passion for dancing and community service.',
      interests: ['Dancing', 'Healthcare', 'Volunteering', 'Cooking'],
      profileImage: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Matches Header
          Text(
            'Your Matches',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'People who have liked you back',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Matches List
          Expanded(
            child: _matches.isEmpty ? _buildEmptyState() : _buildMatchesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList() {
    return ListView.builder(
      itemCount: _matches.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ProfileCard(
            user: _matches[index],
            isMatch: true,
            onLike: () {
              // Handle unmatch action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Unmatched with ${_matches[index].username}')),
              );
              setState(() {
                _matches.removeAt(index);
              });
            },
            onMessage: () {
              // Handle message action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Starting chat with ${_matches[index].username}')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No matches yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When someone you like also likes you back, they will appear here',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to discover tab
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.explore),
            label: const Text('Discover People'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
