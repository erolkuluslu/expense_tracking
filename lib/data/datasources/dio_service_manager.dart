import 'dart:io';
import 'package:dio/dio.dart';
import 'package:expense_tracking/data/datasources/base_response_model.dart';
import 'package:expense_tracking/data/datasources/iservice_manager.dart';

/// Implementation of [IserviceManager] using Dio HTTP client
final class DioServiceManager<T> extends IserviceManager<T> {
  late final Dio _dio;

  DioServiceManager() {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  /// Handles Dio exceptions and converts them to [BaseResponseModel]
  BaseResponseModel<T> _handleDioException(DioException e) {
    if (e.response != null) {
      return BaseResponseModel(
        error: e.response!.data.toString(),
      );
    } else {
      return BaseResponseModel(
        error: e.message.toString(),
      );
    }
  }

  /// Handles successful responses and converts them to [BaseResponseModel]
  BaseResponseModel<T> _handleResponse(Response response) {
    if (response.statusCode == HttpStatus.ok) {
      return BaseResponseModel(
        data: response.data,
      );
    }
    return BaseResponseModel(
      error: response.data.toString(),
    );
  }

  @override
  Future<BaseResponseModel<T>> get(String url) async {
    try {
      final response = await _dio.get(url);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  @override
  Future<BaseResponseModel<T>> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(url, data: body);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  @override
  Future<BaseResponseModel<T>> put(String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(url, data: body);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  @override
  Future<BaseResponseModel<T>> delete(String url) async {
    try {
      final response = await _dio.delete(url);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }
}
