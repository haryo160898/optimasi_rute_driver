import 'package:dio/dio.dart';

import 'api_exceptions.dart';

class ApiClient {
  ApiClient({required String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkException('Waktu koneksi habis. Silakan coba lagi.');
    }

    if (e.type == DioExceptionType.connectionError) {
      return const NetworkException('Tidak ada koneksi internet.');
    }

    if (e.response != null) {
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 401) {
        return const UnauthorizedException();
      }
      if (statusCode == 400 || statusCode == 422) {
        final data = e.response?.data;
        final message = data is Map
            ? data['message'] ?? 'Validasi gagal.'
            : 'Permintaan tidak valid.';
        return ValidationException(message.toString());
      }
      if (statusCode == 404) {
        return const NotFoundException('Data tidak ditemukan.');
      }
      if (statusCode >= 500) {
        return const ApiException('Server sedang mengalami masalah.');
      }
    }

    if (e.error is FormatException) {
      return const ApiException('Respons tidak valid.');
    }

    return ApiException(e.message ?? 'Terjadi kesalahan yang tidak diketahui.');
  }
}
