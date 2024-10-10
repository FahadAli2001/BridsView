class FirebaseUserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? dateOfBirth;
  String? gender;
  String? image;
  String? status;

  FirebaseUserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.image,
    this.status,
  });

  // Convert a UserModel into a Map (for sending to Firebase or other APIs)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'image': image,
      'status': status,
    };
  }

  // Create a UserModel from a Map (e.g., from Firebase)
  factory FirebaseUserModel.fromJson(Map<String, dynamic> json) {
    return FirebaseUserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      image: json['image'],
      status: json['status'],
    );
  }
}
