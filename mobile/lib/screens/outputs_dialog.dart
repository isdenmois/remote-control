import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:remote_control/components/remote_icons.dart';
import 'package:remote_control/models/output.dart';
import 'package:remote_control/services/output.dart';

enum RowType { audio, display }

class OutputsDialog extends HookWidget {
  OutputsDialog() {
    outputsFetcher.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final outputs = useProvider(outputsProvider);

    return outputs.when(
        data: (outputs) => Container(
            width: 100,
            child: ListView(children: [
              ...buildDisplays(outputs.displays),
              ...buildAudios(outputs.audio),
            ])),
        loading: () => null,
        error: (e, s) => null);
  }

  List<Widget> buildDisplays(List<Output> displays) {
    if (displays == null || displays.length == 0) return [];

    return [
      Text(
        'Display',
        style: TextStyle(fontSize: 20),
      ),
      ...displays.map((output) => OutputRow(output, type: RowType.display)),
    ];
  }

  List<Widget> buildAudios(List<Output> audios) {
    if (audios == null || audios.length == 0) return [];

    return [
      Text('Audio'),
      ...audios.map((output) => OutputRow(output, type: RowType.audio)),
    ];
  }

  static Widget dialogBuilder(BuildContext context) => AlertDialog(content: OutputsDialog());
}

class OutputRow extends StatelessWidget {
  final Output output;
  final RowType type;

  OutputRow(this.output, {this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: InkWell(
          onTap: () => setOutput(context),
          child: Row(children: [
            Expanded(child: Text(output.title)),
            output.selected ? Icon(RemoteIcons.ok, size: 16,) : Container()
          ]),
        ));
  }

  setOutput(BuildContext context) {
    if (type == RowType.display) {
      outputsFetcher.setDisplay(output.id);
    } else {
      outputsFetcher.setAudio(output.id);
    }
  }
}
