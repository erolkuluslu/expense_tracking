import 'dart:io';
import 'package:dio/dio.dart';
import 'package:expense_tracking/data/datasources/base_response_model.dart';
import 'package:expense_tracking/data/datasources/iservice_manager.dart';

/// Implementation of [IserviceManager] using Dio HTTP client
final class DioServiceManager implements IserviceManager {
  late final Dio _dio;
  static const _defaultTimeout = Duration(seconds: 30);
  static const _defaultRetries = 3;

  DioServiceManager() {
    _dio = Dio()
      ..options.connectTimeout = _defaultTimeout
      ..options.receiveTimeout = _defaultTimeout
      ..options.sendTimeout = _defaultTimeout
      ..interceptors.add(
        InterceptorsWrapper(
          onError: (error, handler) async {
            if ([
              DioExceptionType.connectionTimeout,
              DioExceptionType.sendTimeout,
              DioExceptionType.receiveTimeout,
            ].contains(error.type)) {
              // Retry on timeout
              final retries = (error.requestOptions.extra['retries'] ?? 0) as int;
              if (retries < _defaultRetries) {
                error.requestOptions.extra['retries'] = retries + 1;
                return handler.resolve(await _dio.fetch(error.requestOptions));
              }
            }
            return handler.next(error);
          },
        ),
      );
  }

  /// Handles Dio exceptions and converts them to [BaseResponseModel]
  BaseResponseModel _handleDioException(DioException e) {
    final errorMessage = switch (e.type) {
      DioExceptionType.connectionTimeout => 'Connection timeout',
      DioExceptionType.sendTimeout => 'Send timeout',
      DioExceptionType.receiveTimeout => 'Receive timeout',
      DioExceptionType.badCertificate => 'Bad certificate',
      DioExceptionType.badResponse => 'Bad response: ${e.response?.statusCode}',
      DioExceptionType.cancel => 'Request cancelled',
      DioExceptionType.connectionError => 'Connection error',
      DioExceptionType.unknown => 'Unknown error',
    };

    return BaseResponseModel.error(
      e.response?.data?.toString() ?? errorMessage,
      statusCode: e.response?.statusCode,
    );
  }

  /// Handles successful responses and converts them to [BaseResponseModel]
  BaseResponseModel _handleResponse(Response response) {
    if (response.statusCode == HttpStatus.ok) {
      return BaseResponseModel.success(
        response.data,
        statusCode: response.statusCode,
      );
    }
    return BaseResponseModel.error(
      response.data?.toString() ?? 'Unknown error',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<BaseResponseModel> get(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(extra: {'retries': 0}),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return BaseResponseModel.error(e.toString());
    }
  }

  @override
  Future<BaseResponseModel> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(extra: {'retries': 0}),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return BaseResponseModel.error(e.toString());
    }
  }

  @override
  Future<BaseResponseModel> put(String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(
        url,
        data: body,
        options: Options(extra: {'retries': 0}),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return BaseResponseModel.error(e.toString());
    }
  }

  @override
  Future<BaseResponseModel> delete(String url) async {
    try {
      final response = await _dio.delete(
        url,
        options: Options(extra: {'retries': 0}),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return BaseResponseModel.error(e.toString());
    }
  }
}
