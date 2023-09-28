import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LawyerClientChat extends StatefulWidget {
  final String recvEmail;
  final String recvName;
  final String senderEmail;

  const LawyerClientChat({
    super.key,
    required this.recvEmail,
    required this.recvName,
    required this.senderEmail,
  });

  @override
  _LawyerClientChatState createState() => _LawyerClientChatState();
}

class _LawyerClientChatState extends State<LawyerClientChat> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _chatCollection;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatCollection = _firestore.collection('chats');
  }

  void sendMessage() {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      _chatCollection.add({
        'senderEmail': widget.senderEmail,
        'receiverEmail': widget.recvEmail,
        'receiverName': widget.recvName,
        'message': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recvName}'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatCollection.orderBy('timestamp').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final messages = snapshot.data!.docs.where((element) {
                    return (element['receiverEmail'] == widget.recvEmail ||
                        element['senderEmail'] == widget.recvEmail);
                  }).toList();
                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message['message'];

                    final messageWidget = MessageWidget(
                      text: messageText,
                      isMe: widget.senderEmail == message['senderEmail'],
                      recvName: widget.recvName,
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    controller: _scrollController,
                    children: messageWidgets,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter your message...',
                          hintStyle: TextStyle(color: Colors.white70),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: 3,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: sendMessage,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isMe;
  final String recvName;

  const MessageWidget({
    super.key,
    required this.text,
    required this.isMe,
    required this.recvName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? 'Me' : recvName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: isMe ? Colors.blue : Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Hero(
            tag: 'chat_bubble_${text.hashCode}',
            child: Material(
              color: isMe ? Colors.blue[700] : Colors.grey[700],
              borderRadius: BorderRadius.circular(16),
              elevation: 2,
              child: InkWell(
                onTap: () {},
                child: FractionallySizedBox(
                  widthFactor:
                      0.6, // Adjust this value for the desired width (40-45%)
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMe) const Icon(Icons.person, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 16,
                              color: isMe ? Colors.white : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true, // Allow text to wrap to a new line
                          ),
                        ),
                        if (isMe)
                          const Icon(Icons.check,
                              color: Colors.green, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
