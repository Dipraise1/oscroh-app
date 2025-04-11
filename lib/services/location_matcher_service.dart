import '../models/user_model.dart';

class LocationMatcherService {
  // List of Nigerian states with their neighboring states
  static const Map<String, List<String>> stateNeighbors = {
    'Abia': ['Imo', 'Anambra', 'Enugu', 'Ebonyi', 'Rivers'],
    'Adamawa': ['Borno', 'Gombe', 'Taraba'],
    'Akwa Ibom': ['Cross River', 'Rivers', 'Abia'],
    'Anambra': ['Enugu', 'Delta', 'Imo', 'Abia', 'Kogi'],
    'Bauchi': ['Yobe', 'Gombe', 'Plateau', 'Kaduna', 'Jigawa', 'Kano'],
    'Bayelsa': ['Rivers', 'Delta'],
    'Benue': ['Nasarawa', 'Taraba', 'Cross River', 'Enugu', 'Kogi'],
    'Borno': ['Yobe', 'Adamawa', 'Gombe'],
    'Cross River': ['Benue', 'Ebonyi', 'Abia', 'Akwa Ibom'],
    'Delta': ['Edo', 'Anambra', 'Imo', 'Bayelsa', 'Rivers'],
    'Ebonyi': ['Benue', 'Enugu', 'Abia', 'Cross River'],
    'Edo': ['Kogi', 'Delta', 'Ondo', 'Anambra'],
    'Ekiti': ['Ondo', 'Osun', 'Kwara', 'Kogi'],
    'Enugu': ['Benue', 'Kogi', 'Anambra', 'Abia', 'Ebonyi'],
    'FCT': ['Nasarawa', 'Kaduna', 'Kogi', 'Niger'],
    'Gombe': ['Borno', 'Yobe', 'Adamawa', 'Bauchi', 'Taraba'],
    'Imo': ['Abia', 'Anambra', 'Rivers', 'Delta'],
    'Jigawa': ['Kano', 'Bauchi', 'Yobe', 'Katsina'],
    'Kaduna': [
      'Zamfara',
      'Katsina',
      'Kano',
      'Bauchi',
      'Plateau',
      'Nasarawa',
      'Niger',
      'FCT'
    ],
    'Kano': ['Katsina', 'Jigawa', 'Bauchi', 'Kaduna'],
    'Katsina': ['Zamfara', 'Kaduna', 'Kano', 'Jigawa'],
    'Kebbi': ['Sokoto', 'Zamfara', 'Niger'],
    'Kogi': [
      'Niger',
      'Kwara',
      'Ekiti',
      'Ondo',
      'Edo',
      'Anambra',
      'Enugu',
      'Benue',
      'Nasarawa',
      'FCT'
    ],
    'Kwara': ['Niger', 'Kogi', 'Ekiti', 'Osun', 'Oyo'],
    'Lagos': ['Ogun'],
    'Nasarawa': ['Kaduna', 'Plateau', 'Taraba', 'Benue', 'Kogi', 'FCT'],
    'Niger': ['Kebbi', 'Zamfara', 'Kaduna', 'FCT', 'Kogi', 'Kwara'],
    'Ogun': ['Lagos', 'Oyo', 'Ondo', 'Osun'],
    'Ondo': ['Ogun', 'Osun', 'Ekiti', 'Kogi', 'Edo'],
    'Osun': ['Ogun', 'Oyo', 'Kwara', 'Ekiti', 'Ondo'],
    'Oyo': ['Ogun', 'Osun', 'Kwara'],
    'Plateau': ['Bauchi', 'Kaduna', 'Nasarawa', 'Taraba'],
    'Rivers': ['Imo', 'Abia', 'Akwa Ibom', 'Bayelsa', 'Delta'],
    'Sokoto': ['Zamfara', 'Kebbi'],
    'Taraba': ['Plateau', 'Bauchi', 'Gombe', 'Adamawa', 'Benue', 'Nasarawa'],
    'Yobe': ['Borno', 'Gombe', 'Bauchi', 'Jigawa'],
    'Zamfara': ['Sokoto', 'Kebbi', 'Niger', 'Kaduna', 'Katsina'],
  };

  // Define the maximum distance (in states) to search for matches
  static const int MAX_DISTANCE = 2;

  // Returns a list of states within the given distance from the user's state
  static List<String> getStatesByDistance(String userState, int maxDistance) {
    if (maxDistance <= 0) {
      return [userState]; // Return only the user's state if distance is 0
    }

    Set<String> states = {userState};
    Set<String> currentStates = {userState};

    for (int distance = 1; distance <= maxDistance; distance++) {
      Set<String> nextStates = {};

      for (String state in currentStates) {
        List<String> neighbors = stateNeighbors[state] ?? [];
        nextStates.addAll(neighbors);
      }

      states.addAll(nextStates);
      currentStates = nextStates;
    }

    return states.toList();
  }

  // Filter users based on location proximity
  static List<User> filterUsersByLocation(List<User> users, User currentUser,
      {int maxDistance = MAX_DISTANCE}) {
    // Get states within the specified distance
    List<String> nearbyStates =
        getStatesByDistance(currentUser.state, maxDistance);

    // Filter users who are in nearby states
    return users
        .where((user) =>
            nearbyStates.contains(user.state) && user.id != currentUser.id)
        .toList();
  }

  // Sort users by proximity to the current user
  static List<User> sortUsersByProximity(List<User> users, User currentUser) {
    // Create a map to store the distance for each user
    Map<String, int> distanceMap = {};

    for (User user in users) {
      if (user.state == currentUser.state) {
        // Same state gets distance 0
        distanceMap[user.id] = 0;
      } else if (stateNeighbors[currentUser.state]?.contains(user.state) ??
          false) {
        // Neighboring state gets distance 1
        distanceMap[user.id] = 1;
      } else {
        // Default to maximum distance for other states
        distanceMap[user.id] = MAX_DISTANCE;
      }
    }

    // Sort the users by proximity
    users.sort((a, b) =>
        (distanceMap[a.id] ?? MAX_DISTANCE) -
        (distanceMap[b.id] ?? MAX_DISTANCE));

    return users;
  }

  // Get recommended matches based on location and other factors
  static List<User> getRecommendedMatches(List<User> users, User currentUser) {
    // Filter by location first
    List<User> nearbyUsers = filterUsersByLocation(users, currentUser);

    // Sort by proximity
    nearbyUsers = sortUsersByProximity(nearbyUsers, currentUser);

    return nearbyUsers;
  }
}
