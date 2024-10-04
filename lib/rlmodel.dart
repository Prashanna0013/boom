import 'package:tflite_flutter/tflite_flutter.dart';

class TensorflowService {
  late Interpreter _interpreter;

  TensorflowService() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Load the model from the assets folder
      _interpreter = await Interpreter.fromAsset('assets/beginner.tflite');
      print('TensorFlow Lite Model Loaded Successfully.');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  // This function runs inference and returns the output.
}
