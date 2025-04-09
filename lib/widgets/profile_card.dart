import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileCard extends StatelessWidget {
  final User user;
  final VoidCallback onLike;
  final VoidCallback onMessage;
  final bool isMatch;

  const ProfileCard({
    super.key,
    required this.user,
    required this.onLike,
    required this.onMessage,
    this.isMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header (Avatar & Location)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Anonymous Avatar Circle
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(width: 16),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${user.username}, ${user.age}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (user.isVerified)
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.verified,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${user.city}, ${user.state}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              user.bio,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),

          // Interests
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.interests.map((interest) {
                return Chip(
                  label: Text(
                    interest,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.zero,
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: -2),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Like/Match Button
                ElevatedButton.icon(
                  onPressed: onLike,
                  icon: Icon(
                    isMatch ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                  ),
                  label: Text(isMatch ? 'Matched' : 'Like'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isMatch ? Colors.green : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // Message Button
                OutlinedButton.icon(
                  onPressed: onMessage,
                  icon: const Icon(
                    Icons.message_outlined,
                    size: 20,
                  ),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
