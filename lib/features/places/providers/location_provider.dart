import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Punkt 8: Mapa, lokalizacja.
/// FutureProvider - obsługa stanu asynchronicznego (loading/data/error) przez Riverpod.
final currentPositionProvider = FutureProvider<Position>((ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Usługi lokalizacji są wyłączone.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Brak uprawnień do lokalizacji.');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    throw Exception('Uprawnienia do lokalizacji zablokowane na stałe.');
  }

  return Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
});
