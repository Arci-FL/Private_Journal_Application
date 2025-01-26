import 'package:flutter/material.dart';
import 'package:private_journal/data/entry_spec.dart';
import 'package:private_journal/screens/createentryscreen.dart';
import 'package:private_journal/screens/editentryscreen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:private_journal/api_service.dart';
// import 'package:private_journal/screens/dashboardscreen.dart';

class Dashboardpage extends StatefulWidget {
  @override
  _DashoardState createState() => _DashoardState();
}

class _DashoardState extends State<Dashboardpage> {
  final apiService = ApiService();
  Future<List<Entry>>? futureEntries; // Nullable future
  String? userId;
  String? entryId;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    userId = await apiService.getUserId(); // Fetch userId
    if (userId != null) {
      setState(() {
        futureEntries = apiService.getSpecificEntry(); // Fetch entries
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 214, 185),
        title: const Text('Journal'),
      ),
      body: futureEntries == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loader while initializing
          : FutureBuilder<List<Entry>>(
              future: futureEntries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No entries found.'));
                } else {
                  final entries = snapshot.data!;
                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            entry.title,
                            style: const TextStyle(fontSize: 30),
                          ),
                          subtitle: Text(
                              'Mood: ${entry.mood}\nDate: ${entry.timeStamp.toLocal()}'),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditEntry(entryId: entryId),
                                  ),
                                );
                              } else if (value == 'delete') {
                                // Delete logic here
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 10),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 10),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEntryPage(userId: userId),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 0, 214, 185),
        foregroundColor: Colors.white,
      ),
    );
  }
}
