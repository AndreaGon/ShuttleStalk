class Users {
  final String id;
  final String username;
  final String email;

  const Users({
    required this.id,
    required this.username,
    required this.email
  });

  factory Users.fromJson(Map<String, dynamic> parsedJson){
    return Users(
        id: parsedJson['id'].toString(),
        username: parsedJson['username'].toString(),
        email: parsedJson['email'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email
  };
}
