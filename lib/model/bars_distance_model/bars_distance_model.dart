class BarsDistanceModel {
  final List<String>? destinationAddresses;
  final List<String>? originAddresses;
  final List<Rows>? rows;
  final String? status;
  const BarsDistanceModel(
      {this.destinationAddresses,
      this.originAddresses,
      this.rows,
      this.status});
  BarsDistanceModel copyWith(
      {List<String>? destinationAddresses,
      List<String>? originAddresses,
      List<Rows>? rows,
      String? status}) {
    return BarsDistanceModel(
        destinationAddresses: destinationAddresses ?? this.destinationAddresses,
        originAddresses: originAddresses ?? this.originAddresses,
        rows: rows ?? this.rows,
        status: status ?? this.status);
  }

  Map<String, Object?> toJson() {
    return {
      'destination_addresses': destinationAddresses,
      'origin_addresses': originAddresses,
      'rows': rows?.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
      'status': status
    };
  }

  static BarsDistanceModel fromJson(Map<String, Object?> json) {
    return BarsDistanceModel(
        destinationAddresses: json['destination_addresses'] == null
            ? null
            : json['destination_addresses'] as List<String>,
        originAddresses: json['origin_addresses'] == null
            ? null
            : json['origin_addresses'] as List<String>,
        rows: json['rows'] == null
            ? null
            : (json['rows'] as List)
                .map<Rows>(
                    (data) => Rows.fromJson(data as Map<String, Object?>))
                .toList(),
        status: json['status'] == null ? null : json['status'] as String);
  }

  @override
  String toString() {
    return '''BarsDistanceModel(
                destinationAddresses:$destinationAddresses,
originAddresses:$originAddresses,
rows:${rows.toString()},
status:$status
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is BarsDistanceModel &&
        other.runtimeType == runtimeType &&
        other.destinationAddresses == destinationAddresses &&
        other.originAddresses == originAddresses &&
        other.rows == rows &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, destinationAddresses, originAddresses, rows, status);
  }
}

class Rows {
  final List<Elements>? elements;
  const Rows({this.elements});
  Rows copyWith({List<Elements>? elements}) {
    return Rows(elements: elements ?? this.elements);
  }

  Map<String, Object?> toJson() {
    return {
      'elements':
          elements?.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static Rows fromJson(Map<String, Object?> json) {
    return Rows(
        elements: json['elements'] == null
            ? null
            : (json['elements'] as List)
                .map<Elements>(
                    (data) => Elements.fromJson(data as Map<String, Object?>))
                .toList());
  }

  @override
  String toString() {
    return '''Rows(
                elements:${elements.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Rows &&
        other.runtimeType == runtimeType &&
        other.elements == elements;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, elements);
  }
}

class Elements {
  final Distance? distance;
  final Distance? duration;
  final String? status;
  const Elements({this.distance, this.duration, this.status});
  Elements copyWith({Distance? distance, Distance? duration, String? status}) {
    return Elements(
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        status: status ?? this.status);
  }

  Map<String, Object?> toJson() {
    return {
      'distance': distance?.toJson(),
      'duration': duration?.toJson(),
      'status': status
    };
  }

  static Elements fromJson(Map<String, Object?> json) {
    return Elements(
        distance: json['distance'] == null
            ? null
            : Distance.fromJson(json['distance'] as Map<String, Object?>),
        duration: json['duration'] == null
            ? null
            : Distance.fromJson(json['duration'] as Map<String, Object?>),
        status: json['status'] == null ? null : json['status'] as String);
  }

  @override
  String toString() {
    return '''Elements(
                distance:${distance.toString()},
duration:${duration.toString()},
status:$status
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Elements &&
        other.runtimeType == runtimeType &&
        other.distance == distance &&
        other.duration == duration &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, distance, duration, status);
  }
}

class Distance {
  final String? text;
  final int? value;
  const Distance({this.text, this.value});
  Distance copyWith({String? text, int? value}) {
    return Distance(text: text ?? this.text, value: value ?? this.value);
  }

  Map<String, Object?> toJson() {
    return {'text': text, 'value': value};
  }

  static Distance fromJson(Map<String, Object?> json) {
    return Distance(
        text: json['text'] == null ? null : json['text'] as String,
        value: json['value'] == null ? null : json['value'] as int);
  }

  @override
  String toString() {
    return '''Distance(
                text:$text,
value:$value
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Distance &&
        other.runtimeType == runtimeType &&
        other.text == text &&
        other.value == value;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, text, value);
  }
}
