import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../widgets/profile_card.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  final List<User> _users = [
    User(
      id: '1',
      username: 'Amaka',
      age: 28,
      gender: 'Female',
      city: 'Lagos',
      state: 'Lagos',
      bio: 'Entrepreneur and fitness enthusiast. Love movies and good food.',
      interests: ['Fitness', 'Movies', 'Travel', 'Cooking'],
      profileImage: null,
    ),
    User(
      id: '2',
      username: 'Emeka',
      age: 32,
      gender: 'Male',
      city: 'Abuja',
      state: 'FCT',
      bio: 'Tech guru who loves football and exploring new restaurants.',
      interests: ['Technology', 'Football', 'Food', 'Music'],
      profileImage: null,
    ),
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
    ),
    User(
      id: '4',
      username: 'Chidi',
      age: 30,
      gender: 'Male',
      city: 'Port Harcourt',
      state: 'Rivers',
      bio: 'Oil & gas professional. Love basketball and playing the guitar.',
      interests: ['Basketball', 'Music', 'Photography', 'Gym'],
      profileImage: null,
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
          // Location Display
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Lagos, Nigeria',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  // Open location selection
                },
                icon: const Icon(Icons.edit_location_alt_outlined),
                label: const Text('Change'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Matches Nearby Text
          Text(
            'People Nearby',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find your vibe, keep your privacy',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Profiles
          Expanded(
            child: _users.isEmpty ? _buildEmptyState() : _buildProfileList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileList() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ProfileCard(
            user: _users[index],
            onLike: () {
              // Handle like action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('You liked ${_users[index].username}')),
              );
            },
            onMessage: () {
              // Handle message action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Starting chat with ${_users[index].username}')),
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
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No profiles found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your location or expanding your search radius',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Refresh the search
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Search'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
