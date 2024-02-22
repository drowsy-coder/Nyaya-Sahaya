// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final messageInsert = TextEditingController();
  List<Map<String, dynamic>> messsages = [];

  void response(query) async {
    final apiKey = "AIzaSyDfRqoM3eCvhjpxtOfZE_BzuD3eGVojXPU";
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final prompt = TextPart(query);
    final response = await model.generateContent([Content.text(prompt.text)]);
    setState(() {
      messsages.insert(0, {"data": 0, "message": response.text});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        elevation: 10,
        title: const Text("Gemini-Powered Chatbot"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                reverse: true,
                itemCount: messsages.length,
                itemBuilder: (context, index) => chat(
                    messsages[index]["message"].toString(),
                    messsages[index]["data"])),
          ),
          const Divider(
            height: 6.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                  controller: messageInsert,
                  decoration: const InputDecoration.collapsed(
                      hintText: "Send your message",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                )),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 30.0,
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                        }))
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          )
        ],
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Bubble(
        radius: const Radius.circular(15.0),
        color: data == 0 ? Colors.blue : Colors.orangeAccent,
        elevation: 0.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(data == 0
                    ? "assets/images/bot.png"
                    : "assets/images/profile.png"),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: data == 0 ? Colors.blue : Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: MarkdownBody(
                    selectable: true,
                    data: message,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
