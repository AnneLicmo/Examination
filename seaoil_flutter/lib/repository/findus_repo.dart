import 'dart:convert';
import 'dart:convert' as convert;
import 'package:seaoil_flutter/common/shared_preference.dart';
import 'package:seaoil_flutter/api_network/api_path.dart';
import 'package:seaoil_flutter/view_models/findus_models.dart';
import 'package:seaoil_flutter/api_network/http.client.dart';

class FindUsRepository {
  static Future<FindUSResponse> getLocationList() async {
    SeaoilPreferences prefs = SeaoilPreferences();
    var data, header;
    Map mapData;
    header = await prefs.getLocalStorage(SharedPrefsKeys.accessToken);
    final response = await HttpClient.instance
        .getData(APIPathHelper.getValue(APIPath.apilocation), header);
    data = jsonEncode(response);
    mapData = convert.json.decode(data);
    return FindUSResponse.fromJson(response);
  }
}
