import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import '../data/local/place_entity.dart';
import '../data/local/places_local_repository.dart';

const placesBoxName = 'places';

final placesBoxProvider = Provider<Box<PlaceEntity>>((ref) {
  throw UnimplementedError('placesBoxProvider musi być nadpisany w main()');
});

final placesLocalRepositoryProvider = Provider<PlacesLocalRepository>((ref) {
  final box = ref.watch(placesBoxProvider);
  return PlacesLocalRepository(box);
});