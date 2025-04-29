import 'package:flutter/material.dart';
import 'package:camera_plugin/camera_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Plugin Demo',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openNativeCamera() async {
    try {
      await CameraPlugin.openCamera();
    } catch (e) {
      debugPrint("Error opening camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Plugin Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: _openNativeCamera,
          child: const Text('Open Native Camera'),
        ),
      ),
    );
  }
}
