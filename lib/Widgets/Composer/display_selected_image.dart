import 'dart:typed_data';
import 'package:flutter/material.dart';

class DisplaySelectedImage extends StatelessWidget {
  final ValueNotifier<Uint8List?> image;
  const DisplaySelectedImage(this.image, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.memory(
                    image.value!,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
          ),
          const Padding(
            padding: EdgeInsets.all(2),
            child: Icon(
              Icons.circle,
              color: Colors.white,
              size: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                  size: 20,
                ),
                onTap: () {
                  image.value = null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
