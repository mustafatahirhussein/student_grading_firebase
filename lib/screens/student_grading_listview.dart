import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/add_student_grade.dart';
import 'package:student_grading_app/screens/change_password.dart';
import 'package:student_grading_app/screens/user_signup.dart';

class StudentGradingListView extends StatelessWidget {
  const StudentGradingListView({super.key});

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.bookmark_added_sharp),
        onPressed: () => SgNavigation().push(const AddStudentGrade()),
      ),
    );
  }
}
