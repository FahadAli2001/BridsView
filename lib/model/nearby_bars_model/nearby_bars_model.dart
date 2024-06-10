class NearbyBar {
  final String name;
  final String placeId;
  final double rating;
  final String vicinity;
  final List<String> photos;
  final double latitude;
  final double longitude;

  NearbyBar({
    required this.name,
    required this.placeId,
    required this.rating,
    required this.vicinity,
    required this.photos,
    required this.latitude,
    required this.longitude,
  });

  factory NearbyBar.fromJson(Map<String, dynamic> json) {
    return NearbyBar(
      name: json['name'],
      placeId: json['place_id'],
      rating: (json['rating'] as num).toDouble(),
      vicinity: json['vicinity'],
      photos: (json['photos'] as List).map((photo) => photo['photo_reference'] as String).toList(),
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
    );
  }
}

class NearbyBars {
  final List<NearbyBar> bars;

  NearbyBars({required this.bars});

  factory NearbyBars.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<NearbyBar> barsList = list.map((i) => NearbyBar.fromJson(i)).toList();
    return NearbyBars(bars: barsList);
  }
}
