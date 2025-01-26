import 'package:flutter/material.dart';
import 'package:private_journal/api_service.dart';

enum MoodLabel {
  okay('Okay', Icons.sentiment_satisfied_outlined),
  notOkay('Not Okay', Icons.sentiment_dissatisfied),
  excited('Super Happy', Icons.sentiment_very_satisfied),
  depressed('Depressed', Icons.sentiment_very_dissatisfied);

  const MoodLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class CreateEntryPage extends StatefulWidget {
  final String? userId;

  CreateEntryPage({required this.userId});

  @override
  _CreateEntryPageState createState() => _CreateEntryPageState();
}

class _CreateEntryPageState extends State<CreateEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final apiService = ApiService();
  String? userId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  String message = "";
  MoodLabel? selectedMood;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<String?> _getUserId() async {
    userId = await apiService.getUserId(); // Fetch userId
    return userId;
  }

  void submitEntry() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final mood = _moodController.text.trim();
      final content = _contentController.text.trim();

      try {
        final result = await apiService.createEntry(title, content, mood);
        setState(() {
          message = result;
        });
      } catch (error) {
        setState(() {
          message = "Failed to create entry: $error";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Entry'),
      ),
      body: Container(
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
