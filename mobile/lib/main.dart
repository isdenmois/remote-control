import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remote_control/services/theme.dart';

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
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
      ),
    );
  }
}
