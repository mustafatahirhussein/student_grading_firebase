import 'package:flutter/material.dart';
import 'package:student_grading_app/models/grading_model.dart';

class GradingCustomWidget extends StatelessWidget {
  const GradingCustomWidget({
    super.key,
    required this.model,
  });

  final GradingModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            model.url == null ? SizedBox.shrink() : ClipRRect(child: Image.network(model.url!, fit: BoxFit.cover, height: 40, width: 40,), borderRadius: BorderRadius.circular(60),),

            SizedBox(
              width: 5,
            ),
            Text(
              "Student: ${model.name!}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Phy: ${model.phy!}\t",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              "Chem: ${model.chem!}\t",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              "Maths: ${model.math!}",
              style: TextStyle(
                fontSize: 12,
              ),
            )
          ],
        ),
      ],
    );
  }
}
