import 'dart:io';
import 'package:dio/dio.dart';
import 'package:expense_tracking/network_services/base_response_model.dart';
import 'package:expense_tracking/network_services/iservice_manager.dart';

final class DioServiceManager<T> extends IserviceManager<T> {
  late final Dio _dio;

  DioServiceManager() {
    _dio = Dio();
  }
  @override
  Future<BaseResponseModel<T>> get(String url) async {
    try {
      final response = await _dio.get(url);
      if (response.statusCode == HttpStatus.ok) {
        return BaseResponseModel(
          data: response.data,
        );
      }
      return BaseResponseModel(
        error: response.data,
      );
    } on DioException catch (e) {
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
  }
}
