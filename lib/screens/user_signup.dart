import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/navigations/sg_utils.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/screens/student_grading.dart';
import 'package:student_grading_app/screens/user_login.dart';
import 'package:student_grading_app/screens/widgets/sg_formfields.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
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
        title: const Text("Register yourself"),
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
              child: Icon(!passwordVisibility
                  ? Icons.visibility_off
                  : Icons.visibility),
            ),
            inputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    signup();
                  },
                  child: const Text("Signup")),
          const SizedBox(
            height: 10,
          ),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Already registered?\t'),
                TextSpan(
                    text: 'Sign in instead',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        SgNavigation().push(UserSignIn());
                      }),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    throw Exception();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                  child: const Text("Throw Exception")),
            ],
          ),
        ],
      ),
    );
  }

  signup() async {
    try {
      isLoading = true;
      await auth.createUserWithEmailAndPassword(email: emailC.text, password: passC.text);

      if (auth.currentUser != null) {
        SgNavigation().pushAndRemove(const StudentGrading());
      }
      isLoading = false;
    }
    on FirebaseException catch (e) {
      if(e.code == 'account-exists-with-different-credential') {
        SgUtils().showSnackBar("User already registered");
        isLoading = false;
      }
      else if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        SgUtils().showSnackBar("User already registered");
        isLoading = false;
      }
      else if(e.code == 'email-already-in-use') {
        SgUtils().showSnackBar("User already registered");
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
