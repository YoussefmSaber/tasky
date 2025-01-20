import 'package:dio/dio.dart';
import 'package:tasky/core/constants/endpoints.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';

class DioClient {
  late Dio dio;
  final SharedPreferenceService preferenceService;
  final Function() onLogout;

  DioClient(this.preferenceService, this.onLogout) {
    dio = Dio(BaseOptions(
        baseUrl: "https://todo.iraqsapp.com",
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        }));

    dio.interceptors.addAll([
      LogInterceptor(responseBody: true),
      _createAuthInterceptor(),
    ]);
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = preferenceService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh
          try {
            final newToken = await _refreshToken();
            // Retry the original request with new token
            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            final response = await dio.fetch(opts);
            return handler.resolve(response);
          } catch (e) {
            // Refresh failed, trigger logout
            await preferenceService.clearTokens();
            onLogout();
            return handler.reject(error);
          }
        }
        return handler.next(error);
      },
    );
  }

  Future<String> _refreshToken() async {
    final refreshToken = preferenceService.getRefreshToken();
    final currentToken = preferenceService.getAccessToken();

    if (refreshToken == null || currentToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await dio.get(ApiEndpoints.refreshToken,
          queryParameters: {'token': refreshToken},
          options: Options(headers: {'Authorization': 'Bearer $currentToken'}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newToken = response.data['access_token'];
        await preferenceService.saveAccessToken(newToken);
        return newToken;
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Failed to refresh token');
    }
  }
}
