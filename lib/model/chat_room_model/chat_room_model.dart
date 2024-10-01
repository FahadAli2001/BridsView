class ChatRoomModel {
  String? roomId;
  Map<String, dynamic>? participants; 
  String? lastMessage;
  String? groupName;  
  String? groupImage; 

  ChatRoomModel({
    this.roomId,
    this.participants,
    this.lastMessage,
    this.groupName,  
    this.groupImage,  
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      roomId: json['roomId'],
      participants: json['participants'],
      lastMessage: json['lastMessage'],
      groupName: json['groupName'],  
      groupImage: json['groupImage'],  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'participants': participants,
      'lastMessage': lastMessage,
      'groupName': groupName,  
      'groupImage': groupImage,  
    };
  }
}


// class ChatRoomModel {
//   String? roomId;
//   Map<String, dynamic>? participants;
//   String? lastMessage;
  

//   ChatRoomModel({
//     this.roomId,
//     this.participants,
//     this.lastMessage,
  
//   });

//   factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
//     return ChatRoomModel(
//       roomId: json['roomId'],
//       participants: json['participants'],
//       lastMessage: json['lastMessage'],
     
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'roomId': roomId,
//       'participants': participants,
  
//     };
//   }
// }