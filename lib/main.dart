import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.purple[100],
    ),
  );
  static final ThemeData darkTheme = ThemeData.dark();
}

class GeminiAPI {
  static const String apiKey = 'AIzaSyAg8Nm8cUFv91EBijplMLpQ1rlpyVyre7M'; // Replace with your actual API key
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> fetchResponse(String userPrompt) async {
    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": '$userPrompt Predict possible issues without recommending medicine'}
            ]
          }
        ]
      }),
    );
     print('Response: ${response.body}');
    // print('Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response';
    } else {
      throw Exception('Failed to fetch response: ${response.statusCode}');
    }
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
    });

    _controller.clear();

    try {
      final botResponse = await GeminiAPI.fetchResponse(message);
      setState(() {
        _messages.add({'role': 'bot', 'content': botResponse});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': 'Error: Unable to fetch response.'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to the start
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Slightly rounded corners for a professional look
              child: Image.asset(
                '/logo.jpeg',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15), // Increased spacing for better visual balance
            const Text(
              'AI Doctor',
              style: TextStyle(
              fontSize: 24, // Larger font size for prominence
              fontWeight: FontWeight.bold, // Bold text for emphasis
              fontFamily: 'Roboto', // Use a modern and beautiful font
              letterSpacing: 1.2, // Slight letter spacing for elegance
              color: Color.fromARGB(255, 246, 246, 247), // A visually appealing color
              ),
            ),
          ],
        ),
        centerTitle: false, // Align title to the start for a professional layout
        backgroundColor: Color.fromARGB(255, 53, 10, 123), // Neutral background color
        elevation: 2, // Subtle shadow for a modern look
        iconTheme: IconThemeData(color: Colors.white), // Black icons for contrast
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 253, 252, 252), // Black text for readability
          fontWeight: FontWeight.bold,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'Settings') {
                // Navigate to settings page
              } else if (value == 'Help') {
                // Navigate to help page
              } else if (value == 'Profile') {
                // Navigate to profile page
              } else if (value == 'Logout') {
                // Handle logout
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem(
                  value: 'Help',
                  child: Text('Help'),
                ),
                const PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MarkdownBody(
                      data: message['content']!, // Render markdown content
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your symptoms...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
