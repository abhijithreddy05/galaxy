import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.pexels.com/v1/',
        headers: {
          'Authorization': dotenv.env['PEXELS_API_KEY'] ?? '',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // If we want logging or token refresh, we do it here.
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print('Dio Error: \${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
