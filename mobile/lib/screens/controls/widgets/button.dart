import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  Button({ @required this.icon, @required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 40,
      child: ElevatedButton(
        child: Icon(icon, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
