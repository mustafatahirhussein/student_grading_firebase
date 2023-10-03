import 'package:flutter/material.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/student_grading.dart';
import 'package:student_grading_app/screens/user_signup.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: SgNavigation.navigatorKey,
      //home: StudentGrading(),
      home: UserSignup(),
    );
  }
}
