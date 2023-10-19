import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker_plus/image_picker_plus.dart';

class MlKitImageLabelView extends StatefulWidget {
  const MlKitImageLabelView({super.key});

  @override
  State<MlKitImageLabelView> createState() => _MlKitImageLabelViewState();
}

class _MlKitImageLabelViewState extends State<MlKitImageLabelView> {
  File? inputImage;
  String capturedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Labelling"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(
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
              child: inputImage == null
                  ? const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 100,
                      ),
                    )
                  : Image.file(
                      inputImage!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            capturedText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> attachImage(BuildContext context) async {
    SelectedImagesDetails? image =
        await ImagePickerPlus(context).pickImage(source: ImageSource.gallery);

    if (image != null) {
      inputImage = image.selectedFiles.first.selectedFile;
      setState(() {});
      imageLabelling(inputImage!);
    }
  }

  Future<void> imageLabelling(File image) async {
    final inputImage = InputImage.fromFile(image);

    final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: options);

    await imageLabeler.close();
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    capturedText = "";

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;

      capturedText = ""
          "label: $text\n"
          "index: $index\n"
          "confidence: $confidence"
          "";
    }
    setState(() {});
  }
}
