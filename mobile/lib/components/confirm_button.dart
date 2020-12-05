import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remote_control/services/confirm_dialog_builder.dart';
import 'package:remote_control/services/request.dart';

import './button.dart';

class ConfirmButton extends StatelessWidget {
  final String event;
  final String message;
  final IconData icon;

  final Map<String, dynamic> params;
  final bool dangerous;

  ConfirmButton({@required this.event, @required this.message, @required this.icon, this.params, this.dangerous});

  @override
  Widget build(BuildContext context) {
    return Button(icon: icon, onPressed: () => showConfirmDialog(context));
  }

  showConfirmDialog(BuildContext context) {
    // show the dialog
    showDialog(context: context, builder: confirmDialogBuilder(message: message, onSuccess: sendRequest));
  }

  sendRequest() {
    request(event, params);
  }
}
