import 'package:hive_ce/hive.dart';
import '../models/place.dart';

part 'place_entity.g.dart';

@HiveType(typeId: 0)
class PlaceEntity extends HiveObject {
  @HiveField(0)
  late String remoteId;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late double lat;

  @HiveField(3)
  late double lon;

  @HiveField(4)
  String? category;

  @HiveField(5)
  String? note;

  @HiveField(6)
  int rating = 0;

  @HiveField(7)
  DateTime savedAt = DateTime.now();

  static PlaceEntity fromPlace(Place place) {
    return PlaceEntity()
      ..remoteId = place.id
      ..name = place.name
      ..lat = place.lat
      ..lon = place.lon
      ..category = place.category;
  }
}