import 'package:yatrasahayatri/models/LoLatLong.dart';

class NearByPlacesModal {
  LoLatLong? location;
  String? icon;
  String? name;
  String? place_id;
  double? rating;

  NearByPlacesModal({
    this.location,
    this.icon,
    this.name,
    this.place_id,
    this.rating,
  });
}

enum NearByPlacesType {
  cafe("Cafe"),
  restaurant("Restaurant"),
  park("Park"),
  tourist_attraction("Tourist");

  final String value;

  const NearByPlacesType(this.value);
}
