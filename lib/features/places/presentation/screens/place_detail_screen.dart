import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/place.dart';
import '../../providers/hive_provider.dart';
import '../../../../router/app_router.dart';

class PlaceDetailScreen extends ConsumerWidget {
  final String placeId;
  final String name;
  final double lat;
  final double lon;
  final String? category;

  const PlaceDetailScreen({
    super.key,
    required this.placeId,
    required this.name,
    required this.lat,
    required this.lon,
    this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(placesLocalRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            if (category != null)
              Chip(label: Text(category!)),
            const SizedBox(height: 16),
            Text('${'category'.tr()}: ${category ?? '-'}'),
            Text('Lat: $lat, Lon: $lon'),
            const Spacer(),
            FutureBuilder<bool>(
              future: repo.isFavorite(placeId),
              builder: (context, snapshot) {
                final isFav = snapshot.data ?? false;
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                        label: Text(
                          isFav
                              ? 'remove_from_favorites'.tr()
                              : 'save_to_favorites'.tr(),
                        ),
                        onPressed: () async {
                          final place = Place(
                            id: placeId,
                            name: name,
                            lat: lat,
                            lon: lon,
                            category: category,
                          );
                          if (isFav) {
                            await repo.remove(placeId);
                          } else {
                            await repo.saveOrUpdate(place);
                          }
                          if (context.mounted) {
                            (context as Element).markNeedsBuild();
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit_note),
                label: Text('add_note'.tr()),
                // push - dokłada ekran na stos nawigacji (można wrócić przez pop)
                onPressed: () => context.pushNamed(
                  AppRoutes.addNote,
                  pathParameters: {'id': placeId},
                  extra: {
                    'name': name,
                    'lat': lat,
                    'lon': lon,
                    'category': category,
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
