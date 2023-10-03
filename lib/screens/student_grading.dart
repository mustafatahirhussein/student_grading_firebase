import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/change_password.dart';
import 'package:student_grading_app/screens/user_signup.dart';

class StudentGrading extends StatefulWidget {
  const StudentGrading({Key? key}) : super(key: key);

  @override
  State<StudentGrading> createState() => _StudentGradingState();
}

class _StudentGradingState extends State<StudentGrading> {
  final _mathsC = TextEditingController();
  final _phyC = TextEditingController();
  final _chemC = TextEditingController();

  double totalMarks = 0.0;

  dynamic total() {
    int m = toInt(_mathsC.text);
    int p = toInt(_phyC.text);
    int c = toInt(_chemC.text);

    int mark = m + p + c;
    setState(() {
      totalMarks = mark.toDouble();
    });
  }

  dynamic toInt(String value) => int.parse(value);

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
      body: ListView(
        shrinkWrap: true,
        children: [
          buildField(_mathsC, 'Math marks'),
          buildField(_phyC, 'Physics marks'),
          buildField(_chemC, 'Chemistry marks'),
          if (totalMarks == 0)
            const SizedBox.shrink()
          else
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: '\nTotal Marks obtained\n',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: totalMarks.toStringAsFixed(0),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const TextSpan(
                    text: '/300',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () {
            total();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
          ),
          child: const Text("Calculate"),
        ),
      ),
    );
  }

  Widget buildField(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
