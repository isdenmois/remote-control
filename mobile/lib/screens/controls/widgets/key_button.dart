import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remote_control/services/request.dart';

import 'button.dart';

class KeyButton extends StatelessWidget {
  final String k;
  final String modifier;
  final IconData icon;

  KeyButton({@required this.k, @required this.icon, this.modifier});

  @override
  Widget build(BuildContext context) {
    return Button(icon: icon, onPressed: sendRequest);
  }

  sendRequest() {
    request('keypress', {'key': k, 'modifiers': modifier});
  }
}
