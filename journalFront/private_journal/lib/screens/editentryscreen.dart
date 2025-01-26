import 'package:flutter/material.dart';
import 'package:private_journal/api_service.dart';
// import 'package:private_journal/main.dart';
// import 'package:private_journal/api_service.dart';

enum MoodLabel {
  okay('Okay', Icons.sentiment_satisfied_outlined),
  notOkay('Not Okay', Icons.sentiment_dissatisfied),
  excited('Super Happy', Icons.sentiment_very_satisfied),
  depressed('Depressed', Icons.sentiment_very_dissatisfied);

  const MoodLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class EditEntry extends StatefulWidget {
  final String? entryId;

  EditEntry({required this.entryId});

  @override
  EditEntryState createState() => EditEntryState();
}

class EditEntryState extends State<EditEntry> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  String message = "";
  MoodLabel? selectedMood;

  void initState() {
    super.initState();
    _getEntryDetails(); // Load entry data when the page is first created
  }

  Future<void> _getEntryDetails() async {
    try {
      // Fetch entry by ID and userId
      final entry = await ApiService().getEntryById();
      _titleController.text = entry.title;
      _contentController.text = entry.content;
      _moodController.text = entry.mood;
    } catch (e) {
      print("Error: $e");
    }
  }

  void submitEntry() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final mood = _moodController.text.trim();
      final content = _contentController.text.trim();

      final result =
          await ApiService().updateEntry(widget.entryId, title, content, mood);
      setState(() {
        message = result!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Entry'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 34, 34, 34), // Dark gray
              Color.fromARGB(255, 0, 214, 185), // Teal
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 10,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 25,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<MoodLabel>(
                  value: selectedMood,
                  decoration: const InputDecoration(labelText: 'Mood'),
                  items: MoodLabel.values.map((MoodLabel mood) {
                    return DropdownMenuItem<MoodLabel>(
                      value: mood,
                      child: Row(
                        children: [
                          Icon(mood.icon, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(mood.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (MoodLabel? mood) {
                    setState(() {
                      selectedMood = mood;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a mood';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitEntry,
                  child: const Text('Submit Entry'),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: TextStyle(
                      color: message.contains("successfully")
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
