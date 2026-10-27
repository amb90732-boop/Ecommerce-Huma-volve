import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_res_model.dart';

class SignupServicers {
  ApiClient apiClient;
  SignupServicers(this.apiClient);
  Future<signupResModel> signUp(SignupReqModel signupReqModel) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        "email": signupReqModel.email,
        "name": signupReqModel.name,
        "password": signupReqModel.password,
        // "role": signupReqModel.,
        "avatar": "https://i.imgur.com/LDOO4Qs.jpg",
      },
    );

    final jsonData = response.data;

    final dartData = signupResModel.fromJson(jsonData);

    return dartData;
  }
}
