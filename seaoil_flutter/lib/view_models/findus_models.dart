class FindUSRequest {
  String mobileNumber;
  String password;

  FindUSRequest({
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

class FindUSResponse {
  String status;
  List<SeaoilStation> stationlist;

  FindUSResponse({required this.status, required this.stationlist});
  factory FindUSResponse.fromJson(Map<String, dynamic> data) {
    Iterable list = data['data'];
    List<SeaoilStation> stationlist =
        list.map((i) => SeaoilStation.fromJson(i)).toList();
    return FindUSResponse(status: data['status'], stationlist: stationlist);
  }
}

class SeaoilStation {
  final int id;
  final String code;
  final String mobileNum;
  final String area;
  final String province;
  final String city;
  final String name;
  final String businessName;
  final String address;
  final String lat;
  final String lng;
  final String type;
  final int depotId;
  final int dealerId;
  final String createdAt;
  final String updatedAt;

  SeaoilStation(
      {required this.id,
      required this.code,
      required this.mobileNum,
      required this.area,
      required this.province,
      required this.city,
      required this.name,
      required this.businessName,
      required this.address,
      required this.lat,
      required this.lng,
      required this.type,
      required this.depotId,
      required this.dealerId,
      required this.createdAt,
      required this.updatedAt});

  factory SeaoilStation.fromJson(Map<String, dynamic> data) {
    int id = data['id'] ?? 0;
    String code = data['code'] ?? "";
    String mobileNum = data['mobileNum'] ?? "";
    String area = data['area'] ?? "";
    String province = data['province'] ?? "";
    String city = data['city'] ?? "";
    String name = data['name'] ?? "";
    String businessName = data['businessName'] ?? "";
    String address = data['address'] ?? "";
    String lat = data['lat'] ?? "";
    String lng = data['lng'] ?? "";
    String type = data['type'] ?? "";
    int depotId = data['depotId'] ?? data['depotId'] ?? 0;
    int dealerId = data['dealerId'] ?? data['dealerId'] ?? 0;
    String createdAt = data['createdAt'] ?? "";
    String updatedAt = data['updatedAt'] ?? "";
    return SeaoilStation(
        id: id,
        code: code,
        mobileNum: mobileNum,
        area: area,
        province: province,
        city: city,
        name: name,
        businessName: businessName,
        address: address,
        lat: lat,
        lng: lng,
        type: type,
        depotId: depotId,
        dealerId: dealerId,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }
}

class StationDetail {
  String stationName;
  String stationLat;
  String stationLong;
  String address;
  double distance;

  StationDetail(
      {required this.stationName,
      required this.stationLat,
      required this.stationLong,
      required this.address,
      required this.distance});
}
