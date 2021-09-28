import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seaoil_flutter/common/widgets/widgets.dart';
import 'package:seaoil_flutter/repository/findus_repo.dart';
import 'package:seaoil_flutter/view_models/findus_models.dart';

class FindUsView extends StatefulWidget {
  static const routeName = '/findus';
  const FindUsView({Key? key}) : super(key: key);

  @override
  _FindUsViewState createState() => _FindUsViewState();
}

class _FindUsViewState extends State<FindUsView> {
  bool isSearching = false;
  int value = -1;
  late TextEditingController _searchController;
  late LatLng _center = LatLng(0.0, 0.0);
  late LatLng _newCamPosition;
  String long = "", latitude = "";
  var errorMessage;
  bool showLoading = false;
  bool isCameraMove = false;
  bool isShowDetail = false;
  String query = "", stationName = "", address = "", distance = "";
  GoogleMapController? _controller;
  List<StationDetail> _searchResult = [];
  List<StationDetail> _getStationList = [];

  Icon actionIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getStationList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            bottomOpacity: 0.0,
            backgroundColor: Colors.deepPurple,
            centerTitle: true,
            title: const Text("Search Station"),
            actions: [
              IconButton(
                  onPressed: () {
                    if (actionIcon.icon == Icons.search) {
                      actionIcon = const Icon(
                        Icons.close,
                        color: Colors.white,
                      );
                      setState(() {
                        isSearching = true;
                      });
                    } else {
                      actionIcon = const Icon(
                        Icons.search,
                        color: Colors.white,
                      );
                      setState(() {
                        isSearching = false;
                      });
                    }
                  },
                  icon: actionIcon)
            ],
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              isSearching
                  ? topSearchList()
                  : _getStationList.isNotEmpty
                      ? topHeader()
                      : const Center(child: CircularProgressIndicator()),
            ],
          ),
          bottomSheet: isSearching
              ? null
              : isShowDetail
                  ? bottomDetails()
                  : _getStationList.isNotEmpty
                      ? bottom()
                      : null),
    );
  }

//----------------------------FUNCTIONS-------------------------//
  getStationList() {
    FindUsRepository.getLocationList().then((value) async {
      if (value.status == "success") {
        await Future.delayed(const Duration(seconds: 3));
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        for (var item in value.stationlist) {
          final distance = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              double.parse(item.lat),
              double.parse(item.lng));
          double distanceInKiloMeters = distance / 1000;
          double roundDistanceInKM =
              double.parse((distanceInKiloMeters).toStringAsFixed(2));
          _getStationList.add(StationDetail(
              stationName: item.name,
              stationLat: item.lat,
              stationLong: item.lng,
              address: item.address,
              distance: roundDistanceInKM));
        }
        setState(() {
          _center = LatLng(position.latitude, position.longitude);
        });
      }
    }).catchError((e) {
      errorMessage = e.toString();
      showModalErrorDialog(context, errorMessage);
    });
  }

  getDetails(String value) {
    _searchResult.clear();
    if (value != "") {
      String inCaps = '${value[0].toUpperCase()}${value.substring(1)}';
      setState(() {
        query = value;
        for (var element in _getStationList) {
          if (element.stationName.contains(inCaps) ||
              element.stationName.contains(inCaps)) {
            _searchResult.add(element);
          }
        }
      });
    }
  }

  _onCameraMove(CameraPosition position) {
    _newCamPosition = position.target;
  }

// --------------------------Top Header Search-----------------------//
  Widget topHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.deepPurple,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const <Widget>[
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 5, 25, 20),
                child: Text(
                  "Which PriceLOCQ station will you likely visit?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
          ),
        ),
      ],
    );
  }

// ---------------------- Top Header Search list -------------------//
  Widget topSearchList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.deepPurple,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 5, 25, 20),
                child: Text(
                  "Which PriceLOCQ station will you likely visit?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 20),
                child: TextFormField(
                  controller: _searchController,
                  autofocus: false,
                  onChanged: (value) {
                    if (value != "") {
                      setState(() {
                        query = value;
                        getDetails(query);
                      });
                    } else {
                      setState(() {
                        query = "";
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search,
                        color: Color.fromRGBO(50, 62, 72, 1.0)),
                    hintText: 'Search',
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 1.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        query == ""
            ? Expanded(
                child: ListView.builder(
                  itemCount: _getStationList.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, index) {
                    return RadioListTile(
                      value: index,
                      groupValue: value,
                      controlAffinity: ListTileControlAffinity.trailing,
                      onChanged: (ind) {
                        setState(() {
                          value = index;
                          isSearching = false;
                          isShowDetail = true;
                          stationName = _getStationList[index].stationName;
                          address = _getStationList[index].address;
                          distance = _getStationList[index].distance.toString();
                        });
                      },
                      title: Text(
                        _getStationList[index].stationName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                          _getStationList[index].distance.toString() +
                              " km away from you"),
                    );
                  },
                ),
              )
            : Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0))),
                  child: ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (BuildContext context, index) {
                      stationName = _searchResult[index].stationName;
                      return RadioListTile(
                        value: index,
                        groupValue: value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (ind) {
                          setState(() {
                            value = index;
                            isShowDetail = true;
                            stationName = _searchResult[index].stationName;
                            address = _searchResult[index].address;
                            distance = _searchResult[index].distance.toString();
                          });
                        },
                        toggleable: true,
                        title: Text(
                          _getStationList[index].stationName,
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                            _getStationList[index].distance.toString() +
                                " km away from you"),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }

//----------------------UPON LOADING BOTTOMSHEET-----------------------------//
  Widget bottom() {
    return BottomSheet(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      onClosing: () {},
      builder: (BuildContext ctx) => displayStationList(),
    );
  }

  Widget displayStationList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Nearby Station"),
              Text(
                "Done",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.30,
          decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: ListView.builder(
            itemCount: _getStationList.length,
            itemBuilder: (BuildContext context, index) {
              return RadioListTile(
                value: index,
                groupValue: value,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (ind) {
                  setState(() {
                    value = index;
                    isShowDetail = true;
                    stationName = _getStationList[index].stationName;
                    address = _getStationList[index].address;
                    distance = _getStationList[index].distance.toString();
                  });
                },
                toggleable: true,
                title: Text(
                  _getStationList[index].stationName,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(_getStationList[index].distance.toString() +
                    " km away from you"),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget bottomDetails() {
    return BottomSheet(
        onClosing: () {}, builder: (BuildContext ctx) => detailStation());
  }

  Widget detailStation() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: const BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Expanded(
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        isShowDetail = false;
                      });
                    },
                    child: const Text(
                      'Back to list',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      isSearching = true;
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                stationName,
                style: const TextStyle(fontSize: 12),
              ),
              subtitle: Text(
                address,
                style: const TextStyle(fontSize: 10),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.car_rental),
                  Text(
                    distance + " km away",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.lock_clock),
                  const Text(
                    'Open 24 hours',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
// --------------------------------------------------------------------------//
}
