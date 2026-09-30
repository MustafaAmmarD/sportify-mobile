import 'dart:developer';

import 'package:dio/dio.dart';

/// ── Auth Interceptor ──
///
/// Attaches the Bearer token to every request.
/// On 401 response, will attempt token refresh (when auth is implemented).
///
/// TODO(mustafa): Wire up token storage once auth strategy is confirmed
/// with Tony. Currently a no-op placeholder.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO(mustafa): Read token from flutter_secure_storage
    // final token = await _secureStorage.read(key: 'auth_token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO(mustafa): Attempt token refresh, retry request
      // For now, pass the error through
      log('AUTH: 401 Unauthorized — token may be expired');
    }
    handler.next(err);
  }
}

/// ── Logging Interceptor ──
///
/// Logs request and response details in debug mode only.
/// Uses `dart:developer` for DevTools integration.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '→ ${options.method} ${options.uri}',
      name: 'API',
    );
    if (options.queryParameters.isNotEmpty) {
      log(
        '  Query: ${options.queryParameters}',
        name: 'API',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      name: 'API',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '✖ ${err.response?.statusCode ?? 'NO_STATUS'} '
      '${err.requestOptions.uri} — ${err.message}',
      name: 'API',
      level: 1000,
    );
    handler.next(err);
  }
}

/// ── Error Interceptor ──
///
/// This interceptor currently passes errors through.
/// The main error mapping logic lives in [ApiClient._handleDioException]
/// to keep it close to the response handling.
///
/// This interceptor is reserved for future global error behaviors like:
/// - Showing a global "server down" banner
/// - Triggering analytics for error tracking
/// - Retry logic for specific error codes
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Reserved for future global error handling
    handler.next(err);
  }
}
