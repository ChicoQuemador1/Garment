class UserProfile {
  final String firstName;
  final String lastName;
  final String email;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data, String email) {
    return UserProfile(
      firstName: data['first name'],
      lastName: data['last name'],
      email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
