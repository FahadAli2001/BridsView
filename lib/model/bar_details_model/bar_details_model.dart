class PlaceDetails {
  final String formattedAddress;
  final String phoneNumber;
  final String internationalPhoneNumber;
  final String name;
  final double rating;
  final String website;
  final String url;
  final int userRatingsTotal;
  final bool wheelchairAccessibleEntrance;
  final List<dynamic> types;
  final List<dynamic> photos;
  final List<dynamic> reviews;
  final Geometry geometry;

  PlaceDetails({
    required this.formattedAddress,
    required this.phoneNumber,
    required this.internationalPhoneNumber,
    required this.name,
    required this.rating,
    required this.website,
    required this.url,
    required this.userRatingsTotal,
    required this.wheelchairAccessibleEntrance,
    required this.types,
    required this.photos,
    required this.reviews,
    required this.geometry,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    var typesList = json['types'] != null ? List<String>.from(json['types']) : [];
    var photosList = json['photos'] != null
        ? List<Photo>.from(json['photos'].map((item) => Photo.fromJson(item)))
        : [];
    var reviewsList = json['reviews'] != null
        ? List<Review>.from(json['reviews'].map((item) => Review.fromJson(item)))
        : [];

    return PlaceDetails(
      formattedAddress: json['formatted_address'] ?? '',
      phoneNumber: json['formatted_phone_number'] ?? '',
      internationalPhoneNumber: json['international_phone_number'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] != null) ? json['rating'].toDouble() : 0.0,
      website: json['website'] ?? '',
      url: json['url'] ?? '',
      userRatingsTotal: json['user_ratings_total'] ?? 0,
      wheelchairAccessibleEntrance: json['wheelchair_accessible_entrance'] ?? false,
      types: typesList,
      photos: photosList,
      reviews: reviewsList,
      geometry: Geometry.fromJson(json['geometry']),
    );
  }
}

class Geometry {
  final Location location;
  final Viewport viewport;

  Geometry({
    required this.location,
    required this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location']),
      viewport: Viewport.fromJson(json['viewport']),
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}

class Viewport {
  final Location northeast;
  final Location southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: Location.fromJson(json['northeast']),
      southwest: Location.fromJson(json['southwest']),
    );
  }
}

class Photo {
  final int height;
  final int width;
  final String photoReference;
  final List<String> htmlAttributions;

  Photo({
    required this.height,
    required this.width,
    required this.photoReference,
    required this.htmlAttributions,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json['height'],
      width: json['width'],
      photoReference: json['photo_reference'],
      htmlAttributions: List<String>.from(json['html_attributions'].map((item) => item.toString())),
    );
  }
}

class Review {
  final String authorName;
  final String authorUrl;
  final String language;
  final String profilePhotoUrl;
  final int rating;
  final String relativeTimeDescription;
  final String text;
  final int time;

  Review({
    required this.authorName,
    required this.authorUrl,
    required this.language,
    required this.profilePhotoUrl,
    required this.rating,
    required this.relativeTimeDescription,
    required this.text,
    required this.time,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json['author_name'],
      authorUrl: json['author_url'],
      language: json['language'],
      profilePhotoUrl: json['profile_photo_url'],
      rating: json['rating'],
      relativeTimeDescription: json['relative_time_description'],
      text: json['text'],
      time: json['time'],
    );
  }
}
