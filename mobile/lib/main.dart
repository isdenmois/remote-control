import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/controls/controls_screen.dart';
import 'screens/controls/state/outputs_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => outputState,
        child: MaterialApp(
          home: ControlsScreen(),
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                primary: Colors.grey[100],
                onPrimary: Colors.black,
              ))),
        ));
  }
}
