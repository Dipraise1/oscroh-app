import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/location_matcher_service.dart';
import '../../widgets/profile_card.dart';
import '../../theme/app_theme.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab>
    with AutomaticKeepAliveClientMixin {
  // List of all potential matches (in a real app, this would come from a service)
  final List<User> _potentialMatches = [
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
    User(
      id: '9',
      username: 'Olusegun',
      age: 33,
      gender: 'Male',
      city: 'Ibadan',
      state: 'Oyo',
      bio:
          'Professor of Literature. Loves poetry, jazz, and philosophical discussions.',
      interests: ['Literature', 'Music', 'Philosophy', 'Teaching'],
      profileImage: null,
      isVerified: true,
    ),
    User(
      id: '10',
      username: 'Chinwe',
      age: 24,
      gender: 'Female',
      city: 'Onitsha',
      state: 'Anambra',
      bio:
          'Digital artist and animator. Creating beautiful worlds through art.',
      interests: ['Art', 'Animation', 'Games', 'Technology'],
      profileImage: null,
    ),
  ];

  late User _currentUser;
  late List<User> _matches = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

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

    // Simulate fetching matches from a database
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      // Filter matches by location first
      _matches = LocationMatcherService.filterUsersByLocation(
          _potentialMatches, _currentUser,
          maxDistance: 2 // Include users from neighboring states
          );

      // Sort by proximity
      _matches =
          LocationMatcherService.sortUsersByProximity(_matches, _currentUser);

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          Row(
            children: [
              Expanded(
                child: Text(
                  'People in your state and nearby who might be a good match',
                  style: TextStyle(
                    color: AppTheme.accentPurple,
                    fontSize: 14,
                  ),
                ),
              ),
              if (!_isLoading)
                IconButton(
                  onPressed: _fetchMatches,
                  icon: const Icon(Icons.refresh, color: AppTheme.accentPurple),
                  tooltip: 'Refresh matches',
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Matches List
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : (_matches.isEmpty ? _buildEmptyState() : _buildMatchesList()),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryPurple,
          ),
          const SizedBox(height: 20),
          Text(
            'Finding your matches...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.accentPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList() {
    return ListView.builder(
      itemCount: _matches.length,
      itemBuilder: (context, index) {
        final user = _matches[index];
        final bool isSameState = user.state == _currentUser.state;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Stack(
            children: [
              ProfileCard(
                user: user,
                isMatch: true,
                onLike: () {
                  // Handle unmatch action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Unmatched with ${user.username}')),
                  );
                  setState(() {
                    _matches.removeAt(index);
                  });
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
            Icons.favorite_border,
            size: 80,
            color: AppTheme.accentPurple.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No matches yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentPurple,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'We\'re looking for people in your area. Check back soon!',
              style: TextStyle(
                color: AppTheme.accentPurple,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _fetchMatches(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Matches'),
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
