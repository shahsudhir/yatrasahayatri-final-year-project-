import 'package:yatrasahayatri/models/LoLatLong.dart';
import 'package:yatrasahayatri/models/TripPlanType.dart';

// class TripModel{
//   String? userId;
//   TripPlanType? type;
//   LoLatLong? latLong;
//   String? placeName;
//   List<DayContent>? daysContent;
//   List<Content>? content = [];
//
//   List<DayContent> setDaysContent(int days) {
//     List<DayContent> data = [];
//     for (int i = 1; i <= days; i++) {
//       data.add(DayContent("${i}", 0));
//     }
//     return data;
//   }
// }
//
// class DayContent {
//   String? days;
//   int? maxHours;
//
//   DayContent(this.days, this.maxHours);
// }
//
// class Content{
//   String? placeId;
//   LoLatLong? latLong;
//   String? name;
//   String? image;
//   double? rating;
//   int? hours;
//   int? whichDay;
// }

class TripModel {
  String? id;
  String? userId;
  TripPlanType? type;
  LoLatLong? latLong;
  String? placeName;
  List<DayContent>? daysContent;
  List<Content>? content = [];

  TripModel({
    this.id,
    this.userId,
    this.type,
    this.latLong,
    this.placeName,
    this.daysContent,
    this.content,
  });

  List<DayContent> setDaysContent(int days) {
    List<DayContent> data = [];
    for (int i = 1; i <= days; i++) {
      data.add(DayContent("${i}", 0));
    }
    return data;
  }

  List<DayContent> setDayContent(int maxHours) {
    List<DayContent> data = [];
    data.add(DayContent("0", maxHours));
    return data;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? dayContentList =
        daysContent?.map((dayContent) => dayContent.toJson()).toList();

    List<Map<String, dynamic>> contentList =
        content!.map((content) => content.toJson()).toList();

    return {
      'userId': userId,
      'type': type!.name,
      'latLong': latLong?.toJson(),
      'placeName': placeName,
      'daysContent': dayContentList,
      'content': contentList,
    };
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? dayContentJson = json['daysContent'] ?? null;
    List<DayContent>? dayContentList = dayContentJson
        ?.map((dayContent) => DayContent.fromJson(dayContent))
        .toList();

    List<dynamic> contentJson = json['content'];
    List<Content> contentList =
        contentJson.map((content) => Content.fromJson(content)).toList();
    TripPlanType type = TripPlanType.values
        .where((element) => element.name == json['type'])
        .first;
    return TripModel(
      id: json['_id'],
      userId: json['userId'],
      type: json['type'] != null ? type : null,
      latLong:
          json['latLong'] != null ? LoLatLong.fromJson(json['latLong']) : null,
      placeName: json['placeName'],
      daysContent: dayContentList,
      content: contentList,
    );
  }
}

class DayContent {
  String? days;
  int? maxHours;

  DayContent(this.days, this.maxHours);

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'maxHours': maxHours,
    };
  }

  factory DayContent.fromJson(Map<String, dynamic> json) {
    return DayContent(
      json['days'],
      json['maxHours'],
    );
  }
}

class Content {
  String? placeId;
  LoLatLong? latLong;
  String? name;
  String? image;
  double? rating;
  int? hours;
  int? whichDay;

  Content({
    this.placeId,
    this.latLong,
    this.name,
    this.image,
    this.rating,
    this.hours,
    this.whichDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'latLong': latLong?.toJson(),
      'name': name,
      'image': image,
      'rating': rating,
      'hours': hours,
      'whichDay': whichDay,
    };
  }

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      placeId: json['placeId'],
      latLong:
          json['latLong'] != null ? LoLatLong.fromJson(json['latLong']) : null,
      name: json['name'],
      image: json['image'],
      rating: double.tryParse("${json['rating']}"),
      hours: json['hours'],
      whichDay: json['whichDay'],
    );
  }
}
