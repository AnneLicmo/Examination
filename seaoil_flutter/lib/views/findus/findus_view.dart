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
  int value = -1;
  int value1 = -1;
  late TextEditingController _searchController;
  late GoogleMapController _controller;
  late Position currentLocation;
  late LatLng _center = LatLng(0.0, 0.0);
  late LatLng _oldLocation;
  var errorMessage;
  bool isSearching = false,
      showLoading = false,
      isCameraMove = false,
      isShowDetail = false;
  String query = "", stationName = "", address = "", distance = "";
  List<StationDetail> _searchResult = [],
      _getCompleteStationList = [],
      _getStationList = [];
  List<Marker> allMarkers = [];
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
                    _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: _oldLocation, zoom: 18.0)));
                    setState(() {
                      isSearching = false;
                      isShowDetail = false;
                      _center = _oldLocation;
                      query = "";
                      _searchController.text = "";
                      value = -1;
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
            : _getStationList.isNotEmpty
                ? bottom()
                : null,
      ),
    );
  }

//----------------------------FUNCTIONS-------------------------//
  getStationList() {
    FindUsRepository.getLocationList().then((value) async {
      if (value.status == "success") {
        await Future.delayed(const Duration(seconds: 3));
        currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        for (var item in value.stationlist) {
          final distance = Geolocator.distanceBetween(
              currentLocation.latitude,
              currentLocation.longitude,
              double.parse(item.lat),
              double.parse(item.lng));
          double distanceInKiloMeters = distance / 1000;
          double roundDistanceInKM =
              double.parse((distanceInKiloMeters).toStringAsFixed(2));
          int vString = (roundDistanceInKM * 100).toInt();
          int totalKM = vString ~/ 100;
          if (totalKM <= 4) {
            _getStationList.add(StationDetail(
                stationName: item.name,
                stationLat: item.lat,
                stationLong: item.lng,
                address: item.address,
                distance: totalKM));
          }
          _getCompleteStationList.add(StationDetail(
              stationName: item.name,
              stationLat: item.lat,
              stationLong: item.lng,
              address: item.address,
              distance: totalKM));
        }
        setState(() {
          _center = LatLng(currentLocation.latitude, currentLocation.longitude);
          _oldLocation = _center;
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
      String inCaps = '${value.toUpperCase()}';
      setState(() {
        query = value;
        for (var element in _getCompleteStationList) {
          if (element.stationName.toUpperCase().contains(inCaps)) {
            _searchResult.add(element);
          }
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
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
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 18.0,
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
                  itemCount: _getCompleteStationList.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, index) {
                    return RadioListTile(
                      value: index,
                      groupValue: value1,
                      controlAffinity: ListTileControlAffinity.trailing,
                      onChanged: (ind) {
                        _center = LatLng(
                            double.parse(
                                _getCompleteStationList[index].stationLat),
                            double.parse(
                                _getCompleteStationList[index].stationLong));
                        _controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: _center, zoom: 18.0)));
                        setState(() {
                          isSearching = false;
                          isShowDetail = true;

                          allMarkers.add(Marker(
                              markerId: MarkerId(
                                  _getCompleteStationList[index].stationName),
                              draggable: false,
                              position: _center));
                          value = index;
                          stationName =
                              _getCompleteStationList[index].stationName;
                          address = _getCompleteStationList[index].address;
                          distance = _getCompleteStationList[index]
                              .distance
                              .toString();
                        });
                      },
                      title: Text(
                        _getCompleteStationList[index].stationName,
                        style: const TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        _getCompleteStationList[index].distance.toString() +
                            " km away from you",
                        style: const TextStyle(fontSize: 11),
                      ),
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
                        groupValue: value1,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (ind) {
                          _controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(
                                      double.parse(
                                          _searchResult[index].stationLat),
                                      double.parse(
                                          _searchResult[index].stationLong)),
                                  zoom: 18.0)));
                          setState(() {
                            isSearching = false;
                            isShowDetail = true;
                            _center = LatLng(
                                double.parse(_searchResult[index].stationLat),
                                double.parse(_searchResult[index].stationLong));
                            allMarkers.add(Marker(
                                markerId:
                                    MarkerId(_searchResult[index].stationName),
                                draggable: false,
                                position: _center));
                            value = index;
                            stationName = _searchResult[index].stationName;
                            address = _searchResult[index].address;
                            distance = _searchResult[index].distance.toString();
                          });
                        },
                        toggleable: true,
                        title: Text(
                          _searchResult[index].stationName,
                          style: const TextStyle(fontSize: 12),
                        ),
                        subtitle: Text(
                          _searchResult[index].distance.toString() +
                              " km away from you",
                          style: const TextStyle(fontSize: 11),
                        ),
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
      builder: (BuildContext ctx) =>
          isShowDetail ? detailStation() : displayStationList(),
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
                  _controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(
                              double.parse(_getStationList[index].stationLat),
                              double.parse(_getStationList[index].stationLong)),
                          zoom: 18.0)));

                  setState(() {
                    _center = LatLng(
                        double.parse(_getStationList[index].stationLat),
                        double.parse(_getStationList[index].stationLong));
                    allMarkers.add(Marker(
                        markerId: MarkerId(_getStationList[index].stationName),
                        draggable: false,
                        position: _center));
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
                  style: const TextStyle(fontSize: 12),
                ),
                subtitle: Text(
                    _getStationList[index].distance.toString() +
                        " km away from you",
                    style: const TextStyle(fontSize: 11)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget detailStation() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: const BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
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
                    _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: _oldLocation, zoom: 18.0)));
                    setState(() {
                      isSearching = false;
                      isShowDetail = false;
                      _center = _oldLocation;
                      _searchController.text = "";
                      query == "";
                      actionIcon = const Icon(
                        Icons.search,
                        color: Colors.white,
                      );
                      value = -1;
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
                    // setState(() {
                    //   isSearching = true;
                    //   isShowDetail = false;
                    // });
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
    );
  }
// --------------------------------------------------------------------------//
}
