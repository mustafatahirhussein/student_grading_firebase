import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/models/grading_model.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/add_student_grade.dart';
import 'package:student_grading_app/screens/add_student_grading_collection.dart';
import 'package:student_grading_app/screens/change_password.dart';
import 'package:student_grading_app/screens/user_signup.dart';
import 'package:student_grading_app/screens/widgets/grading_custom_widget.dart';
import 'package:student_grading_app/utils/sg_constants.dart';

class StudentGradingListView extends StatelessWidget {
  StudentGradingListView({super.key});

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref(SgConstants.reference);
  final User? currentUser = FirebaseAuth.instance.currentUser;

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
                SizedBox(
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
      body: StreamBuilder<DatabaseEvent>(
        stream: _databaseReference.child(currentUser!.uid).onValue,
        builder: (context, s) {

          if(s.hasData) {

            return s.data!.snapshot.children.isEmpty ? const Center(child: Text("No Results"),) : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              itemCount: s.data!.snapshot.children.length,
              itemBuilder: (context, i) {

                Map<dynamic, dynamic> snapshot = s.data!.snapshot.value as dynamic;

                List<GradingModel> itemList = [];
                snapshot.forEach((key, value) {

                  var res = GradingModel.fromJson(value);
                  itemList.add(res);
                });

                return GradingCustomWidget(
                  model: itemList[i],
                );
              },
              separatorBuilder: (context, i) => const SizedBox(height: 10),
            );
          }

          else if(s.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          else if(s.hasError) {
            return Text(s.error.toString());
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.bookmark_added_sharp),
        //onPressed: () => SgNavigation().push(const AddStudentGrade()),
        onPressed: () => SgNavigation().push(const AddStudentGradeCollection()),
      ),
    );
  }
}
