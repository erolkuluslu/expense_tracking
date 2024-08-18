import 'package:expense_tracking/network_services/base_response_model.dart';

abstract class IserviceManager<T> {
  Future<BaseResponseModel<T>> get(String url);
//Future<BaseResponseModel<T>> post(String url, Map<String, dynamic> body);
}
