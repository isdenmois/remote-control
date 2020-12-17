import 'package:remote_control/services/request.dart';

import '../domain/output.dart';

Future<Outputs> requestOutputs() async {
  final json = await requestGet<Map<String, dynamic>>('devices');

  return Outputs.fromJson(json);
}

Future<Outputs> setDisplayRequest(String id) async {
  final json = await request('set-display', {'id': id});

  return Outputs.fromJson(json);
}

Future<Outputs> setAudioRequest(String id) async {
  final json = await request('set-audio', {'id': id});

  return Outputs.fromJson(json);
}
