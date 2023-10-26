import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_grading_app/utils/firebase_remote_config.dart';

class RemoteConfigView extends StatefulWidget {
  const RemoteConfigView({super.key});

  @override
  State<RemoteConfigView> createState() => _RemoteConfigViewState();
}

class _RemoteConfigViewState extends State<RemoteConfigView> {

  late List<Widget> list;

  @override
  void initState() {
    // TODO: implement initState

    list = [];
    retrieveResponse();
    super.initState();
  }

  retrieveResponse() async {
    var serverJson = await FirebaseRemoteConfiguration().init();

    for(var item in jsonDecode(serverJson)) {

      String type = item['type'];
      list.add(toWidget(item, type));
    }
    setState(() {});
    return list;
  }

  toWidget(element, type) {
    switch(type) {

      case 'Text':
        return Text(
          element['value'],
          style: TextStyle(
            fontSize: element['fontSize'].toDouble(),
            color: Color(int.parse(element['color'])),
          ),
        );

      case 'Container':
        return Container(
          height: element['height'].toDouble(),
          width: element['width'].toDouble(),
          color: Color(int.parse(element['color'])),
        );

      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remote Config Demo"),
      ),
      body: Column(
        children: [
          ...list,
        ],
      ),
    );
  }
}
