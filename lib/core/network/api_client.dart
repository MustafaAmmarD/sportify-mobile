import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sportify/core/constants/api_constants.dart';
import 'package:sportify/core/constants/app_constants.dart';
import 'package:sportify/core/error/exceptions.dart' as app;
import 'package:sportify/core/network/api_interceptors.dart';

/// Configured Dio HTTP client for the Sportify API.
///
/// This class wraps [Dio] with:
/// - Base URL and timeout configuration
/// - Interceptor pipeline (Auth → Logging → Error)
/// - Typed error handling
class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(
        milliseconds: AppConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  final Dio _dio;

  /// GET request with optional query parameters.
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<dynamic>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// POST request with a request body.
  Future<Response<dynamic>> post(String path, {dynamic data}) async {
    try {
      return await _dio.post<dynamic>(path, data: data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// DELETE request.
  Future<Response<dynamic>> delete(String path) async {
    try {
      return await _dio.delete<dynamic>(path);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Maps [DioException] to our custom [app.SportifyException] hierarchy.
  app.SportifyException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const app.TimeoutException();
      case DioExceptionType.connectionError:
        return const app.NetworkException();
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.cancel:
        return const app.UnknownException(message: 'Request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const app.NetworkException();
        }
        return app.UnknownException(
          message: e.message ?? 'An unexpected error occurred.',
        );
      case DioExceptionType.transformTimeout:
        return const app.TimeoutException();
    }
  }

  /// Maps HTTP status codes to typed exceptions.
  app.SportifyException _handleBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode ?? 500;
    final data = response?.data;

    // Try to extract message from Laravel's response format
    final message =
        data is Map<String, dynamic>
            ? (data['message'] as String?) ?? 'Server error'
            : 'Server error';

    switch (statusCode) {
      case 400:
        return app.BadRequestException(message: message);
      case 401:
        return app.UnauthorizedException(message: message);
      case 403:
        return app.ForbiddenException(message: message);
      case 404:
        return app.NotFoundException(message: message);
      case 422:
        // Parse Laravel's validation error format
        final errors = <String, List<String>>{};
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final rawErrors = data['errors'] as Map<String, dynamic>;
          for (final entry in rawErrors.entries) {
            if (entry.value is List) {
              errors[entry.key] = (entry.value as List<dynamic>).cast<String>();
            }
          }
        }
        return app.ValidationException(message: message, errors: errors);
      case 429:
        return app.RateLimitException(message: message);
      default:
        return app.ServerException(message: message);
    }
  }
}
