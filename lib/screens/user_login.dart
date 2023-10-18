import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/student_grading_listview.dart';
import 'package:student_grading_app/screens/student_grading_listview_collection.dart';
import 'package:student_grading_app/utils/sg_utils.dart';
import 'package:student_grading_app/screens/student_grading.dart';
import 'package:student_grading_app/screens/user_signup.dart';
import 'package:student_grading_app/screens/widgets/sg_formfields.dart';

class UserSignIn extends StatefulWidget {
  const UserSignIn({super.key});

  @override
  State<UserSignIn> createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  bool passwordVisibility = true;

  bool isLoading = false;

  late FirebaseAuth auth;

  @override
  void initState() {
    // TODO: implement initState

    auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: SgFormFields.border(
              controller: emailC,
              hint: 'Email Address',
              inputType: TextInputType.emailAddress,
            ),
          ),
          SgFormFields.border(
            controller: passC,
            obscure: passwordVisibility,
            hint: 'Password',
            suffix: InkWell(
              onTap: () => setState(() {
                passwordVisibility = !passwordVisibility;
              }),
              child: Icon(
                  !passwordVisibility ? Icons.visibility_off : Icons.visibility),
            ),
            inputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading ? Center(child: CircularProgressIndicator(),) : ElevatedButton(onPressed: () {
            setState(() {

            });
            signIn();
          }, child: const Text("Sign in")),

          const SizedBox(
            height: 10,
          ),
          Text.rich(TextSpan(
            children: [
              const TextSpan(
                  text: 'Note yet registered?\t'
              ),
              TextSpan(
                  text: 'Sign up',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    SgNavigation().push(UserSignup());
                  }
              ),
            ],
          ),
            textAlign: TextAlign.center,),
        ],
      ),
    );
  }

  signIn() async {
    try {
      isLoading = true;
      await auth.signInWithEmailAndPassword(email: emailC.text, password: passC.text);

      if (auth.currentUser != null) {
        //SgNavigation().pushAndRemove(StudentGradingListView());
        SgNavigation().pushAndRemove(StudentGradingListviewCollection());
      }
      isLoading = false;
    }
    on FirebaseException catch (e) {
      if(e.code == 'ERROR_WRONG_PASSWORD') {
        SgUtils().showSnackBar("Wrong Password");
        isLoading = false;
      }
      else if(e.code == 'ERROR_USER_NOT_FOUND') {
        SgUtils().showSnackBar("No user exists");
        isLoading = false;
      }
      else if(e.code == 'INVALID_LOGIN_CREDENTIALS') {
        SgUtils().showSnackBar("No user exists");
        isLoading = false;
      }
      setState(() {});
    }
    finally {
      isLoading = false;
      setState(() {});
    }
  }
}
