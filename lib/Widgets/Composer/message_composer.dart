import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_chat/Backend/database.dart';
import 'package:online_chat/Backend/database_functions.dart';
import 'package:online_chat/Widgets/Composer/display_selected_image.dart';

class MessageComposer extends StatelessWidget {
  const MessageComposer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagePicker = ImagePicker();
    final messageController = TextEditingController();

    final image = ValueNotifier<Uint8List?>(null);

    final canSend = ValueNotifier<bool>(false);
    final isSending = ValueNotifier<bool>(false);

    void pickImage() async {
      image.value = await imagePicker
          .pickImage(source: ImageSource.gallery)
          .then((value) => value!.readAsBytes());
      canSend.value = image.value != null || messageController.text.isNotEmpty;
    }

    //Clears all the fields and submits the message
    void submit() async {
      final String text = messageController.text;
      final Uint8List? imageData = image.value;

      messageController.clear();
      image.value = null;
      canSend.value = false;
      isSending.value = true;
      await DatabaseFunctions.sendMessage(text: text, image: imageData);
      isSending.value = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<Uint8List?>(
          valueListenable: image,
          builder: (context, value, child) {
            return value != null
                ? DisplaySelectedImage(image)
                : const SizedBox();
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isSending,
          builder: (context, value, child) {
            return value ? const LinearProgressIndicator() : const SizedBox();
          },
        ),
        Row(
          children: <Widget>[
            IconButton(
              onPressed: pickImage,
              iconSize: 30,
              icon: Icon(
                Icons.photo,
                color: Database.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escreva uma mensagem',
                ),
                controller: messageController,
                onChanged: (text) {
                  canSend.value =
                      image.value != null || messageController.text.isNotEmpty;
                },
              ),
            ),
            const SizedBox(width: 5),
            ValueListenableBuilder<bool>(
              valueListenable: canSend,
              builder: (context, value, child) {
                return IconButton(
                  onPressed: value ? submit : null,
                  color: Database.colorScheme.primary,
                  icon: const Icon(
                    Icons.send,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
