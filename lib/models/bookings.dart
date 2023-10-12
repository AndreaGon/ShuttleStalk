class Bookings {
  String routeName;
  String pickupDropoff;
  String time;
  String date;
  String route;
  String studentId;
  String routeId;
  String studentName;
  String studentMatriculation;

  Bookings({
    required this.routeName,
    required this.pickupDropoff,
    required this.time,
    required this.date,
    required this.route,
    required this.studentId,
    required this.routeId,
    required this.studentName,
    required this.studentMatriculation
  });

  factory Bookings.fromJson(Map<String, dynamic> parsedJson){
    return Bookings(
        routeName: parsedJson['routeName'].toString(),
        pickupDropoff: parsedJson['pickupDropoff'].toString(),
        time: parsedJson['time'].toString(),
        date: parsedJson['date'].toString(),
        route: parsedJson['route'].toString(),
        studentId: parsedJson['studentId'].toString(),
        routeId: parsedJson['routeId'].toString(),
        studentName: parsedJson['studentName'].toString(),
        studentMatriculation: parsedJson['studentMatriculation'].toString()
    );
  }

  Map<dynamic, dynamic> toJson() => {
    'routeName': routeName,
    'pickupDropoff': pickupDropoff,
    'time': time,
    'date': date,
    'route': route,
    'studentId': studentId,
    'routeId': routeId,
    'studentName': studentName,
    'studentMatriculation': studentMatriculation
  };
}
