import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:typed_data';

void main() {
  runApp(ChatBot());
}

class ChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  Map<String, String> _responses = {};

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  void _loadResponses() async {
    final ByteData data = await rootBundle.load('assets/responses.xlsx');
    final Uint8List bytes = data.buffer.asUint8List();
    final excel = Excel.decodeBytes(bytes);
    final table = excel.tables['Sheet1']; // Adjust sheet name accordingly

    for (var row in table?.rows ?? const []) {
      final userInput = row[0]?.value;
      final response = row[1]?.value;

      if (userInput != null && response != null) {
        final userInputString = userInput is SharedString
            ? excel.tables[table?.sheetName]?.maxCols ==
                    1 // Check if it's a single value
                ? excel.tables[table?.sheetName]?.rows[row[0]?.rowIndex]?.first
                : userInput.toString()
            : userInput.toString();

        if (userInput != null && response != null) {
          final userInputString = userInput is SharedString
              ? excel.tables[table?.sheetName]?.maxCols == 1
                  ? excel
                      .tables[table?.sheetName]?.rows[row[0]?.rowIndex]?.first
                      ?.toString()
                  : userInput.toString()
              : userInput.toString();

          _responses[userInputString!] = response.toString();
        }
      }
    }
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );
    });

    final response = _responses[text.toLowerCase()] ?? "I don't understand.";
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: response,
          isUser: false,
        ),
      );
    });

    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          isUser
              ? Container()
              : CircleAvatar(
                  child: Text('Bot'),
                ),
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue[100] : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.black : Colors.white,
              ),
            ),
          ),
          !isUser
              ? Container()
              : CircleAvatar(
                  child: Text('User'),
                ),
        ],
      ),
    );
  }
}
