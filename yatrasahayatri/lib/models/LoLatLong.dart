class LoLatLong {
  final double? lat;
  final double? long;


  LoLatLong({this.long, this.lat});

  Map<String, dynamic> toJson() {
    return {
      'long': long,
      'lat': lat,
    };
  }

  factory LoLatLong.fromJson(Map<String, dynamic> json) {
    return LoLatLong(
      long: json['long'],
      lat: json['lat'],
    );
  }
}
