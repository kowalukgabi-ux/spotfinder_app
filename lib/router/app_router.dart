import 'package:go_router/go_router.dart';
import '../features/places/presentation/screens/map_screen.dart';
import '../features/places/presentation/screens/place_detail_screen.dart';
import '../features/places/presentation/screens/favorites_screen.dart';
import '../features/places/presentation/screens/add_note_screen.dart';

/// Punkt 1 (obowiązkowy): Nawigacja - GoRouter (push, pop, replace, named routes).
class AppRoutes {
  static const map = 'map';
  static const placeDetail = 'placeDetail';
  static const favorites = 'favorites';
  static const addNote = 'addNote';
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.map,
      builder: (context, state) => const MapScreen(),
      routes: [
        GoRoute(
          // named route z parametrem - push na stos (nie zamienia ekranu)
          path: 'place/:id',
          name: AppRoutes.placeDetail,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return PlaceDetailScreen(
              placeId: state.pathParameters['id']!,
              name: extra?['name'] as String? ?? '',
              lat: extra?['lat'] as double? ?? 0,
              lon: extra?['lon'] as double? ?? 0,
              category: extra?['category'] as String?,
            );
          },
          routes: [
            GoRoute(
              path: 'note',
              name: AppRoutes.addNote,
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>;
                return AddNoteScreen(
                  placeId: state.pathParameters['id']!,
                  placeName: extra['name'] as String,
                  lat: extra['lat'] as double,
                  lon: extra['lon'] as double,
                  category: extra['category'] as String?,
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/favorites',
      name: AppRoutes.favorites,
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);
