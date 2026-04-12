import 'package:dio/dio.dart';
import 'package:pinterest_clone/core/network/dio_client.dart';
import 'package:pinterest_clone/data/models/pexels_response.dart';
import 'package:pinterest_clone/domain/entities/pin_entity.dart';
import 'package:pinterest_clone/domain/repositories/pin_repository.dart';

class PinRepositoryImpl implements PinRepository {
  final DioClient dioClient;

  PinRepositoryImpl(this.dioClient);

  @override
  Future<List<PinEntity>> getCuratedPins(int page, int perPage) async {
    try {
      final response = await dioClient.dio.get(
        'curated',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );
      final pexelsResponse = PexelsResponse.fromJson(response.data);
      return pexelsResponse.photos.map((e) => e.toEntity()).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Fallback or mock data if key is missing/invalid
        return _getMockPins();
      }
      rethrow;
    } catch (_) {
      // General error fallback
      return _getMockPins();
    }
  }

  @override
  Future<List<PinEntity>> searchPins(String query, int page, int perPage) async {
    try {
      final response = await dioClient.dio.get(
        'search',
        queryParameters: {
          'query': query,
          'page': page,
          'per_page': perPage,
        },
      );
      final pexelsResponse = PexelsResponse.fromJson(response.data);
      return pexelsResponse.photos.map((e) => e.toEntity()).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return _getMockPins(query: query);
      }
      rethrow;
    } catch (_) {
      return _getMockPins(query: query);
    }
  }

  List<PinEntity> _getMockPins({String? query}) {
    // Generate fallback mock data so app still functions without keys
    return List.generate(15, (index) {
      final height = 200 + (index % 3) * 100;
      return PinEntity(
        id: index,
        imageUrl: "https://picsum.photos/seed/\${query ?? 'curated'}$index/300/$height",
        detailUrl: "https://picsum.photos/seed/\${query ?? 'curated'}$index/600/${height * 2}",
        title: query != null ? 'Mock $query Pin $index' : 'Mock Curated Pin $index',
        author: 'Mock Photographer',
        avgColor: '#BBBBBB',
        width: 300,
        height: height,
      );
    });
  }
}
