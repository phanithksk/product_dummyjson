import 'package:produce_api/data/network/api_url.dart';
import 'package:produce_api/data/network/network_servise.dart';
import 'package:produce_api/model/auth/login_model.dart';

class AuthRepository {
  final api = NetworkServise();

  //! Login
  Future<LoginModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    var res = LoginModel();
    String url = Api().loginUrl;
    var requestBody = {
      "phoneNumber": phoneNumber,
      "password": password,
    };
    var response = await api.postLoginApi(url, requestBody: requestBody);
    res = LoginModel.fromJson(response);
    return res;
  }
}
