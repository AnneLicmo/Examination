enum APIPath {
  apiLogin,
  location,
}

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.apiLogin:
        return "/v2/sessions";
      case APIPath.location:
        return "/stations?all";
      default:
        return "";
    }
  }
}
