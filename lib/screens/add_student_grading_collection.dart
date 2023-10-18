import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:student_grading_app/utils/sg_constants.dart';
import 'package:student_grading_app/utils/sg_utils.dart';

class AddStudentGradeCollection extends StatefulWidget {
  const AddStudentGradeCollection({super.key});

  @override
  State<AddStudentGradeCollection> createState() => _AddStudentGradeCollectionState();
}

class _AddStudentGradeCollectionState extends State<AddStudentGradeCollection> {
  final _studentC = TextEditingController();
  final _phyC = TextEditingController();
  final _chemC = TextEditingController();
  final _mathC = TextEditingController();

  bool isLoading = false;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final StreamController<File?> _fileStream = StreamController();

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<File?>(
                stream: _fileStream.stream,
                builder: (context, fileSp) {
                  return InkWell(
                    onTap: () {
                      getImage(context);
                    },
                    child: fileSp.hasData
                        ? Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.file(
                          fileSp.data!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.abc_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          buildField(_studentC, "Student"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildField(_phyC, "Physics"),
              buildField(_chemC, "Chemistry"),
              buildField(_mathC, "Maths"),
            ],
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                User? user = FirebaseAuth.instance.currentUser;

                setState(() {});
                uploadMarks(user!);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
              ),
              child: const Text("Upload"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(TextEditingController controller, String hint) {
    return controller == _studentC
        ? Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: controller == _studentC
            ? TextInputType.text
            : TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    )
        : Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: TextFormField(
          controller: controller,
          keyboardType: controller == _studentC
              ? TextInputType.text
              : TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  uploadMarks(User currentUser) async {
    isLoading = true;

    Map<String, dynamic> body = {
      'id': Random().nextInt(100000).toString(),
      'name': _studentC.text,
      'phy': _phyC.text,
      'chem': _chemC.text,
      'math': _mathC.text,
      'url': imageUrl,
    };

    await _firebaseFirestore.collection(SgConstants.reference).doc(currentUser.uid).set({"data": FieldValue.arrayUnion([body])}, SetOptions(merge: true)).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      SgUtils().showSnackBar(error.toString());
    });

    setState(() {
      isLoading = false;

      _studentC.clear();
      _phyC.clear();
      _chemC.clear();
      _mathC.clear();
    });
    SgUtils().showSnackBar('Uploaded successfully');
  }

  Future getImage(BuildContext context) async {
    ImagePickerPlus picker = ImagePickerPlus(context);

    SelectedImagesDetails? pf = await picker.pickImage(source: ImageSource.gallery);

    if (pf != null) {
      _fileStream.sink.add(File(pf.selectedFiles.first.selectedFile.path));

      Reference storageRef = FirebaseStorage.instance.ref().child('images/img_${DateTime.now().microsecondsSinceEpoch}');
      UploadTask uploadTask = storageRef.putFile(pf.selectedFiles.first.selectedFile);
      TaskSnapshot snapshot = await uploadTask;

      String url = await storageRef.getDownloadURL();
      SgUtils().showSnackBar('Image uploaded successfully');
      imageUrl = url;

      setState(() {});
    }
  }
}
