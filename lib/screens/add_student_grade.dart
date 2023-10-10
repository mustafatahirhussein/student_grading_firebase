import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:student_grading_app/utils/sg_constants.dart';
import 'package:student_grading_app/utils/sg_utils.dart';

class AddStudentGrade extends StatefulWidget {
  const AddStudentGrade({super.key});

  @override
  State<AddStudentGrade> createState() => _AddStudentGradeState();
}

class _AddStudentGradeState extends State<AddStudentGrade> {
  final _studentC = TextEditingController();
  final _phyC = TextEditingController();
  final _chemC = TextEditingController();
  final _mathC = TextEditingController();

  bool isLoading = false;

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref(SgConstants.reference);

  final StreamController<File?> _fileStream = StreamController();

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

    await _databaseReference.child(currentUser.uid).push().set({
      'id': Random().nextInt(100000).toString(),
      'name': _studentC.text,
      'phy': _phyC.text,
      'chem': _chemC.text,
      'math': _mathC.text,
    }).onError((error, stackTrace) {
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

    SelectedImagesDetails? pf =
        await picker.pickImage(source: ImageSource.gallery);

    if (pf != null) {
      _fileStream.sink.add(File(pf.selectedFiles.first.selectedFile.path));
    }
  }
}
