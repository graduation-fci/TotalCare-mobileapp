// ignore_for_file: depend_on_referenced_packages, file_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../screens/exams_screen.dart';
import '../my_config.dart';
import '../models/exam.dart';

const tokenKey = 'token';
const storage = FlutterSecureStorage();
String? token;

class AuthService with ChangeNotifier {
  List<Exam>? _exams;
  String? next;
  String? previous;
  int? count;
  int currentPage = 1;
  Map<String, dynamic>? error;
  bool isRegister = false;

  List<Exam> get exams {
    return [...?_exams];
  }

  Future<void> setToken(String value) {
    return storage.write(key: tokenKey, value: value);
  }

  Future<String?> getToken() async {
    return await storage.read(key: tokenKey).then((value) => token = value);
  }

  Future<void> getExams() async {
    const dynamic apiEndPoint = Config.apiUrl;
    final examsEndpoint =
        Uri.parse(apiEndPoint + '/exam/exams/?page=$currentPage');

    String? token;
    await getToken().then((value) {
      token = value;
    });

    final response = await http.get(
      examsEndpoint,
      headers: {
        "content-type": "application/json",
        // "accept": "application/json",
        "Authorization": "JWT $token",
      },
    );
    print(json.decode(response.statusCode.toString()));

    final resultData = json.decode(response.body)['results'];
    final nextPage = json.decode(response.body)['next'];
    final previousPage = json.decode(response.body)['previous'];
    final examCount = json.decode(response.body)['count'];

    List<Exam> loadedData = [];

    if (resultData == null) return;

    for (var examData in resultData) {
      loadedData.add(
        Exam(
          title: examData['title'],
          id: examData['id'],
          subject: examData['subject'],
          starts_at: examData['starts_at'],
          ends_at: examData['ends_at'],
        ),
      );
    }
    _exams == null ? _exams = loadedData : _exams = _exams! + loadedData;
    next = nextPage;
    previous = previousPage;
    count = examCount;
    currentPage += 1;
    // print(count);
    notifyListeners();

    // print(response.body);
  }

  Future<void> login(
      String username, String password, BuildContext context) async {
    // final loginEndPoint = getEndPoint(context, '/auth/jwt/create/');
    const dynamic apiEndPoint = Config.apiUrl;
    final loginEndPoint = Uri.parse(apiEndPoint + '/auth/jwt/create/');

    final response = await http.post(
      loginEndPoint,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: json.encode(
        {'username': username, 'password': password},
      ),
    );

    final responseData = json.decode(response.body);
    error = json.decode(response.body)['detail'];

    await storage.write(key: tokenKey, value: responseData['access']);
    await storage.write(key: 'refresh', value: responseData['refresh']);
    // String? value = await storage.read(key: tokenKey);

    if (responseData != null && error!.isEmpty) {
      getExams();

      Navigator.of(context).pushReplacementNamed(ExamsScreen.routeName);
    }
    print(error);

    // print(value);
  }

  Future<void> loginWithJwt(jwt) async {
    await storage.write(key: tokenKey, value: jwt);
    print(await storage.read(key: tokenKey));
  }

  Future<dynamic> getCurrentUser() async {
    final jwt = await storage.read(key: tokenKey);
    return json.decode(jwt!);
  }

  Future<void> logout() async {
    print(await storage.read(key: 'refresh'));

    await storage.delete(key: tokenKey);
    await storage.delete(key: 'refresh');
    print(await storage.read(key: 'refresh'));
  }

  Future<void> refreshJwt() async {
    try {
      const dynamic apiEndPoint = Config.apiUrl;
      final refreshEndPoint = Uri.parse(apiEndPoint + '/auth/jwt/refresh/');

      print(await storage.read(key: tokenKey));
      storage.delete(key: tokenKey);
      String? refToken = await storage.read(key: 'refresh');
      print(refToken);

      //problem: not sending request to server!
      final response = await http.post(
        refreshEndPoint,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: json.encode(
          {'refresh', refToken},
        ),
      );
      print(refToken);

      final responseData = json.decode(response.body);
      print(responseData['access']);
    } catch (error) {}
  }
}
