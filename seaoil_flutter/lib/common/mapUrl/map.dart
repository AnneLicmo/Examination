import 'package:flutter/cupertino.dart';

class GetMapped {
  static Map<String, String> simpleHeader() {
    Map<String, String> header = {"Content-type": "application/json"};
    return header;
  }

  static Map<String, String> authorizationBearer(String tkn) {
    Map<String, String> header = {
      "Content-type": "application/json",
      "Authorization": "Bearer $tkn"
    };
    return header;
  }

  static Map<String, String> headerAuthorization(String tkn) {
    Map<String, String> header = {"Authorization": "$tkn"};
    return header;
  }

  static Map<String, String> header1(String tkn) {
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $tkn"
    };
    return header;
  }

  static Map<String, String> headersCharset() {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    return headers;
  }

  static Map<String, String> headersWithAutho(String tkn) {
    Map<String, String> headers = {"Authorization": "Bearer $tkn"};
    return headers;
  }

  static double superSmall(BuildContext context) {
    return ((MediaQuery.of(context).size.width) * 0.028);
  }

  static String reportViaEmail(String device, String os, String appVer,
      String name, String mobileNo, String concern) {
    String emailBody = "Device: $device<br>"
        "OS: $os<br>"
        "App Version: (for testing only) $appVer<br>"
        "Name: $name<br>"
        "Mobile Number: $mobileNo<br>"
        "Concern:<br> $concern";
    return emailBody;
  }
}
