import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:remote_control/components/remote_icons.dart';
import 'package:remote_control/screens/outputs_dialog.dart';
import 'package:remote_control/services/output.dart';

class SelectedOutput extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedOutput = useProvider(selectedOutputProvider);

    if (selectedOutput == null) return Text('...');

    return InkWell(
      onTap: () => openOutputsDialog(context),
      child: Container(height: 40, margin: EdgeInsets.only(left: 20, right: 20), child:Row(
          // alignment: Alignment.topLeft,
          children: [
            Text(selectedOutput.video, style: TextStyle(fontSize: 16)),
            Expanded(child: Container()),
            Icon(RemoteIcons.ellipsis_h, size: 16),
          ])),
    );
  }

  openOutputsDialog(BuildContext context) {
    showDialog(context: context, builder: OutputsDialog.dialogBuilder);
  }
}
