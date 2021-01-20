import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:remote_control/services/request.dart';

class PlayerWheel extends StatelessWidget {
  final double size;
  List<WheelPartData> parts;

  PlayerWheel({this.size, String topKey, String rightKey, String bottomKey, String leftKey, String centerKey}) {
    final newSize = Size(size, size);
    final fs = applyBoxFit(BoxFit.contain, Size(250, 250), newSize);
    final r = Alignment.center.inscribe(fs.destination, Offset.zero & newSize);
    final matrix = Matrix4.translationValues(r.left, r.top, 0)..scale(fs.destination.width / fs.source.width);

    parts = [
      WheelPartData(topKey, matrix, button: topPath, icon: volumeUp),
      WheelPartData(rightKey, matrix, button: rightPath, icon: forward),
      WheelPartData(leftKey, matrix, button: leftPath, icon: backward),
      WheelPartData(bottomKey, matrix, button: bottomPath, icon: volumeDown),
      WheelPartData(centerKey, matrix, button: centerPath, icon: pause),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      child: Stack(children: [
        ...parts.map((part) => WheelPart(part, theme.buttonColor)),
        ...parts.map((e) => CustomPaint(willChange: false, painter: PathPainter(e.icon, theme.primaryColor))),
      ]),
    );
  }
}

class WheelPartData {
  final String key;
  final Path button;
  final Path icon;

  WheelPartData(this.key, Matrix4 matrix, {String button, String icon})
      : button = parsePath(matrix, button),
        icon = parsePath(matrix, icon);
}

Path parsePath(Matrix4 matrix, String path) {
  return parseSvgPathData(path).transform(matrix.storage);
}

class WheelPart extends StatelessWidget {
  final WheelPartData data;
  final Color color;

  WheelPart(this.data, this.color);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Material(
        color: color,
        child: InkWell(onTap: () => keyPress(data.key)),
      ),
      clipper: PathClipper(data.button),
    );
  }
}

class PathPainter extends CustomPainter {
  final Path icon;
  final Color color;

  PathPainter(this.icon, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(icon, Paint()..color = this.color);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(PathPainter oldDelegate) => false;
}

class PathClipper extends CustomClipper<Path> {
  final Path _path;

  PathClipper(this._path);

  @override
  Path getClip(Size size) {
    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

final topPath = 'M 71.97 71.97 L 36.61 36.61 A 125 125 0 0 1 213.39 36.61 L 178.03 71.97 A 75 75  0 0 0 71.97 71.97 Z';
final rightPath =
    'M 178.03 71.97 L 213.39 36.61 A 125 125 0 0 1 213.39 213.39 L 178.03 178.03 A 75 75  0 0 0 178.03 71.97 Z';
final leftPath =
    'M 71.97 178.03 L 36.61 213.39 A 125 125 0 0 1 36.61 36.61 L 71.97 71.97 A 75 75  0 0 0 71.97 178.03 Z';
final bottomPath =
    'M 178.03 178.03 L 213.39 213.39 A 125 125 0 0 1 36.61 213.39 L 71.97 178.03 A 75 75  0 0 0 178.03 178.03 Z';
final centerPath = 'M 125, 125 m -50, 0 a 50,50 0 1,0 100,0 a 50,50 0 1,0 -100,0';

final volumeUp =
    'M 129.1455 21.6785 c -0.3905 -0.19 -0.875 -0.024 -1.067 0.375 c -0.1905 0.3985 -0.022 0.8765 0.3765 1.067 C 129.161 23.46 129.6 24.103 129.6 24.8 s -0.439 1.34 -1.145 1.679 c -0.3985 0.1905 -0.567 0.669 -0.3765 1.067 c 0.193 0.4025 0.677 0.5645 1.067 0.375 C 130.4125 27.314 131.2 26.118 131.2 24.8 s -0.7875 -2.5145 -2.0545 -3.1215 z M 123.5905 15.2 c -0.2955 0 -0.596 0.109 -0.839 0.3525 L 118.303 20 H 113.2 c -0.663 0 -1.2 0.537 -1.2 1.2 v 7.2 c 0 0.6625 0.537 1.2 1.2 1.2 h 5.103 l 4.4485 4.4475 c 0.2435 0.2435 0.544 0.3525 0.839 0.3525 c 0.6165 0 1.2095 -0.476 1.2095 -1.201 V 16.401 C 124.8 15.6755 124.2065 15.2 123.5905 15.2 z M 123.2 32.2335 L 118.9655 28 H 113.6 V 21.6 h 5.3655 L 123.2 17.3665 v 14.867 z M 133.0755 12.0915 c -0.3945 -0.204 -0.8765 -0.056 -1.083 0.335 c -0.2065 0.3905 -0.0565 0.875 0.335 1.0805 c 4.238 2.2275 6.87 6.555 6.87 11.2925 s -2.632 9.065 -6.87 11.2925 c -0.391 0.2055 -0.5415 0.69 -0.335 1.0805 c 0.205 0.3875 0.684 0.542 1.083 0.335 C 137.839 35.003 140.8 30.1335 140.8 24.7995 c 0 -5.3335 -2.961 -10.203 -7.7245 -12.708 z M 136 24.7995 c 0 -3.306 -1.701 -6.331 -4.4405 -7.8935 c -0.3845 -0.219 -0.8795 -0.089 -1.102 0.2945 c -0.2225 0.383 -0.0885 0.872 0.298 1.093 c 2.2385 1.2775 3.6305 3.77 3.6305 6.506 s -1.392 5.229 -3.6305 6.506 c -0.386 0.221 -0.52 0.71 -0.298 1.093 c 0.215 0.369 0.703 0.522 1.102 0.2945 C 134.299 31.131 136 28.106 136 24.7995 z';
final volumeDown =
    'M 129.1455 221.6785 c -0.3905 -0.19 -0.875 -0.024 -1.067 0.375 c -0.1905 0.3985 -0.022 0.8765 0.3765 1.067 C 129.161 223.46 129.6 224.103 129.6 224.8 c 0 0.697 -0.439 1.34 -1.145 1.679 c -0.3985 0.1905 -0.567 0.669 -0.3765 1.067 c 0.193 0.4025 0.677 0.5645 1.067 0.375 C 130.4125 227.314 131.2 226.118 131.2 224.8 s -0.7875 -2.5145 -2.0545 -3.1215 z M 123.5905 215.2 c -0.2955 0 -0.596 0.109 -0.839 0.3525 L 118.303 220 H 113.2 c -0.663 0 -1.2 0.537 -1.2 1.2 v 7.2 c 0 0.6625 0.537 1.2 1.2 1.2 h 5.103 l 4.4485 4.4475 c 0.2435 0.2435 0.544 0.3525 0.839 0.3525 c 0.6165 0 1.2095 -0.476 1.2095 -1.201 V 216.401 C 124.8 215.6755 124.2065 215.2 123.5905 215.2 z M 123.2 232.2335 L 118.9655 228 H 113.6 V 221.6 h 5.3655 L 123.2 217.3665 v 14.867 z m 12.8 -7.434 c 0 -3.306 -1.701 -6.331 -4.4405 -7.8935 c -0.3845 -0.219 -0.8795 -0.089 -1.102 0.2945 c -0.2225 0.383 -0.0885 0.872 0.298 1.093 c 2.2385 1.2775 3.6305 3.77 3.6305 6.506 s -1.392 5.229 -3.6305 6.506 c -0.386 0.221 -0.52 0.71 -0.298 1.093 c 0.215 0.369 0.703 0.522 1.102 0.2945 C 134.299 231.131 136 228.106 136 224.7995 z';
final backward =
    'M 29.4825 130.5625 l 8.835 -8.7 c 0.3525 -0.3525 0.9225 -0.3525 1.275 0 l 0.5325 0.5325 c 0.3525 0.3525 0.3525 0.9225 0 1.275 L 32.4525 131.2 l 7.665 7.53 c 0.3525 0.3525 0.3525 0.9225 0 1.275 l -0.5325 0.5325 c -0.3525 0.3525 -0.9225 0.3525 -1.275 0 L 29.475 131.8375 c -0.345 -0.3525 -0.345 -0.9225 0.0075 -1.275 z m -9.6 1.275 l 8.835 8.7 c 0.3525 0.3525 0.9225 0.3525 1.275 0 l 0.5325 -0.5325 c 0.3525 -0.3525 0.3525 -0.9225 0 -1.275 L 22.8525 131.2 l 7.665 -7.53 c 0.3525 -0.3525 0.3525 -0.9225 0 -1.275 l -0.5325 -0.5325 c -0.3525 -0.3525 -0.9225 -0.3525 -1.275 0 L 19.875 130.5625 c -0.345 0.3525 -0.345 0.9225 0.0075 1.275 z';
final forward =
    'M 230.5175 131.8375 l -8.835 8.7 c -0.3525 0.3525 -0.9225 0.3525 -1.275 0 l -0.5325 -0.5325 c -0.3525 -0.3525 -0.3525 -0.9225 0 -1.275 L 227.5475 131.2 L 219.8825 123.67 c -0.3525 -0.3525 -0.3525 -0.9225 0 -1.275 l 0.5325 -0.5325 c 0.3525 -0.3525 0.9225 -0.3525 1.275 0 l 8.835 8.7 c 0.345 0.3525 0.345 0.9225 -0.0075 1.275 z m 9.6 -1.275 l -8.835 -8.7 c -0.3525 -0.3525 -0.9225 -0.3525 -1.275 0 l -0.5325 0.5325 c -0.3525 0.3525 -0.3525 0.9225 0 1.275 L 237.1475 131.2 L 229.4825 138.73 c -0.3525 0.3525 -0.3525 0.9225 0 1.275 l 0.5325 0.5325 c 0.3525 0.3525 0.9225 0.3525 1.275 0 l 8.835 -8.7 c 0.345 -0.3525 0.345 -0.9225 -0.0075 -1.275 z';
final pause =
    'M 112.88 141.74 h 5.76 c 1.59 0 2.88 -1.29 2.88 -2.88 V 117.74 c 0 -1.59 -1.29 -2.88 -2.88 -2.88 H 112.88 C 111.29 114.86 110 116.15 110 117.74 v 21.12 c 0 1.59 1.29 2.88 2.88 2.88 z M 111.92 117.74 c 0 -0.528 0.432 -0.96 0.96 -0.96 h 5.76 c 0.528 0 0.96 0.432 0.96 0.96 v 21.12 c 0 0.528 -0.432 0.96 -0.96 0.96 H 112.88 c -0.528 0 -0.96 -0.432 -0.96 -0.96 V 117.74 z m 16.32 24 h 5.76 c 1.59 0 2.88 -1.29 2.88 -2.88 V 117.74 c 0 -1.59 -1.29 -2.88 -2.88 -2.88 h -5.76 c -1.59 0 -2.88 1.29 -2.88 2.88 v 21.12 c 0 1.59 1.29 2.88 2.88 2.88 z M 127.28 117.74 c 0 -0.528 0.432 -0.96 0.96 -0.96 h 5.76 c 0.528 0 0.96 0.432 0.96 0.96 v 21.12 c 0 0.528 -0.432 0.96 -0.96 0.96 h -5.76 c -0.528 0 -0.96 -0.432 -0.96 -0.96 V 117.74 z';
