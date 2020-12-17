import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remote_control/widgets/remote_icons.dart';
import 'package:remote_control/screens/controls/domain/output.dart';
import 'package:remote_control/screens/controls/state/outputs_state.dart';

import '../outputs_dialog.dart';

class SelectedOutput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<OutputsState>(
        builder: (context, state, child) {
          if (state.outputs == null) return Text('...');
          final title = _getTitle(state.selectedDisplay, state.selectedAudio);

          return InkWell(
            onTap: () => openOutputsDialog(context),
            child: Container(
                height: 40,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(children: [
                  Text(title, style: TextStyle(fontSize: 16)),
                  Expanded(child: Container()),
                  Icon(RemoteIcons.ellipsis_h, size: 16),
                ])),
          );
        },
      );

  openOutputsDialog(BuildContext context) {
    showDialog(context: context, builder: OutputsDialog.dialogBuilder);
  }

  String _getTitle(Output display, Output audio) {
    if (display != null && audio != null) {
      return '${display.title} (${audio.title})';
    }

    if (display != null) {
      return display.title;
    }

    return '???';
  }
}
