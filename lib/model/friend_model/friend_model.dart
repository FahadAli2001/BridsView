class FriendModel {
  final String? friendId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? image;
  final String? status;

  FriendModel({
    required this.friendId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.status,
  });

  // Updated fromJson method to handle null values
  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      friendId: json['friendId'] as String? ?? '', // Handle null safely
      firstName: json['firstName'] as String? ?? '', // Handle null safely
      lastName: json['lastName'] as String? ?? '', // Handle null safely
      email: json['email'] as String? ?? '', // Handle null safely
      image: json['image'] as String? ?? '', // Handle null safely
      status: json['status'] as String? ?? 'unknown', // Default status if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendId': friendId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'status': status,
    };
  }
}
