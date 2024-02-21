import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yatrasahayatri/Routes.dart';
import 'package:yatrasahayatri/models/LoLatLong.dart';
import 'package:yatrasahayatri/models/TripModel.dart';
import 'package:yatrasahayatri/providers/AppProvider.dart';
import 'package:yatrasahayatri/services/geolocation/GeolocationApi.dart';
import 'package:yatrasahayatri/services/remote/TripApi.dart';
import 'package:yatrasahayatri/uis/travel_plan/YourTravelPlanPage.dart';
import 'package:yatrasahayatri/utils/Commons.dart';

class MapViewPage extends StatefulWidget {
  final bool showTripPlan;
  TripModel? model;
  final bool viewOnly;

  MapViewPage({
    Key? key,
    required this.showTripPlan,
    required this.viewOnly,
    TripModel? model,
  }) : super(key: key) {
    this.model = model;
  }

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  AppProvider? provider;
  String location = "Search Location";
  Set<Marker> _markers = {};
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  _setMarker(LatLng latLng, String markerIdKey) {
    Marker marker = Marker(
      markerId: MarkerId(markerIdKey),
      position: latLng,
    );
    _markers = {};
    _markers.add(marker);
  }

  _setMarkers(LatLng latLng, String markerIdKey, String placeName) {
    Marker marker = Marker(
      markerId: MarkerId(markerIdKey),
      position: latLng,
      infoWindow: InfoWindow(title: placeName),
    );
    _markers.add(marker);
  }

  Future<void> _goToThatLocation(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    var position = CameraPosition(
      target: latLng,
      zoom: 12,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future _searchPlacesAutocomplete() async {
    GeolocationApi.searchPlacesAutocomplete(
      context,
      (String locationName) {
        setState(() {
          location = locationName;
        });
      },
      (LatLng newlatlang) async {
        //move map camera to selected place with animation
        _goToThatLocation(newlatlang);
        _setMarker(newlatlang, "'currentLocation'");
        provider!.currentLocation = newlatlang;
        setState(() {});
        // GeolocationApi.getAddressFromLatLng(newlatlang).then((value) {
        //   provider!.trip!.placeName = value;
        // });
      },
    );
  }

  Future initSelectPlace() async {
    try {
      Position position = await GeolocationApi.getCurrentPosition();
      LatLng latLng = LatLng(position.latitude, position.longitude);
      //move map camera to selected place with animation
      _goToThatLocation(latLng);
      _setMarker(latLng, "'currentLocation'");
      provider!.currentLocation = latLng;
      provider!.trip!.latLong = LoLatLong(
        long: latLng.longitude,
        lat: latLng.latitude,
      );
      setState(() {});

      // GeolocationApi.getAddressFromLatLng(latLng).then((value) {
      //   provider!.trip!.placeName = value;
      // });
    } catch (e) {
      print(e);
    }
  }

  Future initShowInMap() async {
    try {
      List<Content>? content = null;
      if (widget.viewOnly) {
        content = widget.model!.content!;
      } else {
        content = provider!.trip!.content;
      }
      if (content != null && content.length > 0) {
        _markers = {};
        //move map camera to selected place with animation
        LatLng latLng = LatLng(
          content[0].latLong!.lat!,
          content[0].latLong!.long!,
        );
        _goToThatLocation(latLng);
        content.forEach((element) {
          LatLng markLatLng = LatLng(
            element.latLong!.lat!,
            element.latLong!.long!,
          );
          _setMarkers(markLatLng, "${element.placeId}", "${element.name}");
        });
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!widget.showTripPlan) {
          initSelectPlace();
        } else {
          initShowInMap();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);

    print(
        "showTripPlan-------> ${widget.showTripPlan}, ${widget.viewOnly}, ${provider?.trip?.placeName}");

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: !widget.showTripPlan && !widget.viewOnly
          ? CustomAppBar()
          : AppBar(
              leading: GestureDetector(
                onTap: () {
                  Routes.gotoBack(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
              backgroundColor: AppColors.blue,
              centerTitle: true,
              title: const Text(
                "Your Plan",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                ),
              ),
            ),
      body: Stack(
        children: [
          Container(
            margin: widget.viewOnly ? null : const EdgeInsets.only(bottom: 60),
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          //search autoconplete input
          widget.showTripPlan
              ? Container()
              : Positioned(
                  //search input bar
                  top: 10,
                  child: InkWell(
                    onTap: () async {
                      _searchPlacesAutocomplete();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            title: Text(
                              location,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          widget.showTripPlan
              ? Container()
              : Positioned(
                  top: 100,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(right: 15),
                    child: FloatingActionButton.small(
                      onPressed: initSelectPlace,
                      backgroundColor: AppColors.blue,
                      child: const Icon(
                        Icons.my_location,
                      ),
                    ),
                  ),
                ),
          widget.showTripPlan
              ? Container()
              : Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Routes.gotoYourTravelPlan(context, false, null);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 18,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColors.blue, width: 1),
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Routes.gotoBack(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 18,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColors.blue, width: 1),
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.blue,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

          widget.showTripPlan && !widget.viewOnly
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            provider?.trip?.userId = provider!.user!.data!.sId;
                            //provider?.tripHistory?.add(provider!.trip!);
                            //Routes.gotoDashboard(context);

                            GeolocationApi.getAddressFromLatLng(
                              provider!.currentLocation!,
                            ).then((value) {
                              print("getAddressFromLatLng----> ${value}");
                              provider?.trip?.placeName = value;

                              TripApi()
                                  .add(
                                trip: provider!.trip!,
                                user: provider!.user!,
                                context: context,
                              )
                                  .then((value) {
                                Routes.gotoDashboard(context);
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 18,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColors.blue, width: 1),
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text(
                                'Submit Plan',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
