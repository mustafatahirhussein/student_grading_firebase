import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';
import 'package:student_grading_app/navigations/sg_utils.dart';
import 'package:student_grading_app/screens/user_login.dart';
import 'package:student_grading_app/screens/widgets/sg_formfields.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController passC = TextEditingController();

  bool passwordVisibility = true;

  bool isLoading = false;
  late User? credential;

  @override
  void initState() {
    // TODO: implement initState

    credential = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Password"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [

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
          isLoading ? const Center(child: CircularProgressIndicator(),) : ElevatedButton(onPressed: () {
            setState(() {});
            updatePassword();
          }, child: const Text("Save Changes")),
        ],
      ),
    );
  }

  updatePassword() async {
    try {
      isLoading = true;
      await credential!.updatePassword(passC.text);

      SgUtils().showSnackBar('Password updated successfully');
      SgNavigation().pushAndRemove(const UserSignIn());
      isLoading = false;
    }
    catch (e) {
      SgUtils().showSnackBar(e.toString());
      isLoading = false;
      setState(() {});
    }
    finally {
      isLoading = false;
      setState(() {});
    }
  }
}
