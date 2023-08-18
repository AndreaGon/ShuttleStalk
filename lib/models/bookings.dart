class Bookings {
  String routeName;
  String pickupDropoff;
  String time;
  String date;
  String route;
  String studentId;
  String shuttleId;

  Bookings({
    required this.routeName,
    required this.pickupDropoff,
    required this.time,
    required this.date,
    required this.route,
    required this.studentId,
    required this.shuttleId,
  });

  factory Bookings.fromJson(Map<String, dynamic> parsedJson){
    return Bookings(
        routeName: parsedJson['routeName'].toString(),
        pickupDropoff: parsedJson['pickupDropoff'].toString(),
        time: parsedJson['time'].toString(),
        date: parsedJson['date'].toString(),
        route: parsedJson['route'].toString(),
        studentId: parsedJson['studentId'].toString(),
        shuttleId: parsedJson['shuttleId'].toString(),
    );
  }

  Map<dynamic, dynamic> toJson() => {
    'routeName': routeName,
    'pickupDropoff': pickupDropoff,
    'time': time,
    'date': date,
    'route': route,
    'studentId': studentId,
    'shuttleId': shuttleId,
  };
}
