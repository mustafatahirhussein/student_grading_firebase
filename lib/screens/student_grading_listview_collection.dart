import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/models/grading_model.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/add_student_grading_collection.dart';
import 'package:student_grading_app/screens/change_password.dart';
import 'package:student_grading_app/screens/ml_kit_image_label.dart';
import 'package:student_grading_app/screens/ml_kit_text_rec_view.dart';
import 'package:student_grading_app/screens/user_signup.dart';
import 'package:student_grading_app/screens/widgets/grading_custom_widget.dart';
import 'package:student_grading_app/utils/sg_constants.dart';

class StudentGradingListviewCollection extends StatelessWidget {
  StudentGradingListviewCollection({super.key});

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Grading"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(child: const Icon(Icons.logout), onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  SgNavigation().pushAndRemove(const UserSignup());
                },),
                const SizedBox(
                  width: 10,
                ),
                InkWell(child: const Icon(Icons.password), onTap: () {
                  SgNavigation().push(const ChangePassword());
                },),
              ],
            ),
          ),
        ],
      ),
      // body: StreamBuilder<DocumentSnapshot>(
      //   stream: firebaseFirestore.collection(SgConstants.reference).doc(auth!.uid).snapshots(),
      //   builder: (context, userSnapshot) {
      //
      //     if(userSnapshot.hasData) {
      //
      //       List<GradingModel> userList = [];
      //       Map<String, dynamic> item = userSnapshot.data!.data() as Map<String, dynamic>;
      //
      //       item['data'].map((e) {
      //         var res = GradingModel.fromJson(e);
      //         userList.add(res);
      //       }).toList();
      //
      //       return ListView.builder(
      //         itemCount: userList.length,
      //         shrinkWrap: true,
      //         itemBuilder: (context, i) {
      //           return GradingCustomWidget(model: userList[i]);
      //         },
      //       );
      //     }
      //
      //     else if(userSnapshot.data == null) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //
      //     else if(userSnapshot.hasError) {
      //       return Text(userSnapshot.error.toString());
      //     }
      //
      //     return const SizedBox.shrink();
      //   },
      // ),

          body: FutureBuilder<DocumentSnapshot>(
          future: firebaseFirestore.collection(SgConstants.reference).doc(auth!.uid).get(),
          builder: (context, userSnapshot) {

            if(userSnapshot.hasData) {

              List<GradingModel> userList = [];
              Map<String, dynamic> item = userSnapshot.data!.data() as Map<String, dynamic>;

              item['data'].map((e) {
                var res = GradingModel.fromJson(e);
                userList.add(res);
              }).toList();

              return ListView.builder(
                itemCount: userList.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return GradingCustomWidget(model: userList[i]);
                },
              );
            }

            else if(userSnapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else if(userSnapshot.hasError) {
              return Text(userSnapshot.error.toString());
            }

            return const SizedBox.shrink();
          },
        ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'grade',
            child: const Icon(Icons.bookmark_added_sharp),
            //onPressed: () => SgNavigation().push(const AddStudentGrade()),
            onPressed: () => SgNavigation().push(const AddStudentGradeCollection()),
          ),
          const SizedBox(width: 10,),
          FloatingActionButton.extended(
            heroTag: 'ml-kit',
            icon: const Icon(Icons.g_mobiledata_rounded),
            label: const Text("Ml-Kit"),
            onPressed: () => SgNavigation().push(const MlKitTextRecView()),
          ),
          const SizedBox(width: 10,),
          FloatingActionButton.extended(
            heroTag: 'image-label',
            icon: const Icon(Icons.label),
            label: const Text("Image Label"),
            onPressed: () => SgNavigation().push(const MlKitImageLabelView()),
          ),
        ],
      ),
    );
  }
}
