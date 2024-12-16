/// dio_service_manager.dart
library;

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:expense_tracking/data/datasources/services/base_response_model.dart';
import 'package:expense_tracking/data/datasources/services/iservice_manager.dart';

class DioServiceManager<T> extends IserviceManager<T> {
  DioServiceManager() {
    _dio = Dio()
      ..options.connectTimeout = _defaultTimeout
      ..options.receiveTimeout = _defaultTimeout
      ..options.sendTimeout = _defaultTimeout
      ..interceptors.add(
        InterceptorsWrapper(
          onError: (error, handler) async {
            // Cast retries to an int
            final retries =
                (error.requestOptions.extra['retries'] as int?) ?? 0;

            // Make sure all conditions are clearly boolean expressions
            if (((error.type == DioExceptionType.connectionTimeout) ||
                    (error.type == DioExceptionType.sendTimeout) ||
                    (error.type == DioExceptionType.receiveTimeout)) &&
                (retries < _defaultRetries)) {
              error.requestOptions.extra['retries'] = retries + 1;
              return handler.resolve(await _dio.fetch(error.requestOptions));
            }

            return handler.next(error);
          },
        ),
      );
  }
  late final Dio _dio;
  static const _defaultTimeout = Duration(seconds: 30);
  static const _defaultRetries = 3;

  BaseResponseModel<T> _handleDioException(DioException e) {
    String errorMessage;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad certificate';
      case DioExceptionType.badResponse:
        errorMessage = 'Bad response: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
      case DioExceptionType.connectionError:
        errorMessage = 'Connection error';
      case DioExceptionType.unknown:
      default:
        errorMessage = 'Unknown error';
    }
    return BaseResponseModel<T>(
      error: e.response?.data?.toString() ?? errorMessage,
      statusCode: e.response?.statusCode,
    );
  }

  BaseResponseModel<T> _handleResponse(Response response) {
    if (response.statusCode == HttpStatus.ok) {
      return BaseResponseModel<T>(
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    }
    return BaseResponseModel<T>(
      error: response.data?.toString() ?? 'Unknown error',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<BaseResponseModel<T>> get(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(extra: {'retries': 0}),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return BaseResponseModel<T>(error: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<T>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
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
      return BaseResponseModel<T>(error: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<T>> put(
    String url,
    Map<String, dynamic> body,
  ) async {
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
      return BaseResponseModel<T>(error: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<T>> delete(String url) async {
    try {
      final response = await _dio.delete(
        url,
        options: Options(extra: {'retries': 0}),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return BaseResponseModel<T>(error: e.toString());
    }
  }
}
