import 'package:pinterest_clone/domain/entities/pin_entity.dart';

class PexelsResponse {
  final int page;
  final int perPage;
  final List<PexelsPhoto> photos;

  PexelsResponse({
    required this.page,
    required this.perPage,
    required this.photos,
  });

  factory PexelsResponse.fromJson(Map<String, dynamic> json) {
    return PexelsResponse(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      photos: (json['photos'] as List? ?? [])
          .map((e) => PexelsPhoto.fromJson(e))
          .toList(),
    );
  }
}

class PexelsPhoto {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String avgColor;
  final String srcLarge;
  final String srcLarge2x;
  final String alt;

  PexelsPhoto({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.avgColor,
    required this.srcLarge,
    required this.srcLarge2x,
    required this.alt,
  });

  factory PexelsPhoto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? src = json['src'] as Map<String, dynamic>?;
    return PexelsPhoto(
      id: json['id'] ?? 0,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      url: json['url'] ?? '',
      photographer: json['photographer'] ?? 'Unknown',
      avgColor: json['avg_color'] ?? '#FFFFFF',
      srcLarge: src?['large'] ?? '',
      srcLarge2x: src?['large2x'] ?? src?['large'] ?? '',
      alt: json['alt'] ?? 'Pin Image',
    );
  }

  PinEntity toEntity() {
    return PinEntity(
      id: id,
      imageUrl: srcLarge,
      detailUrl: srcLarge2x,
      title: alt,
      author: photographer,
      avgColor: avgColor,
      width: width,
      height: height,
    );
  }
}
