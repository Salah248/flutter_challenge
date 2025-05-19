import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'Send a message...'),
              keyboardType: TextInputType.emailAddress,
              controller: _messageController,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  _sendMessage() async {
    final message = _messageController.text;
    if (message.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();
    final user = FirebaseAuth.instance.currentUser!;

    final userData =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    // Send message to firebase firestore
    await FirebaseFirestore.instance.collection('chats').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
