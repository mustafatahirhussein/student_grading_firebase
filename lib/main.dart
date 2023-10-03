import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_grading_app/firebase_options.dart';
import 'package:student_grading_app/screens/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}


