class LoginDataRequest {
  String mobileNumber;
  String password;

  LoginDataRequest({
    required this.mobileNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobileNumber,
      'password': password,
    };
    return map;
  }
}

class LoginDataResponse {
  final String status;
  final LoginData listData;
  LoginDataResponse({required this.listData, required this.status});
  factory LoginDataResponse.fromJson(Map<String, dynamic> data) {
    return LoginDataResponse(
        status: data['status'], listData: LoginData.fromJson(data['data']));
  }
}

class LoginData {
  LoginData(
      {required this.id,
      required this.accessToken,
      required this.refreshToken,
      required this.userId,
      required this.createdAt,
      required this.expiresAt,
      required this.updatedAt,
      required this.userUuid,
      required this.code,
      required this.message});
  int id;
  String accessToken;
  String refreshToken;
  int userId;
  String createdAt;
  String expiresAt;
  String updatedAt;
  String userUuid;
  String code;
  String message;
  factory LoginData.fromJson(Map<String, dynamic> data) {
    final id = data['id'] ?? 0;
    final accessToken = data['accessToken'] ?? "";
    final refreshToken = data['refreshToken'] ?? "";
    final userId = data['userId'] ??0;
    final expiresAt = data['expiresAt'] ?? "";
    final updatedAt = data['updatedAt'] ?? "";
    final createdAt = data['createdAt'] ?? "";
    final userUuid = data['userUuid'] ?? "";
    final code = data['code'] ?? "";
    final message = data['message'] ?? "";
    return LoginData(
        id: id,
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        expiresAt: expiresAt,
        updatedAt: updatedAt,
        createdAt: createdAt,
        userUuid: userUuid,
        code: code,
        message: message);
  }
}
