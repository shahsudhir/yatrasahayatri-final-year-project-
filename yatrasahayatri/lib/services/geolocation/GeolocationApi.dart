import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:yatrasahayatri/models/LoLatLong.dart';
import 'package:yatrasahayatri/models/NearByPlacesModal.dart';

class GeolocationApi {
  static const String MAP_KEY = "AIzaSyB5sMJk3MqZEyZ_22zw0J209qiYbvcpXvs";

  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<void> searchPlacesAutocomplete(
    BuildContext context,
    Function(String) locationName,
    Function(LatLng newlatlang) location,
  ) async {
    var place = await PlacesAutocomplete.show(
        context: context,
        apiKey: GeolocationApi.MAP_KEY,
        mode: Mode.overlay,
        types: [],
        strictbounds: false,
        components: [Component(Component.country, 'np')],
        //google_map_webservice package
        onError: (err) {
          print(err);
        });

    if (place != null) {
      locationName(place.description.toString());

      //form google_maps_webservice package
      final plist = GoogleMapsPlaces(
        apiKey: GeolocationApi.MAP_KEY,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      String placeid = place.placeId ?? "0";
      final detail = await plist.getDetailsByPlaceId(placeid);
      final geometry = detail.result.geometry!;
      final lat = geometry.location.lat;
      final lang = geometry.location.lng;
      var newlatlang = LatLng(lat, lang);
      location(newlatlang);
    }
  }

  static Future<String> getAddressFromLatLng(LatLng latLng) async {
    //https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=true&key=AIzaSyDKQ3DJPJPF6ew8cu_K3krHV9EMNe4uLY4&fbclid=IwAR3tNc2-ksSBnfW5-3AXEzJIu_8eIMkv_DPvZDTx4UMaGYU1tT061cYDd2c
    const apiKey =
        "AIzaSyDKQ3DJPJPF6ew8cu_K3krHV9EMNe4uLY4&fbclid=IwAR3tNc2-ksSBnfW5-3AXEzJIu_8eIMkv_DPvZDTx4UMaGYU1tT061cYDd2c";
    final apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['results'][0]['formatted_address'];
    } else {
      //throw Exception('Failed to load address');
      return "";
    }
  }

  static Future<List<NearByPlacesModal>> getPlacesInfo({
    required LatLng latLng,
    int radius = 10 * 1000, //10 KM
    required String type,
  }) async {
    // https://maps.googleapis.com/maps/api/place/nearbysearch/json
    // ?geolocation=27.7251337%2C85.2928041
    // &radius=10
    // &type=bank
    // &key=AIzaSyDKQ3DJPJPF6ew8cu_K3krHV9EMNe4uLY4&fbclid=IwAR3tNc2-ksSBnfW5-3AXEzJIu_8eIMkv_DPvZDTx4UMaGYU1tT061cYDd2c
    String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    url += "?location=${latLng.latitude}%2C${latLng.longitude}";
    url += "&radius=${radius}";
    url += "&type=${type}";
    url += "&key=AIzaSyDKQ3DJPJPF6ew8cu_K3krHV9EMNe4uLY4";
    //&fbclid=IwAR3tNc2-ksSBnfW5-3AXEzJIu_8eIMkv_DPvZDTx4UMaGYU1tT061cYDd2c

    var uri = Uri.parse(url);

    //print("Url------> ${url}");
    var response = await http.get(uri);
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    //parse model
    List<NearByPlacesModal> modals = [];
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        var results = body["results"];
        results?.forEach((result) {
          Map<String, dynamic> geometry = result["geometry"];
          Map<String, dynamic> location = geometry["location"];
          String icon = result["icon"];
          String name = result["name"];
          String place_id = result["place_id"];
          double rating = 0;
          if (result.containsKey("rating")) {
            String v = "${result["rating"]}";
            rating = double.parse(v);
          }
          LoLatLong latLong = LoLatLong(
            lat: location["lat"],
            long: location["lng"],
          );

          modals.add(NearByPlacesModal(
            location: latLong,
            icon: icon,
            name: name,
            place_id: place_id,
            rating: rating,
          ));
        });
      }
    } catch (e) {
      print("getPlacesInfo------> ${e}");
      modals = [];
    }
    return modals.toList();
  }
}
