import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/places_providers.dart';

/// Lista miejsc zapisanych w lokalnej bazie Isar (punkt 6).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text('favorites_title'.tr())),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('error_generic'.tr(args: [err.toString()]))),
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(child: Text('no_favorites'.tr()));
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final place = favorites[index];
              return ListTile(
                leading: const Icon(Icons.place),
                title: Text(place.name),
                subtitle: place.note != null && place.note!.isNotEmpty
                    ? Text(place.note!)
                    : null,
                trailing: place.rating > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('${place.rating}'),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
