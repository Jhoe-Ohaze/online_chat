import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_chat/Backend/user_auth.dart';

class DatabaseFunctions {
  static Future<void> sendMessage({String? text, Uint8List? image}) async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> data = {
      'sender_id': UserAuth.currentUser!.uid,
      'sender_photo_url': UserAuth.currentUser!.photoURL,
      'sender_name': UserAuth.currentUser!.displayName,
    };

    if (text != null) {
      data['text'] = text;
    }
    if (image != null) {
      TaskSnapshot task = await FirebaseStorage.instance
          .ref('${DateTime.now().millisecondsSinceEpoch}.jpg')
          .putData(
            image,
            SettableMetadata(contentType: 'image/jpeg'),
          );
      String url = await task.ref.getDownloadURL();
      data['image'] = url;
    }
    if (data.isNotEmpty) {
      data['time'] = DateTime.now().toString();
      await FirebaseFirestore.instance.collection('messages').add(data);
    }
  }
}
