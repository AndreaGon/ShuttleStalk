class Announcements {
  final String title;
  final String content;
  final String timestamp;

  const Announcements({
    required this.title,
    required this.content,
    required this.timestamp
  });

  factory Announcements.fromJson(Map<String, dynamic> parsedJson){
    return Announcements(
      title: parsedJson['title'].toString(),
      content: parsedJson['content'].toString(),
      timestamp: parsedJson['timestamp'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'timestamp': timestamp
  };
}
