import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'message_tile.dart';

class MessageList extends StatelessWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Stack(
              alignment: Alignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
              ],
            );
          default:
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docList =
                snapshot.data!.docs;
            return Scrollbar(
              radius: const Radius.circular(10),
              thickness: 8,
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: docList.length,
                dragStartBehavior: DragStartBehavior.down,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5);
                },
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot<Map<String, dynamic>> doc =
                      docList.elementAt(index);
                  return MessageTile(doc);
                },
              ),
            );
        }
      },
    );
  }
}
