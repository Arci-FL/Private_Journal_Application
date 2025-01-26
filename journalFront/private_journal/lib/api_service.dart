import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:private_journal/data/entry_spec.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final storage = FlutterSecureStorage();
  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }

  //SIGN UPPPPPP
  final String signupUrl =
      "http://localhost:5012/api/signup/signUp"; // backend URL

  Future<Map<String, dynamic>> signUp(
      String username, String email, String password) async {
    final url = Uri.parse('$signupUrl/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return {'status': "Sign up successful"};
    } else if (response.statusCode == 409) {
      return {'status': 'User Already Exists'};
    } else {
      return {'status': 'Failed to Register'};
    }
  }

  //LOG INNNNNN
  final String loginUrl =
      "http://localhost:5012/api/login/login"; // backend URL

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    final url = Uri.parse('$loginUrl/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userId = data['UserId'];
      final token = data['Token']; // Assuming the response contains a token

      if (token != null) {
        await saveToken(token);
      } else {
        print("Token is null. Cannot save token.");
      }

      // Saving the token for future use
      await saveToken(token);
      // Saving UserId for future use
      saveUserId(userId);
      return {'status': 'Login successful', 'userId': userId, 'token': token};
    } else if (response.statusCode == 401) {
      return {'status': 'Invalid email or password'};
    } else {
      return {'status': 'Failed to login'};
    }
  }

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  //GEEEEET ENTRYYYYY
  final String getEntryUrl = "http://localhost:5012/api/entry"; // backend URL

  Future<List<Entry>> getSpecificEntry() async {
    final userId = await getUserId();

    final url = Uri.parse('$getEntryUrl/user/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return parseEntries(response.body);
    } else {
      throw Exception('Failed to load entries');
    }
  }

  //GET ENTRYYY TWO
  Future<Entry> getEntryById() async {
    final userId = await getUserId(); // Fetching the userId
    final response = await http.get(Uri.parse('$getEntryUrl/entry/$userId'));

    if (response.statusCode == 200) {
      // Parse the entry details from the response
      return Entry.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load entry');
    }
  }

  //POOOOOOST ENRTYYYYYYY
  final String createEntryUrl = "http://localhost:5012/api/entry/entry";
  Future<String> createEntry(String title, String content, String mood) async {
    final token = await getToken(); // Retrieve the token
    final url = Uri.parse(createEntryUrl);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'time_stamp': DateTime.now().toIso8601String(),
        'mood': mood,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final entryId = data['EntryId'];
      // Saving UserId for future use
      saveEntryId(entryId);
      return "Entry created successfully.";
    } else {
      return "Failed to create entry: ${response.body}";
    }
  }

  Future<void> saveEntryId(String entryId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('entryId', entryId);
  }

  Future<String?> getEntryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('entryId');
  }

  //UPDATE ENTRYYYYYYY
  final String updateEntryUrl = "http://localhost:5012/api/entry/";
  Future<String?> updateEntry(
      String? entryId, String title, String content, String mood) async {
    // final token = await getToken(); // Retrieve the token
    // if (token == null) {
    //   throw Exception('User is not authenticated');
    // }
    final url = Uri.parse(updateEntryUrl);
    final response = await http.put(
      url,
      headers: {
        //'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'title': title, 'mood': mood}),
    );

    if (response.statusCode == 200) {
      return "Entry updated successfully";
    } else {
      return "Failed to update entry";
    }
  }
}
