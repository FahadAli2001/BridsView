class GroupModel {
  final String groupId;
  final String groupName;
  final String groupImage;
  final List<String> memberIds;

  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.groupImage,
    required this.memberIds,
  });

 
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['groupId'],
      groupName: json['groupName'],
      groupImage: json['groupImage'],
      memberIds: List<String>.from(json['memberIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupImage': groupImage,
      'memberIds': memberIds,
    };
  }
}
