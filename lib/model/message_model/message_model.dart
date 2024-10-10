class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  int? createdOn;
  String? imageUrl;
  String? videoUrl;

  MessageModel({
    this.sender,
    this.text,
    this.seen,
    this.createdOn,
    this.messageId,
    this.imageUrl,
    this.videoUrl,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'],
      text: json['text'],
      seen: json['seen'],
      createdOn: json['createdOn'],
      messageId: json['messageId'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdOn': createdOn,
      'messageId': messageId,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }
}
