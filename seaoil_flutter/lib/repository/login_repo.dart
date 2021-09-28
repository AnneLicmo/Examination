import 'dart:convert';
import 'dart:convert' as convert;
import 'package:seaoil_flutter/common/shared_preference.dart';
import 'package:seaoil_flutter/api_network/api_path.dart';
import 'package:seaoil_flutter/view_models/login_models.dart';
import 'package:seaoil_flutter/api_network/http.client.dart';

class LoginRepository {
  static Future<LoginDataResponse> attemptLogin(
      LoginDataRequest requestData) async {
    SeaoilPreferences prefs = SeaoilPreferences();
    var body, data;
    Map mapData;
    body = jsonEncode(requestData.toJson());
    final response = await HttpClient.instance
        .postData(APIPathHelper.getValue(APIPath.apiLogin), body);
    data = jsonEncode(response);
    mapData = convert.json.decode(data);
    prefs.putLocalStorage(
        SharedPrefsKeys.accessToken, mapData['data']['accessToken']);
    return LoginDataResponse.fromJson(response);
  }
}
