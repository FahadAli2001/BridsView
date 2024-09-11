class SearchBar {
  final List<Predictions>? predictions;
  final String? status;

  const SearchBar({this.predictions, this.status});

  factory SearchBar.fromJson(Map<String, dynamic> json) {
    return SearchBar(
      predictions: json['predictions'] != null
          ? (json['predictions'] as List)
              .map((i) => Predictions.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predictions': predictions?.map((i) => i.toJson()).toList(),
      'status': status,
    };
  }
}

class Predictions {
  final String? description;
  final List<MatchedSubstrings>? matchedSubstrings;
  final String? placeId;
  final String? reference;
  final StructuredFormatting? structuredFormatting;
  final List<Terms>? terms;
  final List<String>? types;

  const Predictions({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
      description: json['description'] as String?,
      matchedSubstrings: json['matched_substrings'] != null
          ? (json['matched_substrings'] as List)
              .map((i) => MatchedSubstrings.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(
              json['structured_formatting'] as Map<String, dynamic>)
          : null,
      terms: json['terms'] != null
          ? (json['terms'] as List)
              .map((i) => Terms.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      types: json['types'] != null
          ? List<String>.from(json['types'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'matched_substrings': matchedSubstrings?.map((i) => i.toJson()).toList(),
      'place_id': placeId,
      'reference': reference,
      'structured_formatting': structuredFormatting?.toJson(),
      'terms': terms?.map((i) => i.toJson()).toList(),
      'types': types,
    };
  }
}

class Terms {
  final int? offset;
  final String? value;

  const Terms({this.offset, this.value});

  factory Terms.fromJson(Map<String, dynamic> json) {
    return Terms(
      offset: json['offset'] as int?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'value': value,
    };
  }
}

class StructuredFormatting {
  final String? mainText;
  final List<MatchedSubstrings>? mainTextMatchedSubstrings;
  final String? secondaryText;

  const StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      mainTextMatchedSubstrings: json['main_text_matched_substrings'] != null
          ? (json['main_text_matched_substrings'] as List)
              .map((i) => MatchedSubstrings.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      secondaryText: json['secondary_text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main_text': mainText,
      'main_text_matched_substrings':
          mainTextMatchedSubstrings?.map((i) => i.toJson()).toList(),
      'secondary_text': secondaryText,
    };
  }
}

class MatchedSubstrings {
  final int? length;
  final int? offset;

  const MatchedSubstrings({this.length, this.offset});

  factory MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    return MatchedSubstrings(
      length: json['length'] as int?,
      offset: json['offset'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'offset': offset,
    };
  }
}
