import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:seaoil_flutter/common/mapUrl/map.dart';
import 'api_base.dart';
import 'api_exceptions.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;

  Future<dynamic> fetchData(String url,
      {required Map<String, String> params}) async {
    var responseJson = "";

    var uri = APIBase.baseURL +
        url +
        ((params != null) ? this.queryParameters(params) : "");

    var header = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      final response = await http.get(Uri(path: uri), headers: header);
      debugPrint(response.body.toString());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw SocketDataException('No Internet connection');
    }
    return responseJson;
  }

  String queryParameters(Map<String, String> params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }

  Future<dynamic> getData(String url, String tkn) async {
    var responseJson;
    var header = GetMapped.headerAuthorization(tkn);
    var pathUrl = APIBase.baseURL + url;
    try {
      final response = await http.get(Uri.parse(pathUrl), headers: header);
      debugPrint(response.body.toString());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw SocketDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postData(String url, dynamic body) async {
    var responseJson;
    var header = GetMapped.simpleHeader();
    var pathUrl = APIBase.baseURL + url;
    try {
      final response =
          await http.post(Uri.parse(pathUrl), headers: header, body: body);
      debugPrint(response.body.toString());
      responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw SocketDataException('No Internet connection');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> postDataWithAuth(String url, String tkn, dynamic body) async {
    var responseJson;
    var header = GetMapped.headerAuthorization(tkn);
    var pathUrl = APIBase.baseURL + url;
    try {
      final response =
          await http.post(Uri(path: pathUrl), body: body, headers: header);
      debugPrint(response.body.toString());
      responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw const SocketException('No Internet connection');
    } catch (e) {}
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        //var responseJson = json.decode(response.body.toString());
        //return BadRequestException(responseJson["Error_Message"]);
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
      case 404:
        var responseJson = json.decode(response.body.toString());
        throw UnauthorisedException(responseJson["Error_Message"]);
      case 405:
        //var responseJson = json.decode(response.body.toString());
        //return SupportException(responseJson["Error_Message"]);
        throw SupportException(response.body.toString());

      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
