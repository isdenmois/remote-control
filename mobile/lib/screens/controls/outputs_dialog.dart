import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remote_control/widgets/remote_icons.dart';

import 'domain/output.dart';
import 'state/outputs_state.dart';

enum RowType { audio, display }

class OutputsDialog extends StatelessWidget {
  OutputsDialog() {
    outputState.fetchOutputs();
  }

  @override
  Widget build(BuildContext context) => Consumer<OutputsState>(builder: (context, state, child) {
        final outputs = state.outputs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...buildDisplays(outputs.displays),
            SizedBox(height: 20),
            ...buildAudios(outputs.audio),
          ],
        );
      });

  List<Widget> buildDisplays(List<Output> displays) {
    if (displays == null || displays.length == 0) return [];

    return [
      Text('Display', style: TextStyle(fontSize: 20)),
      SizedBox(height: 10),
      ...displays.map((output) => OutputRow(output, type: RowType.display)),
    ];
  }

  List<Widget> buildAudios(List<Output> audios) {
    if (audios == null || audios.length == 0) return [];

    return [
      Text('Audio', style: TextStyle(fontSize: 20)),
      SizedBox(height: 10),
      ...audios.map((output) => OutputRow(output, type: RowType.audio)),
    ];
  }

  static Widget dialogBuilder(BuildContext context) => AlertDialog(scrollable: true, content: OutputsDialog());
}

class OutputRow extends StatelessWidget {
  final Output output;
  final RowType type;

  OutputRow(this.output, {this.type});

  @override
  Widget build(BuildContext context) {
    final selected = output.selected;
    final textStyle = TextStyle(fontSize: 16, fontWeight: selected ? FontWeight.bold : FontWeight.w300);

    return InkWell(
      onTap: setOutput,
      child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(children: [
            Expanded(child: Text(output.title, style: textStyle)),
            selected ? Icon(RemoteIcons.ok, size: 16) : Container()
          ])),
    );
  }

  setOutput() {
    if (type == RowType.display) {
      outputState.setDisplay(output.id);
    } else {
      outputState.setAudio(output.id);
    }
  }
}
