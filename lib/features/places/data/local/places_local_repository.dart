import 'package:hive_ce/hive.dart';
import 'place_entity.dart';
import '../models/place.dart';

class PlacesLocalRepository {
  final Box<PlaceEntity> box;

  PlacesLocalRepository(this.box);

  Stream<List<PlaceEntity>> watchFavorites() async* {
    yield box.values.toList();
    yield* box.watch().map((_) => box.values.toList());
  }

  Future<List<PlaceEntity>> getFavorites() async => box.values.toList();

  Future<bool> isFavorite(String remoteId) async {
    return box.values.any((e) => e.remoteId == remoteId);
  }

  dynamic _findKey(String remoteId) {
    for (final key in box.keys) {
      if (box.get(key)?.remoteId == remoteId) return key;
    }
    return null;
  }

  Future<void> saveOrUpdate(Place place, {String? note, int rating = 0}) async {
    final existingKey = _findKey(place.id);
    final entity = (existingKey != null ? box.get(existingKey) : null) ??
        PlaceEntity.fromPlace(place);

    entity
      ..remoteId = place.id
      ..name = place.name
      ..lat = place.lat
      ..lon = place.lon
      ..category = place.category
      ..note = note ?? entity.note
      ..rating = rating;

    if (existingKey != null) {
      await box.put(existingKey, entity);
    } else {
      await box.add(entity);
    }
  }

  Future<void> remove(String remoteId) async {
    final key = _findKey(remoteId);
    if (key != null) {
      await box.delete(key);
    }
  }
}