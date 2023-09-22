import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LawyerClientChat extends StatefulWidget {
  final String recvEmail;
  final String recvName;
  final String senderEmail;

  LawyerClientChat({
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
  final ScrollController _scrollController = ScrollController(); // Add this

  @override
  void initState() {
    super.initState();
    // Define the Firestore collection for this chat
    _chatCollection = _firestore.collection('chats');
  }

  void sendMessage() {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      // Send the message to Firestore
      _chatCollection.add({
        'senderEmail': widget.senderEmail, // Sender's email
        'receiverEmail': widget.recvEmail, // Receiver's email
        'receiverName': widget.recvName, // Receiver's name
        'message': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();

      // Scroll to the bottom of the list when a new message arrives
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recvName}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                // Only keep the messages where receieverEmail is equal to widget.recvEmail

                if (!snapshot.hasData) {
                  return Center(
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
                  controller:
                      _scrollController, // Attach the ScrollController here
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isMe;
  final String recvName;

  MessageWidget({
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
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
