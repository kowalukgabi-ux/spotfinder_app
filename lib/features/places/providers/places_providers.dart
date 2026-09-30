import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/models/place.dart';
import '../data/services/overpass_api_service.dart';
import '../data/local/place_entity.dart';
import 'hive_provider.dart';
import 'location_provider.dart';
import '../../../core/network/dio_client.dart';

/// Punkt 2 (obowiązkowy): Obsługa stanu (future/async, switch) - Riverpod.

final dioProvider = Provider<Dio>((ref) => DioClient.create());

final overpassApiServiceProvider = Provider<OverpassApiService>((ref) {
  return OverpassApiService(ref.watch(dioProvider));
});

/// Pobiera miejsca w pobliżu aktualnej lokalizacji użytkownika.
/// Zależy od currentPositionProvider (FutureProvider) - łańcuch stanów async.
final nearbyPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  final service = ref.watch(overpassApiServiceProvider);

  return service.fetchNearbyPlaces(
    lat: position.latitude,
    lon: position.longitude,
  );
});

/// Strumień ulubionych/zapisanych miejsc z lokalnej bazy Isar.
final favoritesStreamProvider = StreamProvider<List<PlaceEntity>>((ref) {
  final repo = ref.watch(placesLocalRepositoryProvider);
  return repo.watchFavorites();
});
