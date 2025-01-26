import 'dart:convert';

class Entry {
  final String title;
  final String content;
  final DateTime timeStamp;
  final String mood;

  Entry(
      {required this.title,
      required this.content,
      required this.timeStamp,
      required this.mood});

  // Factory method to create an Entry object from JSON
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      title: json['title'],
      content: json['content'],
      timeStamp: DateTime.parse(json['time_stamp']),
      mood: json['mood'],
    );
  }
}

List<Entry> parseEntries(String responseBody) {
  // Decode the JSON string into a List of dynamic objects
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  // Map the list of dynamic objects to a list of Entry objects
  return parsed.map<Entry>((json) => Entry.fromJson(json)).toList();
}
