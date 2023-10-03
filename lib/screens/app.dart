import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/student_grading.dart';
import 'package:student_grading_app/screens/user_signup.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  Stream<bool> isUserSignedIn() async* {
    User? auth = FirebaseAuth.instance.currentUser;

    if(auth == null) {
      yield false;
    }
    else {
      yield true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: SgNavigation.navigatorKey,
      home: StreamBuilder<bool>(
        initialData: false,
        stream: isUserSignedIn(),
        builder: (context, sp) {
          return sp.data! ? const StudentGrading() : const UserSignup();
        },
      )
    );
  }
}
