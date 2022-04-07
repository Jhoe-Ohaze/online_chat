import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/Backend/user_auth.dart';
import 'package:online_chat/Widgets/Composer/image_loading.dart';
import 'package:online_chat/Backend/database.dart';

class MessageTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  const MessageTile(this.doc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isYours = UserAuth.currentUser!.uid == doc['sender_id'];
    double maxSize = MediaQuery.of(context).size.width * 0.6;
    Color bgColor = isYours
        ? Database.colorScheme.primary.withOpacity(0.8)
        : Database.colorScheme.onPrimary;
    Color txtColor = isYours
        ? Database.colorScheme.surface
        : Database.colorScheme.inverseSurface;

    return Row(
      mainAxisAlignment:
          isYours ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !isYours
            ? CircleAvatar(
                backgroundImage: NetworkImage(doc['sender_photo_url']),
              )
            : const SizedBox(),
        const SizedBox(width: 5),
        Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(5),
            constraints: BoxConstraints(
              maxWidth: maxSize,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !isYours
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          doc['sender_name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Database.colorScheme.primary,
                          ),
                        ),
                      )
                    : const SizedBox(),
                doc.data().containsKey('image')
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          doc['image'],
                          height: maxSize - 10,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                              ImageLoading(context, child, progress),
                        ),
                      )
                    : const SizedBox(),
                doc.data().containsKey('text')
                    ? Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          doc['text'],
                          style: TextStyle(color: txtColor),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        isYours
            ? CircleAvatar(
                backgroundImage: NetworkImage(doc['sender_photo_url']),
              )
            : const SizedBox(),
      ],
    );
  }
}
