// ignore_for_file: depend_on_referenced_packages, file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../screens/exams_screen.dart';

const tokenKey = 'token';
const storage = FlutterSecureStorage();
String? token;

class AuthService with ChangeNotifier {
  // Uri getEndPoint(BuildContext context, String urlSegment) async {
  //   final jsonString = await DefaultAssetBundle.of(context)
  //       .loadString('assets/my_config.json');
  //   final dynamic apiEndPoint = jsonDecode(jsonString)['apiUrl'];
  //   final endPoint = Uri.parse(apiEndPoint + urlSegment);

  //   return endPoint;
  // }

  Future<void> setToken(String value) {
    return storage.write(key: tokenKey, value: value);
  }

  Future<String?> getToken() {
    return storage.read(key: tokenKey).then((value) => token = value);
  }

  Future<void> getExams(BuildContext context) async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/my_config.json');
    final dynamic apiEndPoint = jsonDecode(jsonString)['apiUrl'];
    final examsEndpoint = Uri.parse(apiEndPoint + '/exam/exams/');
    String? token = '';
    getToken().then((value) {
      token = value;
    });

    final response = await http.get(
      examsEndpoint,
      headers: {
        "content-type": "application/json",
        // "accept": "application/json",
        // "Authorization": "JWT $token",
        HttpHeaders.authorizationHeader: 'JWT $token',
      },
    );

    print(token);
    print(response.body);
  }

  Future<void> login(
      String username, String password, BuildContext context) async {
    // final loginEndPoint = getEndPoint(context, '/auth/jwt/create/');
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/my_config.json');
    final dynamic apiEndPoint = jsonDecode(jsonString)['apiUrl'];
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

    await storage.write(key: tokenKey, value: responseData['access']);
    await storage.write(key: 'refresh', value: responseData['refresh']);
    // String? value = await storage.read(key: tokenKey);

    Navigator.of(context).pushReplacementNamed(ExamsScreen.routeName);

    print(responseData['access']);
    // print(value);
  }

  //how to get data from API which requires JWT authentication?
  // String token = await Candidate().getToken();
  // final response = await http.get(url, headers: {
  //   'Content-Type': 'application/json',
  //   'Accept': 'application/json',
  //   'Authorization': 'Bearer $token',
  // });
  // print('Token : ${token}');
  // print(response);

//Source: https://stackoverflow.com/questions/58079131

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

  Future<void> refreshJwt(BuildContext context) async {
    try {
      final jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/my_config.json');
      final dynamic apiEndPoint = jsonDecode(jsonString)['apiUrl'];
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
