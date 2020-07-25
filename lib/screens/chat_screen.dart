import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/chat/messages.dart';
import 'package:flutter_chat/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  final String userId;

  ChatScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          Row(
            children: [
              Container(
                color: Theme.of(context).accentColor,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: FutureBuilder<DocumentSnapshot>(
                  future: Firestore.instance
                      .collection('users')
                      .document(userId)
                      .get(),
                  builder: (ctx, userSnapshot) {
                    if (!userSnapshot.hasData ||
                        userSnapshot.data.data == null ||
                        userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    return Text(
                      userSnapshot.data['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: AppBar().preferredSize.height,
                color: Colors.grey[300],
                child: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ),
            ],
          ),
          /* PopupMenuButton(
            onSelected: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),*/
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
