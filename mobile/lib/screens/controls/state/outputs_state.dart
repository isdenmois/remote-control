import 'package:flutter/widgets.dart';

import '../domain/output.dart';
import '../repository/output_repository.dart';

class OutputsState with ChangeNotifier {
  Outputs outputs;

  OutputsState() {
    fetchOutputs();
  }

  Output get selectedDisplay => outputs?.displays?.firstWhere((output) => output.selected);
  Output get selectedAudio => outputs?.audio?.firstWhere((output) => output.selected);

  fetchOutputs() async {
    _setOutputs(await requestOutputs());
  }

  setDisplay(String id) async {
    _setSelected(outputs.displays, id);

    _setOutputs(await setDisplayRequest(id));
  }

  setAudio(String id) async {
    _setSelected(outputs.audio, id);

    _setOutputs(await setAudioRequest(id));
  }

  _setSelected(List<Output> list, String id) {
    for (final Output output in list) {
      output.selected = output.id == id;
    }
    notifyListeners();
  }

  _setOutputs(Outputs outputs) {
    this.outputs = outputs;
    notifyListeners();
  }
}

final outputState = OutputsState();
