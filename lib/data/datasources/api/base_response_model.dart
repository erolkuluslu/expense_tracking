/// base_response_model.dart
library;

final class BaseResponseModel<T> {
  /// Creates a BaseResponseModel instance
  ///
  /// [data] - The response data
  /// [error] - Error message if request failed
  /// [statusCode] - HTTP status code of the response
  const BaseResponseModel({
    this.data,
    this.error,
    this.statusCode,
  });

  /// Creates a success response
  factory BaseResponseModel.success(T? data, {int? statusCode}) {
    return BaseResponseModel(
      data: data,
      statusCode: statusCode,
    );
  }

  /// Creates an error response
  factory BaseResponseModel.error(String error, {int? statusCode}) {
    return BaseResponseModel(
      error: error,
      statusCode: statusCode,
    );
  }

  /// The response data of type T
  final T? data;

  /// Error message if any
  final String? error;

  /// HTTP status code of the response
  final int? statusCode;

  /// Whether the response was successful
  bool get isSuccess =>
      error == null &&
      ((statusCode == null) || (statusCode! >= 200 && statusCode! < 300));

  /// Creates a copy of this response with some fields replaced
  BaseResponseModel<T> copyWith({
    T? Function()? data,
    String? Function()? error,
    int? Function()? statusCode,
  }) {
    return BaseResponseModel<T>(
      data: data != null ? data() : this.data,
      error: error != null ? error() : this.error,
      statusCode: statusCode != null ? statusCode() : this.statusCode,
    );
  }

  @override
  String toString() {
    return 'BaseResponseModel(data: $data, error: $error, statusCode: $statusCode)';
  }
}
