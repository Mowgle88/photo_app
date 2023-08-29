import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
    );

    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
