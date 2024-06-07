class UserModel {
  int? status;
  Data? data;
  String? token;
  String? message;

  UserModel({this.status, this.data, this.token, this.message});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   <String, dynamic>{};
    data['status'] =  status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] =  token;
    data['message'] =  message;
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  Null emailVerifiedAt;
  String? dateOfBirth;
  String? gender;
  String? role;
  String? status;
  String? platform;
  String? image;
  int? trackMyVisits;
  String? createdAt;
  String? updatedAt;

  Data(
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
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    role = json['role'];
    status = json['status'];
    platform = json['platform'];
    image = json['image'];
    trackMyVisits = json['track_my_visits'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] =  lastName;
    data['username'] =  username;
    data['email'] =  email;
    data['email_verified_at'] =  emailVerifiedAt;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] =  gender;
    data['role'] =  role;
    data['status'] =  status;
    data['platform'] =  platform;
    data['image'] =  image;
    data['track_my_visits'] =  trackMyVisits;
    data['created_at'] = createdAt;
    data['updated_at'] =  updatedAt;
    return data;
  }
}