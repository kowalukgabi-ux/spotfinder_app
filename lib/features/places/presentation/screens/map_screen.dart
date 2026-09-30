import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../providers/location_provider.dart';
import '../../providers/places_providers.dart';
import '../../../../router/app_router.dart';
import '../../../../core/theme/app_theme.dart';

/// Punkt 8: Mapa, lokalizacja.
/// Punkt 2 (obowiązkowy): obsługa stanu async przez Riverpod (.when - switch po stanach).
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionAsync = ref.watch(currentPositionProvider);
    final placesAsync = ref.watch(nearbyPlacesProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('map_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.pushNamed(AppRoutes.favorites),
            tooltip: 'favorites_title'.tr(),
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) => context.setLocale(locale),
            itemBuilder: (context) => const [
              PopupMenuItem(value: Locale('pl'), child: Text('Polski')),
              PopupMenuItem(value: Locale('en'), child: Text('English')),
            ],
          ),
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      // switch po stanie async - loading / error / data
      body: positionAsync.when(
        loading: () => Center(child: _LoadingView(text: 'loading_location'.tr())),
        error: (err, _) => _ErrorView(
          message: err.toString(),
          onRetry: () => ref.invalidate(currentPositionProvider),
        ),
        data: (position) {
          return placesAsync.when(
            loading: () => Center(child: _LoadingView(text: 'loading_places'.tr())),
            error: (err, _) => _ErrorView(
              message: err.toString(),
              onRetry: () => ref.invalidate(nearbyPlacesProvider),
            ),
            data: (places) => FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(position.latitude, position.longitude),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.spotfinder_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(position.latitude, position.longitude),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.my_location, color: Colors.blue),
                    ),
                    ...places.map(
                      (place) => Marker(
                        point: LatLng(place.lat, place.lon),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () => context.pushNamed(
                            AppRoutes.placeDetail,
                            pathParameters: {'id': place.id},
                            extra: {
                              'name': place.name,
                              'lat': place.lat,
                              'lon': place.lon,
                              'category': place.category,
                            },
                          ),
                          child: const Icon(Icons.place, color: Colors.red, size: 32),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  final String text;
  const _LoadingView({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 12),
        Text(text),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('error_generic'.tr(args: [message]), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: Text('retry'.tr())),
          ],
        ),
      ),
    );
  }
}
