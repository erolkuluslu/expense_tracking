import 'package:expense_tracking/data/datasources/api/base_response_model.dart';

/// Interface for making HTTP requests
/// T is the type of data expected in the response
abstract class IserviceManager<T> {
  /// Makes a GET request to the specified URL
  /// Returns a [BaseResponseModel] containing either the response data or an error
  Future<BaseResponseModel<T>> get(String url);

  /// Makes a POST request to the specified URL with the given body
  /// Returns a [BaseResponseModel] containing either the response data or an error
  Future<BaseResponseModel<T>> post(String url, Map<String, dynamic> body);

  /// Makes a PUT request to the specified URL with the given body
  /// Returns a [BaseResponseModel] containing either the response data or an error
  Future<BaseResponseModel<T>> put(String url, Map<String, dynamic> body);

  /// Makes a DELETE request to the specified URL
  /// Returns a [BaseResponseModel] containing either the response data or an error
  Future<BaseResponseModel<T>> delete(String url);
}
