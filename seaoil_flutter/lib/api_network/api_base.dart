import 'package:flutter/foundation.dart';

class APIBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "prod url here";
    } else {
      return "https://stable-api.pricelocq.com/mobile";
    }
  }
}