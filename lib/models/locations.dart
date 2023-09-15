class Locations {
  String routeName;
  String routeId;
  String date;
  String time;
  String shuttleLocation;
  String shuttlePlateNo;
  String driverId;
  bool isJourneyStarted;
  String pickupDropoff;

  Locations({
    required this.routeName,
    required this.routeId,
    required this.time,
    required this.date,
    required this.shuttleLocation,
    required this.shuttlePlateNo,
    required this.driverId,
    required this.isJourneyStarted,
    required this.pickupDropoff
  });

  factory Locations.fromJson(Map<String, dynamic> parsedJson){
    return Locations(
      routeName: parsedJson['routeName'].toString(),
      routeId: parsedJson['routeId'].toString(),
      time: parsedJson['time'].toString(),
      date: parsedJson['date'].toString(),
      shuttleLocation: parsedJson['shuttleLocation'].toString(),
      shuttlePlateNo: parsedJson['shuttlePlateNo'].toString(),
      driverId: parsedJson['driverId'].toString(),
      isJourneyStarted: parsedJson['isJourneyStarted'],
      pickupDropoff: parsedJson['pickupDropoff'].toString()
    );
  }

  Map<dynamic, dynamic> toJson() => {
    'routeName': routeName,
    'routeId': routeId,
    'time': time,
    'date': date,
    'shuttleLocation': shuttleLocation,
    'shuttlePlateNo': shuttlePlateNo,
    'isJourneyStarted': isJourneyStarted,
    'pickupDropoff': pickupDropoff
  };
}
