import 'package:dio/dio.dart';

final baseUrl = 'http://192.168.1.60:3000';

Future<T> requestGet<T>(String type, [Map<String, dynamic> queryParameters]) {
  return Dio()
      .get<T>('$baseUrl/$type', queryParameters: queryParameters)
      .then((response) => response.data)
      .catchError((e) {
    print(e);
    return null;
  });
}

Future<T> request<T>(String type, [Map<String, dynamic> queryParameters]) {
  return Dio()
      .post<T>('$baseUrl/$type', queryParameters: queryParameters)
      .then((response) => response.data)
      .catchError((e) {
    print(e);
    return null;
  });
}

Future keyPress(String key) {
  return request('keypress', {'key': key});
}
