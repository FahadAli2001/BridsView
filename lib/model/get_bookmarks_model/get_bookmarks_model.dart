class GetBookmarksModel {
  final int? status;
  final String? message;
  final List<String>? barPlacesId;
  const GetBookmarksModel({this.status, this.message, this.barPlacesId});
  GetBookmarksModel copyWith(
      {int? status, String? message, List<String>? barPlacesId}) {
    return GetBookmarksModel(
        status: status ?? this.status,
        message: message ?? this.message,
        barPlacesId: barPlacesId ?? this.barPlacesId);
  }

  Map<String, Object?> toJson() {
    return {'status': status, 'message': message, 'bar_places_id': barPlacesId};
  }

  static GetBookmarksModel fromJson(Map<String, Object?> json) {
    return GetBookmarksModel(
        status: json['status'] == null ? null : json['status'] as int,
        message: json['message'] == null ? null : json['message'] as String,
        barPlacesId: json['bar_places_id'] == null
            ? null
            : json['bar_places_id'] as List<String>);
  }

  @override
  String toString() {
    return '''GetBookmarksModel(
                status:$status,
message:$message,
barPlacesId:$barPlacesId
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is GetBookmarksModel &&
        other.runtimeType == runtimeType &&
        other.status == status &&
        other.message == message &&
        other.barPlacesId == barPlacesId;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, status, message, barPlacesId);
  }
}
