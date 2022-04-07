import 'package:flutter/material.dart';

class ImageLoading extends StatelessWidget {
  final BuildContext context;
  final Widget child;
  final ImageChunkEvent? progress;
  const ImageLoading(this.context, this.child, this.progress, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (progress == null) {
      return child;
    } else {
      int downloadedBytes = progress!.cumulativeBytesLoaded;
      int? expectedBytes = progress!.expectedTotalBytes;
      return Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value:
                expectedBytes != null ? downloadedBytes / expectedBytes : null,
          ),
        ],
      );
    }
  }
}
