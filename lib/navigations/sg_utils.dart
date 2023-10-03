import 'package:flutter/material.dart';
import 'package:student_grading_app/navigations/sg_navigations.dart';

class SgUtils {

  showSnackBar(String message) {
    ScaffoldMessenger.of(SgNavigation.navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
  }
}