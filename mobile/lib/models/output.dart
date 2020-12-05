class Output {
  String id;
  String title;
  bool selected;

  static Output fromJson(Map<String, dynamic> json) => Output()
    ..id = json['id']
    ..title = json['title']
    ..selected = json['selected'];
}

class Outputs {
  List<Output> audio;
  List<Output> displays;

  static Outputs fromJson(Map<String, dynamic> json) {
    final List<dynamic> audio = json['audio'] ?? [];
    final List<dynamic> displays = json['displays'] ?? [];

    return Outputs()
      ..audio = [...audio.map((a) => Output.fromJson(a))]
      ..displays = [...displays.map((d) => Output.fromJson(d))];
  }
}

class SelectedOutput {
  final String audio;
  final String video;

  SelectedOutput(this.audio, this.video);
}
