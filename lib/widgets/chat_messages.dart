import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    // first i used StreamBuilder to listen to the changes in the chat messages
    // Because the StreamBulder is a Live widget that listens to the changes in the data in same time
    return StreamBuilder(
      // in stream i passed the stream of the chat messages from the firestore collection
      // and the orderBy method is used to sort the messages by their createdAt field in descending order
      stream:
          FirebaseFirestore.instance
              .collection('chats')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages yet!'));
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong!'));
        }
        // get the data from the snapshot and pass it to the MessageBubble widget
        final messages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(left: 13, right: 13, bottom: 40),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            // chatMessage is the current message from the snapshot
            // i will use it to get the user data and the message text
            final chatMessage = messages[index].data();
            // nextMessage is the next message in the list from anthoher user
            // this condation is used to check if the next message is from the same user or not
            // if the next message is from the same user, then we will show the next message bubble
            // else we will show the first message bubble
            // index + 1 means that we are checking the next message in the list
            final nextMessage =
                index + 1 < messages.length ? messages[index + 1].data() : null;
            // currentMessageUserId is the user id of the current message
            // i will use it to check if the current message is from the same user or not
            final currentMessageUserId = chatMessage['userId'];
            // nextMessageUserId is the user id of the next message
            // nextUserIsSame is a boolean value that checks if the next message is from the same user or not
            final nextMessageUserId =
                nextMessage != null ? nextMessage['userId'] : null;
            // nextUserIsSame is a boolean value that checks if the next message is from the same user or not
            // i will use it to show the next message bubble or the first message bubble
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: currentMessageUserId == user.uid,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['_'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: currentMessageUserId == user.uid,
              );
            }
          },
        );
      },
    );
  }
}
