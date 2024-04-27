class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String phone;
  final String payment;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phone,
    required this.payment,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data, String id) {
    return UserProfile(
      firstName: data['first name'],
      lastName: data['last name'],
      email: data['email'],
      address: data['address'],
      phone: data['phone'],
      payment: data['payment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'phone': phone,
      'payment': payment,
    };
  }
}
