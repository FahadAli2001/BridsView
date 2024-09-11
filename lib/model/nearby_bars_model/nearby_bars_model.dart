class NearbyBars {
  final List<String>? htmlAttributions;
  final List<Results>? results;
  final String? status;

  const NearbyBars({this.htmlAttributions, this.results, this.status});

  NearbyBars copyWith({
    List<String>? htmlAttributions,
    List<Results>? results,
    String? status,
  }) {
    return NearbyBars(
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
      results: results ?? this.results,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'html_attributions': htmlAttributions,
      'results':
          results?.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
      'status': status,
    };
  }

  static NearbyBars fromJson(Map<String, Object?> json) {
    return NearbyBars(
      htmlAttributions: json['html_attributions'] == null
          ? null
          : (json['html_attributions'] as List)
              .map((e) => e as String)
              .toList(),
      results: json['results'] == null
          ? null
          : (json['results'] as List)
              .map<Results>(
                  (data) => Results.fromJson(data as Map<String, Object?>))
              .toList(),
      status: json['status'] as String?,
    );
  }

  @override
  String toString() {
    return 'NearbyBars(htmlAttributions: $htmlAttributions, results: $results, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyBars &&
        other.runtimeType == runtimeType &&
        other.htmlAttributions == htmlAttributions &&
        other.results == results &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, htmlAttributions, results, status);
  }
}

class Results {
  final String? businessStatus;
  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String? name;
  final OpeningHours? openingHours;
  final List<Photos>? photos;
  final String? placeId;
  final PlusCode? plusCode;
  final int? priceLevel;
  final double? rating;
  final String? reference;
  final String? scope;
  final List<String>? types;
  final int? userRatingsTotal;
  final String? vicinity;

  const Results({
    this.businessStatus,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.plusCode,
    this.priceLevel,
    this.rating,
    this.reference,
    this.scope,
    this.types,
    this.userRatingsTotal,
    this.vicinity,
  });

  Results copyWith({
    String? businessStatus,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    OpeningHours? openingHours,
    List<Photos>? photos,
    String? placeId,
    PlusCode? plusCode,
    int? priceLevel,
    double? rating,
    String? reference,
    String? scope,
    List<String>? types,
    int? userRatingsTotal,
    String? vicinity,
  }) {
    return Results(
      businessStatus: businessStatus ?? this.businessStatus,
      geometry: geometry ?? this.geometry,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
      name: name ?? this.name,
      openingHours: openingHours ?? this.openingHours,
      photos: photos ?? this.photos,
      placeId: placeId ?? this.placeId,
      plusCode: plusCode ?? this.plusCode,
      priceLevel: priceLevel ?? this.priceLevel,
      rating: rating ?? this.rating,
      reference: reference ?? this.reference,
      scope: scope ?? this.scope,
      types: types ?? this.types,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      vicinity: vicinity ?? this.vicinity,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'business_status': businessStatus,
      'geometry': geometry?.toJson(),
      'icon': icon,
      'icon_background_color': iconBackgroundColor,
      'icon_mask_base_uri': iconMaskBaseUri,
      'name': name,
      'opening_hours': openingHours?.toJson(),
      'photos':
          photos?.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
      'place_id': placeId,
      'plus_code': plusCode?.toJson(),
      'price_level': priceLevel,
      'rating': rating,
      'reference': reference,
      'scope': scope,
      'types': types,
      'user_ratings_total': userRatingsTotal,
      'vicinity': vicinity,
    };
  }

  static Results fromJson(Map<String, Object?> json) {
    return Results(
      businessStatus: json['business_status'] as String?,
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, Object?>),
      icon: json['icon'] as String?,
      iconBackgroundColor: json['icon_background_color'] as String?,
      iconMaskBaseUri: json['icon_mask_base_uri'] as String?,
      name: json['name'] as String?,
      openingHours: json['opening_hours'] == null
          ? null
          : OpeningHours.fromJson(
              json['opening_hours'] as Map<String, Object?>),
      photos: json['photos'] == null
          ? null
          : (json['photos'] as List)
              .map<Photos>(
                  (data) => Photos.fromJson(data as Map<String, Object?>))
              .toList(),
      placeId: json['place_id'] as String?,
      plusCode: json['plus_code'] == null
          ? null
          : PlusCode.fromJson(json['plus_code'] as Map<String, Object?>),
      priceLevel: json['price_level'] as int?,
      rating: (json['rating'] as num?)?.toDouble(),
      reference: json['reference'] as String?,
      scope: json['scope'] as String?,
      types: json['types'] == null
          ? null
          : (json['types'] as List).map((e) => e as String).toList(),
      userRatingsTotal: json['user_ratings_total'] as int?,
      vicinity: json['vicinity'] as String?,
    );
  }

  @override
  String toString() {
    return 'Results(businessStatus: $businessStatus, geometry: $geometry, icon: $icon, iconBackgroundColor: $iconBackgroundColor, iconMaskBaseUri: $iconMaskBaseUri, name: $name, openingHours: $openingHours, photos: $photos, placeId: $placeId, plusCode: $plusCode, priceLevel: $priceLevel, rating: $rating, reference: $reference, scope: $scope, types: $types, userRatingsTotal: $userRatingsTotal, vicinity: $vicinity)';
  }

  @override
  bool operator ==(Object other) {
    return other is Results &&
        other.runtimeType == runtimeType &&
        other.businessStatus == businessStatus &&
        other.geometry == geometry &&
        other.icon == icon &&
        other.iconBackgroundColor == iconBackgroundColor &&
        other.iconMaskBaseUri == iconMaskBaseUri &&
        other.name == name &&
        other.openingHours == openingHours &&
        other.photos == photos &&
        other.placeId == placeId &&
        other.plusCode == plusCode &&
        other.priceLevel == priceLevel &&
        other.rating == rating &&
        other.reference == reference &&
        other.scope == scope &&
        other.types == types &&
        other.userRatingsTotal == userRatingsTotal &&
        other.vicinity == vicinity;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        businessStatus,
        geometry,
        icon,
        iconBackgroundColor,
        iconMaskBaseUri,
        name,
        openingHours,
        photos,
        placeId,
        plusCode,
        priceLevel,
        rating,
        reference,
        scope,
        types,
        userRatingsTotal,
        vicinity);
  }
}

class PlusCode {
  final String? compoundCode;
  final String? globalCode;

  const PlusCode({this.compoundCode, this.globalCode});

  PlusCode copyWith({String? compoundCode, String? globalCode}) {
    return PlusCode(
      compoundCode: compoundCode ?? this.compoundCode,
      globalCode: globalCode ?? this.globalCode,
    );
  }

  Map<String, Object?> toJson() {
    return {'compound_code': compoundCode, 'global_code': globalCode};
  }

  static PlusCode fromJson(Map<String, Object?> json) {
    return PlusCode(
      compoundCode: json['compound_code'] as String?,
      globalCode: json['global_code'] as String?,
    );
  }

  @override
  String toString() {
    return 'PlusCode(compoundCode: $compoundCode, globalCode: $globalCode)';
  }

  @override
  bool operator ==(Object other) {
    return other is PlusCode &&
        other.runtimeType == runtimeType &&
        other.compoundCode == compoundCode &&
        other.globalCode == globalCode;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, compoundCode, globalCode);
  }
}

class Photos {
  final int? height;
  final List<String>? htmlAttributions;
  final String? photoReference;
  final int? width;

  const Photos(
      {this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos copyWith(
      {int? height,
      List<String>? htmlAttributions,
      String? photoReference,
      int? width}) {
    return Photos(
      height: height ?? this.height,
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
      photoReference: photoReference ?? this.photoReference,
      width: width ?? this.width,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'height': height,
      'html_attributions': htmlAttributions,
      'photo_reference': photoReference,
      'width': width,
    };
  }

  static Photos fromJson(Map<String, Object?> json) {
    return Photos(
      height: json['height'] as int?,
      htmlAttributions:
          (json['html_attributions'] as List).map((e) => e as String).toList(),
      photoReference: json['photo_reference'] as String?,
      width: json['width'] as int?,
    );
  }

  @override
  String toString() {
    return 'Photos(height: $height, htmlAttributions: $htmlAttributions, photoReference: $photoReference, width: $width)';
  }

  @override
  bool operator ==(Object other) {
    return other is Photos &&
        other.runtimeType == runtimeType &&
        other.height == height &&
        other.htmlAttributions == htmlAttributions &&
        other.photoReference == photoReference &&
        other.width == width;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, height, htmlAttributions, photoReference, width);
  }
}

class OpeningHours {
  final bool? openNow;

  const OpeningHours({this.openNow});

  OpeningHours copyWith({bool? openNow}) {
    return OpeningHours(openNow: openNow ?? this.openNow);
  }

  Map<String, Object?> toJson() {
    return {'open_now': openNow};
  }

  static OpeningHours fromJson(Map<String, Object?> json) {
    return OpeningHours(openNow: json['open_now'] as bool?);
  }

  @override
  String toString() {
    return 'OpeningHours(openNow: $openNow)';
  }

  @override
  bool operator ==(Object other) {
    return other is OpeningHours &&
        other.runtimeType == runtimeType &&
        other.openNow == openNow;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, openNow);
  }
}

class Geometry {
  final Location? location;
  final Viewport? viewport;

  const Geometry({this.location, this.viewport});

  Geometry copyWith({Location? location, Viewport? viewport}) {
    return Geometry(
      location: location ?? this.location,
      viewport: viewport ?? this.viewport,
    );
  }

  Map<String, Object?> toJson() {
    return {'location': location?.toJson(), 'viewport': viewport?.toJson()};
  }

  static Geometry fromJson(Map<String, Object?> json) {
    return Geometry(
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, Object?>),
      viewport: json['viewport'] == null
          ? null
          : Viewport.fromJson(json['viewport'] as Map<String, Object?>),
    );
  }

  @override
  String toString() {
    return 'Geometry(location: $location, viewport: $viewport)';
  }

  @override
  bool operator ==(Object other) {
    return other is Geometry &&
        other.runtimeType == runtimeType &&
        other.location == location &&
        other.viewport == viewport;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, location, viewport);
  }
}

class Viewport {
  final Location? northeast;
  final Location? southwest;

  const Viewport({this.northeast, this.southwest});

  Viewport copyWith({Location? northeast, Location? southwest}) {
    return Viewport(
        northeast: northeast ?? this.northeast,
        southwest: southwest ?? this.southwest);
  }

  Map<String, Object?> toJson() {
    return {'northeast': northeast?.toJson(), 'southwest': southwest?.toJson()};
  }

  static Viewport fromJson(Map<String, Object?> json) {
    return Viewport(
      northeast: json['northeast'] == null
          ? null
          : Location.fromJson(json['northeast'] as Map<String, Object?>),
      southwest: json['southwest'] == null
          ? null
          : Location.fromJson(json['southwest'] as Map<String, Object?>),
    );
  }

  @override
  String toString() {
    return 'Viewport(northeast: $northeast, southwest: $southwest)';
  }

  @override
  bool operator ==(Object other) {
    return other is Viewport &&
        other.runtimeType == runtimeType &&
        other.northeast == northeast &&
        other.southwest == southwest;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, northeast, southwest);
  }
}

class Location {
  final double? lat;
  final double? lng;

  const Location({this.lat, this.lng});

  Location copyWith({double? lat, double? lng}) {
    return Location(lat: lat ?? this.lat, lng: lng ?? this.lng);
  }

  Map<String, Object?> toJson() {
    return {'lat': lat, 'lng': lng};
  }

  static Location fromJson(Map<String, Object?> json) {
    return Location(
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
    );
  }

  @override
  String toString() {
    return 'Location(lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return other is Location &&
        other.runtimeType == runtimeType &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, lat, lng);
  }
}
