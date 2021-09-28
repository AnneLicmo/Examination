enum APIPath {
  apiLogin,
  apilocation,
}

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.apiLogin:
        return "/v2/sessions";
      case APIPath.apilocation:
        return "/stations?all";
      default:
        return "";
    }
  }
}
