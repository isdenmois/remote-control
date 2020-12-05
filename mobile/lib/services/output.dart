import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:remote_control/models/output.dart';
import './request.dart';

final outputsFetcher = OutputsFetcher();
final outputsProvider = StreamProvider((ref) => outputsFetcher.stream);

final selectedOutputProvider = Provider<SelectedOutput>((ref) {
  final outputs = ref.watch(outputsProvider);

  return outputs.when(
      data: (outputs) {
        final getEmpty = () => Output();
        final audio = outputs.audio?.firstWhere((a) => a.selected, orElse: getEmpty)?.title;
        final video = outputs.displays?.firstWhere((v) => v.selected, orElse: getEmpty)?.title;

        return SelectedOutput(audio, video);
      },
      loading: () => null,
      error: (e, s) => null);
});

Future<Outputs> requestOutputs() async {
  final json = await requestGet<Map<String, dynamic>>('devices');

  return Outputs.fromJson(json);
}

class OutputsFetcher {
  final _streamController = new StreamController<Outputs>();
  Outputs last;

  Stream<Outputs> get stream => _streamController.stream;

  OutputsFetcher() {
    refresh();
  }

  void refresh() async {
    final outputs = await requestOutputs();
    last = outputs;

    _streamController.add(outputs);
  }

  Future<void> setDisplay(String id) async {
    setSelected(last.displays, id);
    _streamController.add(last);

    final outputs = Outputs.fromJson(await request('set-display', {'id': id }));

    _streamController.add(outputs);
  }

  Future<void> setAudio(String id) async {
    setSelected(last.audio, id);
    _streamController.add(last);

    final outputs = Outputs.fromJson(await request('set-audio', {'id': id }));

    _streamController.add(outputs);
  }

  setSelected(List<Output> list, String id) {
    for (final Output output in list) {
      output.selected = output.id == id;
    }
  }
}
