import 'package:dio/dio.dart';
import '../models/place.dart';

/// Komunikacja z darmowym Overpass API (dane OpenStreetMap), bez klucza API.
/// Punkt 3: Komunikacja z zewn. API - DIO, JSON freeze.
class OverpassApiService {
  final Dio _dio;

  OverpassApiService(this._dio);

static const _endpoint = 'https://lz4.overpass-api.de/api/interpreter';

Future<List<Place>> fetchNearbyPlaces({
  required double lat,
  required double lon,
  int radiusMeters = 800,
}) async {
  final query = '''
    [out:json][timeout:20];
    (
      node["tourism"](around:$radiusMeters,$lat,$lon);
      node["amenity"~"restaurant|cafe|bar"](around:$radiusMeters,$lat,$lon);
    );
    out body;
  ''';

    final response = await _dio.post(
      _endpoint,
      data: 'data=${Uri.encodeQueryComponent(query)}',
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'User-Agent': 'SpotFinderApp/1.0 (projekt zaliczeniowy)',
          'Accept': '*/*',
        },
      ),
    );

    final elements = (response.data['elements'] as List?) ?? [];

    return elements
        .where((e) => e['tags'] != null && e['tags']['name'] != null)
        .map<Place>((e) {
      final tags = e['tags'] as Map<String, dynamic>;
      return Place.fromJson({
        'id': e['id'].toString(),
        'name': tags['name'],
        'lat': (e['lat'] as num).toDouble(),
        'lon': (e['lon'] as num).toDouble(),
        'category': tags['tourism'] ?? tags['amenity'],
      });
    }).toList();
  }
}
