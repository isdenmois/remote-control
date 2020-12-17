import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remote_control/services/request.dart';

import 'button.dart';

class EventButton extends StatelessWidget {
  final String event;
  final IconData icon;
  final Map<String, dynamic> params;

  EventButton({@required this.event, @required this.icon, this.params});

  @override
  Widget build(BuildContext context) {
    return Button(icon: icon, onPressed: sendRequest);
  }

  sendRequest() {
    request(event, params);
  }
}
