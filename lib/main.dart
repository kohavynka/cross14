import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NativeCameraApp(),

    );
  }
}

class NativeCameraApp extends StatefulWidget {
  @override
  _NativeCameraAppState createState() => _NativeCameraAppState();
}

class _NativeCameraAppState extends State<NativeCameraApp> {
  static const platform = MethodChannel('com.example.lab14/message');
  String nativeMessage = " ";
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();


  Future<void> _showNativeMessageAlert() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Native data"),
          content: Text(nativeMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }


  Future<void> _getNativeMessage() async {
    try {
      final String result = await platform.invokeMethod('getNativeMessage');
      setState(() {
        nativeMessage = result;
      });
    } catch (e) {
      setState(() {
        nativeMessage = "Помилка при виклику нативного коду: $e";
      });
    }
  }


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Native code + camera",),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 200, 154, 211),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () {
                _getNativeMessage();
                _showNativeMessageAlert();
              },
              child: const Text("Get a native message"),
            ),
            const SizedBox(height: 20),
            if(_imageFile != null)
              Image.file(
                File(_imageFile!.path),

              ),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _pickImage,
        child: const Icon(Icons.camera_alt_outlined),),
    );
  }
}