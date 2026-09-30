import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'app.dart';
import 'features/places/data/local/place_entity.dart';
import 'features/places/providers/hive_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlaceEntityAdapter());
  final box = await Hive.openBox<PlaceEntity>(placesBoxName);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('pl')],
      path: 'assets/translations',
      fallbackLocale: const Locale('pl'),
      child: ProviderScope(
        overrides: [
          placesBoxProvider.overrideWithValue(box),
        ],
        child: const SpotFinderApp(),
      ),
    ),
  );
}