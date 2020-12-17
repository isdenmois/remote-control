class File {
  String name;
  String path;
  bool isDirectory;

  static File fromJson(Map<String, dynamic> json) => File()
    ..name = json['name']
    ..path = json['path']
    ..isDirectory = json['dir'];
}
