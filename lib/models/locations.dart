class Locations {
  String routeId;
  String date;
  String time;
  String shuttleLocation;
  String shuttlePlateNo;
  bool isJourneyStarted;

  Locations({
    required this.routeId,
    required this.time,
    required this.date,
    required this.shuttleLocation,
    required this.shuttlePlateNo,
    required this.isJourneyStarted
  });

  factory Locations.fromJson(Map<String, dynamic> parsedJson){
    return Locations(
      routeId: parsedJson['routeId'].toString(),
      time: parsedJson['time'].toString(),
      date: parsedJson['date'].toString(),
      shuttleLocation: parsedJson['shuttleLocation'].toString(),
      shuttlePlateNo: parsedJson['shuttlePlateNo'].toString(),
      isJourneyStarted: parsedJson['isJourneyStarted']
    );
  }

  Map<dynamic, dynamic> toJson() => {
    'routeId': routeId,
    'time': time,
    'date': date,
    'shuttleLocation': shuttleLocation,
    'shuttlePlateNo': shuttlePlateNo,
    'isJourneyStarted': isJourneyStarted
  };
}
