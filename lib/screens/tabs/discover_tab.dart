import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../widgets/profile_card.dart';
import '../../services/location_matcher_service.dart';
import '../../theme/app_theme.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  final List<User> _allUsers = [
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
    User(
      id: '6',
      username: 'Yusuf',
      age: 29,
      gender: 'Male',
      city: 'Sokoto',
      state: 'Sokoto',
      bio:
          'Entrepreneur with interests in renewable energy and sustainable development.',
      interests: ['Business', 'Environment', 'Technology', 'Travel'],
      profileImage: null,
    ),
    User(
      id: '7',
      username: 'Aisha',
      age: 25,
      gender: 'Female',
      city: 'Katsina',
      state: 'Katsina',
      bio:
          'Fashion designer and creative artist with a love for traditional textiles.',
      interests: ['Fashion', 'Art', 'Culture', 'Design'],
      profileImage: null,
    ),
    User(
      id: '8',
      username: 'David',
      age: 31,
      gender: 'Male',
      city: 'Benin City',
      state: 'Edo',
      bio:
          'Historian and educator passionate about African heritage and culture.',
      interests: ['History', 'Education', 'Art', 'Culture'],
      profileImage: null,
    ),
  ];

  late List<User> _nearbyUsers = [];
  late User _currentUser;
  int _searchDistance = 1; // Default to same state + neighboring states

  @override
  void initState() {
    super.initState();

    // Simulating current user (in a real app, this would be fetched from auth service)
    _currentUser = User(
      id: 'current_user',
      username: 'You',
      age: 30,
      gender: 'Female',
      city: 'Lagos',
      state: 'Lagos',
      bio: 'Looking for connections nearby',
      interests: ['Music', 'Sports', 'Technology', 'Travel'],
    );

    // Initialize nearby users based on current location
    _updateNearbyUsers();
  }

  void _updateNearbyUsers() {
    setState(() {
      _nearbyUsers = LocationMatcherService.filterUsersByLocation(
          _allUsers, _currentUser,
          maxDistance: _searchDistance);

      // Sort by proximity
      _nearbyUsers = LocationMatcherService.sortUsersByProximity(
          _nearbyUsers, _currentUser);
    });
  }

  void _updateSearchDistance(int distance) {
    setState(() {
      _searchDistance = distance;
      _updateNearbyUsers();
    });
  }

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
              const Icon(Icons.location_on, color: AppTheme.accentPurple),
              const SizedBox(width: 8),
              Text(
                '${_currentUser.city}, ${_currentUser.state}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.accentPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  _showLocationSettings();
                },
                icon: const Icon(Icons.edit_location_alt_outlined),
                label: const Text('Change'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryPurple,
                  side: const BorderSide(color: AppTheme.primaryPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Search distance slider
          Row(
            children: [
              const Text(
                'Distance:',
                style: TextStyle(color: AppTheme.accentPurple),
              ),
              Expanded(
                child: Slider(
                  value: _searchDistance.toDouble(),
                  min: 0,
                  max: 2,
                  divisions: 2,
                  activeColor: AppTheme.primaryPurple,
                  inactiveColor: AppTheme.accentPurple.withOpacity(0.3),
                  label: _getDistanceLabel(_searchDistance),
                  onChanged: (value) {
                    _updateSearchDistance(value.toInt());
                  },
                ),
              ),
              Text(
                _getDistanceLabel(_searchDistance),
                style: const TextStyle(color: AppTheme.accentPurple),
              ),
            ],
          ),
          const SizedBox(height: 10),

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
              color: AppTheme.accentPurple,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Profiles
          Expanded(
            child:
                _nearbyUsers.isEmpty ? _buildEmptyState() : _buildProfileList(),
          ),
        ],
      ),
    );
  }

  String _getDistanceLabel(int distance) {
    switch (distance) {
      case 0:
        return 'Same State';
      case 1:
        return 'Neighboring';
      case 2:
        return 'Extended';
      default:
        return 'Custom';
    }
  }

  void _showLocationSettings() {
    // This would typically show a modal to update location
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.beetleBlack,
        title: const Text('Change Location',
            style: TextStyle(color: AppTheme.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // In a real app, this would be a dropdown or search field
            Text(
              'Current location: ${_currentUser.city}, ${_currentUser.state}',
              style: const TextStyle(color: AppTheme.accentPurple),
            ),
            const SizedBox(height: 20),
            const Text(
              'In a full implementation, this would allow you to select from Nigerian states and major cities.',
              style: TextStyle(color: AppTheme.accentPurple, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  Widget _buildProfileList() {
    return ListView.builder(
      itemCount: _nearbyUsers.length,
      itemBuilder: (context, index) {
        final user = _nearbyUsers[index];
        final bool isSameState = user.state == _currentUser.state;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Stack(
            children: [
              ProfileCard(
                user: user,
                onLike: () {
                  // Handle like action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You liked ${user.username}')),
                  );
                },
                onMessage: () {
                  // Handle message action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Starting chat with ${user.username}')),
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSameState
                        ? AppTheme.primaryPurple
                        : AppTheme.primaryPurple.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSameState ? Icons.location_on : Icons.near_me,
                        color: AppTheme.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.state,
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            color: AppTheme.accentPurple.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'No profiles found nearby',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentPurple,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try expanding your search radius or changing your location',
            style: TextStyle(
              color: AppTheme.accentPurple,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Increase search distance to maximum
              _updateSearchDistance(2);
            },
            icon: const Icon(Icons.search),
            label: const Text('Expand Search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: AppTheme.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
