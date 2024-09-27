class FriendModel {
  final String email;
  final String firstName;
  final String lastName;
  final int friendId; // Change to String if needed
  final String image;
  final String status;

  FriendModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.friendId,
    required this.image,
    required this.status,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      friendId: json['friendId'] is int 
          ? json['friendId'] 
          : int.parse(json['friendId'] as String), // Convert if necessary
      image: json['image'] as String,
      status: json['status'] as String,
    );
  }
}
