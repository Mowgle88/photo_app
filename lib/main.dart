import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'widgets/image_input.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geocoding;

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
  final Location location = Location();
  File? _selectedImage;
  LocationData? _locationData;
  var _isSending = false;
  String address = '';

  Future<void> uploadImage(context) async {
    setState(() {
      _isSending = true;
    });

    final enteredComment = _commentController.text;
    _locationData = await location.getLocation();
    final latitude = _locationData!.latitude;
    final longitude = _locationData!.longitude;

    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(latitude!, longitude!);

    address =
        '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.postalCode}, ${placemarks.first.country}';

    final stream = http.ByteStream(_selectedImage!.openRead());
    stream.cast();

    var length = await _selectedImage!.length();

    var uri = Uri.parse('https://fakestoreapi.com/products');

    var reguest = http.MultipartRequest('POST', uri);
    reguest.headers.addAll({'Content-Type': 'application/json'});

    reguest.fields['title'] = enteredComment;
    reguest.fields['description'] =
        'latitude: $latitude, longitude: $longitude';

    var multiport = http.MultipartFile('image', stream, length);

    reguest.files.add(multiport);

    var response = await reguest.send();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(response.statusCode == 200 ? 'Image uploaded' : 'Failed'),
      ),
    );

    setState(() {
      _isSending = false;
    });
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
            Stack(
              children: [
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: address != ''
                        ? const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          )
                        : null,
                    child: Text(
                      address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                )
              ],
            ),
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
        label: _isSending
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Text('Send Image'),
        icon: const Icon(Icons.image_outlined),
        onPressed: () {
          uploadImage(context);
        },
        tooltip: 'Increment',
      ),
    );
  }
}
