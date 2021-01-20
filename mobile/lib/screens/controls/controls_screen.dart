import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remote_control/screens/files/files_screen.dart';
import 'package:remote_control/services/change-navigation-bar-color.dart';
import 'package:remote_control/widgets/remote_icons.dart';

import 'widgets/button.dart';
import 'widgets/selected-output.dart';
import 'widgets/player_wheel.dart';
import 'widgets/confirm_button.dart';
import 'widgets/key_button.dart';
import 'widgets/event_button.dart';

class ControlsScreen extends StatelessWidget {
  ControlsScreen({Key key}) : super(key: key);
  final rowMargin = const EdgeInsets.only(top: 25);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final wheelSize = screenWidth.floor().toDouble() - 60;
    final theme = Theme.of(context);

    changeNavigationBarColor(theme.backgroundColor, theme.brightness);

    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        SelectedOutput(),
        Container(
            margin: rowMargin,
            child: Row(
              children: [
                spaceAround(ConfirmButton(event: 'shutdown', message: 'Shutdown?', icon: RemoteIcons.power_off)),
                spaceAround(
                    EventButton(event: 'displayswitch', params: {'type': 'external'}, icon: RemoteIcons.television)),
                spaceAround(
                    EventButton(event: 'displayswitch', params: {'type': 'internal'}, icon: RemoteIcons.desktop)),
              ],
            )),
        Container(
            margin: rowMargin,
            child: Row(
              children: [
                spaceAround(KeyButton(k: ',', icon: RemoteIcons.rotate_left)),
                spaceAround(KeyButton(k: '.', icon: RemoteIcons.rotate_right)),
                spaceAround(KeyButton(k: 'l', modifier: 'alt', icon: RemoteIcons.closed_captioning)),
              ],
            )),
        Container(
            margin: rowMargin,
            child: Row(children: [
              spaceAround(KeyButton(k: 'pageup', icon: RemoteIcons.fast_backward)),
              spaceAround(KeyButton(k: 'enter', icon: RemoteIcons.expand_alt)),
              spaceAround(KeyButton(k: 'pagedown', icon: RemoteIcons.fast_forward)),
            ])),
        Container(
          margin: rowMargin,
          child: Row(children: [
            spaceAround(Button(
              icon: RemoteIcons.folder_open,
              onPressed: () => openFiles(context),
            )),
          ]),
        ),
        spaceAround(PlayerWheel(
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

Widget spaceAround(Widget w) => Expanded(child: Center(child: w));
