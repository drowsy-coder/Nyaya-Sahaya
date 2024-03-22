import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UTChat extends StatefulWidget {
  const UTChat({super.key});

  @override
  _UTChatState createState() => _UTChatState();
}

class _UTChatState extends State<UTChat> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? senderEmail;
  String? recvEmail;
  String? recvName;

  @override
  void initState() {
    super.initState();
    _fetchLawyerDetails();
  }

  Future<void> _fetchLawyerDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      senderEmail = currentUser.email;
      final casesQuery = await FirebaseFirestore.instance
          .collection('cases')
          .where('clientEmail', isEqualTo: currentUser.email)
          .get();

      if (casesQuery.docs.isNotEmpty) {
        final caseData = casesQuery.docs.first.data() as Map<String, dynamic>;
        setState(() {
          recvEmail = caseData['lawyerEmail'] as String?;
          recvName = caseData['lawyerName'] as String?;
        });
      } else {
        setState(() {
          recvEmail = null;
          recvName = null;
        });
      }
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty &&
        recvEmail != null &&
        senderEmail != null) {
      FirebaseFirestore.instance.collection('chats').add({
        'senderEmail': senderEmail,
        'receiverEmail': recvEmail,
        'receiverName': recvName,
        'message': messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(recvName != null ? 'Chat with $recvName' : 'Loading Chat...'),
        backgroundColor: Colors.black,
      ),
      body: recvEmail == null
          ? const Center(child: Text('No lawyer assigned yet.'))
          : Container(
              color: Colors.grey[900],
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .where('senderEmail', isEqualTo: senderEmail)
                          .where('receiverEmail', isEqualTo: recvEmail)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No messages yet.'));
                        }
                        final messages = snapshot.data!.docs;
                        return ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final messageData = messages[index];
                            final messageText = messageData['message'];
                            final messageSender = messageData['senderEmail'];
                            final isMe = senderEmail == messageSender;
                            return MessageWidget(
                              text: messageText,
                              isMe: isMe,
                              recvName: recvName!,
                            );
                          },
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

  const MessageWidget({super.key, 
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
          Material(
            color: isMe ? Colors.blue[700] : Colors.grey[700],
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
