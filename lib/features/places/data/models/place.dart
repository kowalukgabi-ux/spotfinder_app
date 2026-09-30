import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

/// Model reprezentujący miejsce pobrane z zewnętrznego API (Overpass/OSM).
/// Punkt 3: Komunikacja z zewn. API - JSON freeze.
@freezed
class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    required double lat,
    required double lon,
    String? category,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}
