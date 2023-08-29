import 'package:flutter/material.dart';
import 'components/image_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Send Picture'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _commentController = TextEditingController();

  void _sendImage() {
    final enteredComment = _commentController.text;
    print(enteredComment);
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ImageInput(),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Comment',
              ),
              controller: _commentController,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Send Image'),
        icon: const Icon(Icons.image_outlined),
        onPressed: _sendImage,
        tooltip: 'Increment',
      ),
    );
  }
}
