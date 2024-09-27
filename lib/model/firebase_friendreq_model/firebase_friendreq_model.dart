import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  String? requesterEmail;
  String? requesterId;
  String? requesterImage;
  String? requesterFirstName;
  String? requesterLastName;
  String? status;
  DateTime? timestamp;

  FriendRequestModel({
    this.requesterEmail,
    this.requesterId,
    this.requesterImage,
    this.requesterFirstName,
    this.requesterLastName,
    this.status,
    this.timestamp,
  });

  // Convert from JSON to FriendRequestModel
  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      requesterEmail: json['requesterEmail'],
      requesterId: json['requesterId'],
      requesterImage: json['requesterImage'],
      requesterFirstName: json['requesterFirstName'],
      requesterLastName: json['requesterLastName'],
      status: json['status'],
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert from FriendRequestModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'requesterEmail': requesterEmail,
      'requesterId': requesterId,
      'requesterImage': requesterImage,
      'requesterFirstName': requesterFirstName,
      'requesterLastName': requesterLastName,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
