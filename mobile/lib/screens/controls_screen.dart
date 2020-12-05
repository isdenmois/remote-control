import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/button.dart';
import '../components/selected_output.dart';
import '../components/player_wheel.dart';
import '../components/confirm_button.dart';
import '../components/key_button.dart';
import '../components/event_button.dart';
import '../components/remote_icons.dart';
import './files_screen.dart';

class ControlsScreen extends HookWidget {
  const ControlsScreen({Key key}) : super(key: key);
  final rowMargin = const EdgeInsets.only(top: 25);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final wheelSize = screenWidth.floor().toDouble() - 60;

    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        SelectedOutput(),
        Container(
            margin: rowMargin,
            child: Row(
              children: [
                SpaceAround(ConfirmButton(event: 'shutdown', message: 'Shutdown?', icon: RemoteIcons.power_off)),
                SpaceAround(
                    EventButton(event: 'displayswitch', params: {'type': 'external'}, icon: RemoteIcons.television)),
                SpaceAround(
                    EventButton(event: 'displayswitch', params: {'type': 'internal'}, icon: RemoteIcons.desktop)),
              ],
            )),
        Container(
            margin: rowMargin,
            child: Row(
              children: [
                SpaceAround(KeyButton(k: ',', icon: RemoteIcons.rotate_left)),
                SpaceAround(KeyButton(k: '.', icon: RemoteIcons.rotate_right)),
                SpaceAround(KeyButton(k: 'l', modifier: 'alt', icon: RemoteIcons.closed_captioning)),
              ],
            )),
        Container(
            margin: rowMargin,
            child: Row(children: [
              SpaceAround(KeyButton(k: 'pageup', icon: RemoteIcons.fast_backward)),
              SpaceAround(KeyButton(k: 'enter', icon: RemoteIcons.expand_alt)),
              SpaceAround(KeyButton(k: 'pagedown', icon: RemoteIcons.fast_forward)),
            ])),
        Container(
          margin: rowMargin,
          child: Row(children: [
            SpaceAround(Button(
              icon: RemoteIcons.folder_open,
              onPressed: () => openFiles(context),
            )),
          ]),
        ),
        SpaceAround(PlayerWheel(
            size: wheelSize,
            topKey: 'audio_vol_up',
            bottomKey: 'audio_vol_down',
            leftKey: 'left',
            rightKey: 'right',
            centerKey: 'space'))
      ]),
    ));
  }

  openFiles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilesScreen(path: '')),
    );
  }
}

Widget SpaceAround(Widget w) {
  return Expanded(child: Center(child: w));
}
