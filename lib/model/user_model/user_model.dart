class UserModel {
  final int? status;
  final Data? data;
  final String? token;
  final String? message;
  const UserModel({this.status, this.data, this.token, this.message});
  UserModel copyWith(
      {int? status, Data? data, String? token, String? message}) {
    return UserModel(
        status: status ?? this.status,
        data: data ?? this.data,
        token: token ?? this.token,
        message: message ?? this.message);
  }

  Map<String, Object?> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
      'token': token,
      'message': message
    };
  }

  static UserModel fromJson(Map<String, Object?> json) {
    return UserModel(
        status: json['status'] == null ? null : json['status'] as int,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, Object?>),
        token: json['token'] == null ? null : json['token'] as String,
        message: json['message'] == null ? null : json['message'] as String);
  }

  @override
  String toString() {
    return '''UserModel(
                status:$status,
data:${data.toString()},
token:$token,
message:$message
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is UserModel &&
        other.runtimeType == runtimeType &&
        other.status == status &&
        other.data == data &&
        other.token == token &&
        other.message == message;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, status, data, token, message);
  }
}

class Data {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? dateOfBirth;
  final String? gender;
  final String? role;
  final String? status;
  final String? platform;
  final String? image;
  final int? trackMyVisits;
  final String? subscribe;
  final String? createdAt;
  final String? updatedAt;
  const Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.emailVerifiedAt,
      this.dateOfBirth,
      this.gender,
      this.role,
      this.status,
      this.platform,
      this.image,
      this.trackMyVisits,
      this.subscribe,
      this.createdAt,
      this.updatedAt});
  Data copyWith(
      {int? id,
      String? firstName,
      String? lastName,
      String? username,
      String? email,
      dynamic emailVerifiedAt,
      String? dateOfBirth,
      String? gender,
      String? role,
      String? status,
      String? platform,
      String? image,
      int? trackMyVisits,
      String? subscribe,
      String? createdAt,
      String? updatedAt}) {
    return Data(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        role: role ?? this.role,
        status: status ?? this.status,
        platform: platform ?? this.platform,
        image: image ?? this.image,
        trackMyVisits: trackMyVisits ?? this.trackMyVisits,
        subscribe: subscribe ?? this.subscribe,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'role': role,
      'status': status,
      'platform': platform,
      'image': image,
      'track_my_visits': trackMyVisits,
      'subscribe': subscribe,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }

  static Data fromJson(Map<String, Object?> json) {
    return Data(
        id: json['id'] == null ? null : json['id'] as int,
        firstName:
            json['first_name'] == null ? null : json['first_name'] as String,
        lastName:
            json['last_name'] == null ? null : json['last_name'] as String,
        username: json['username'] == null ? null : json['username'] as String,
        email: json['email'] == null ? null : json['email'] as String,
        emailVerifiedAt: json['email_verified_at'] as dynamic,
        dateOfBirth: json['date_of_birth'] == null
            ? null
            : json['date_of_birth'] as String,
        gender: json['gender'] == null ? null : json['gender'] as String,
        role: json['role'] == null ? null : json['role'] as String,
        status: json['status'] == null ? null : json['status'] as String,
        platform: json['platform'] == null ? null : json['platform'] as String,
        image: json['image'] == null ? null : json['image'] as String,
        trackMyVisits: json['track_my_visits'] == null
            ? null
            : json['track_my_visits'] as int,
        subscribe:
            json['subscribe'] == null ? null : json['subscribe'] as String,
        createdAt:
            json['created_at'] == null ? null : json['created_at'] as String,
        updatedAt:
            json['updated_at'] == null ? null : json['updated_at'] as String);
  }

  @override
  String toString() {
    return '''Data(
                id:$id,
firstName:$firstName,
lastName:$lastName,
username:$username,
email:$email,
emailVerifiedAt:$emailVerifiedAt,
dateOfBirth:$dateOfBirth,
gender:$gender,
role:$role,
status:$status,
platform:$platform,
image:$image,
trackMyVisits:$trackMyVisits,
subscribe:$subscribe,
createdAt:$createdAt,
updatedAt:$updatedAt
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Data &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username &&
        other.email == email &&
        other.emailVerifiedAt == emailVerifiedAt &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.role == role &&
        other.status == status &&
        other.platform == platform &&
        other.image == image &&
        other.trackMyVisits == trackMyVisits &&
        other.subscribe == subscribe &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        id,
        firstName,
        lastName,
        username,
        email,
        emailVerifiedAt,
        dateOfBirth,
        gender,
        role,
        status,
        platform,
        image,
        trackMyVisits,
        subscribe,
        createdAt,
        updatedAt);
  }
}
