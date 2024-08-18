final class BaseResponseModel<T> {
  final T? data;
  final String? error;

  BaseResponseModel({this.data, this.error});
}
