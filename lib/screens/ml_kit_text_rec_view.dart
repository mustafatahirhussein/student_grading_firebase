import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker_plus/image_picker_plus.dart';

class MlKitTextRecView extends StatefulWidget {
  const MlKitTextRecView({super.key});

  @override
  State<MlKitTextRecView> createState() => _MlKitTextRecViewState();
}

class _MlKitTextRecViewState extends State<MlKitTextRecView> {

  File? inputImage;
  String detectedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ml-Kit"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [

          SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: () => attachImage(context),
            child: Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: inputImage == null ? Align(
                alignment: Alignment.center,
                child: Icon(Icons.image, color: Colors.white, size: 100,),
              ) : Image.file(inputImage!, fit: BoxFit.cover,),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          Text(detectedText, textAlign: TextAlign.center,),
        ],
      ),
    );
  }

  Future<void> attachImage(BuildContext context) async {
    SelectedImagesDetails? image = await ImagePickerPlus(context).pickImage(source: ImageSource.gallery);

    if(image != null) {
      inputImage = image.selectedFiles.first.selectedFile;
      setState(() {});
      recognizeText(inputImage!);
    }
  }

  Future<void> recognizeText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    detectedText = '';
    for(TextBlock textBlock in recognizedText.blocks) {
      for(TextLine line in textBlock.lines) {
        detectedText = detectedText + line.text;
      }
    }
    setState(() {

    });
  }
}
