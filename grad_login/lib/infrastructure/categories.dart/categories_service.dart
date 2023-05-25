import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class CategoriesService {
  Storage storage = Storage();

  Future<Map<String, dynamic>> fetchGeneralCat({String? searchQuery}) async {
    final queryParams = <String, String>{};

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    if (searchQuery != null) {
      queryParams['search'] = searchQuery;
    }

    final url = Uri.parse(
        '${Config.generalCategories}?${_getQueryString(queryParams)}');
    final respone = await http.get(
      url,
      headers: {'Authorization': 'JWT $token', "Accept-Language": "ar"},
    );
    final extractedData = json.decode(utf8.decode(respone.bodyBytes));
    // log('$extractedData');
    return extractedData;
  }

  Future<Map<String, dynamic>> fetchSubCat(
      {String? searchQuery, int? id}) async {
    final queryParams = <String, String>{};

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    if (searchQuery != null) {
      queryParams['search'] = searchQuery;
    }

    final url = Uri.parse(
        '${Config.subCategories}?general_category=$id${_getQueryString(queryParams)}');
    final respone = await http.get(
      url,
      headers: {'Authorization': 'JWT $token', "Accept-Language": "ar"},
    );
    final extractedData = json.decode(utf8.decode(respone.bodyBytes));
    // log('$extractedData');
    return extractedData;
  }

  Future<Map<String, dynamic>> fetchNextCat(String nextUrl) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final url = Uri.parse(nextUrl);
    final respone = await http.get(
      url,
      headers: {'Authorization': 'JWT $token', "Accept-Language": "ar"},
    );
    final extractedData = json.decode(utf8.decode(respone.bodyBytes));
    // log('$extractedData');
    return extractedData;
  }

  Future<Map<String, dynamic>> fetchPreviousCat(String previousUrl) async {
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final url = Uri.parse(previousUrl);
    final respone = await http.get(
      url,
      headers: {'Authorization': 'JWT $token', "Accept-Language": "ar"},
    );
    final extractedData = json.decode(utf8.decode(respone.bodyBytes));
    // log('$extractedData');
    return extractedData;
  }

  String _getQueryString(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}
