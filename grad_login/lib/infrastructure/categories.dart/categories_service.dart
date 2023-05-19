import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../my_config.dart';
import '../shared/storage.dart';

class CategoriesService {
  Storage storage = Storage();

  Future<Map<String, dynamic>> fetchCat({String? searchQuery}) async {
    final queryParams = <String, String>{};

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    if (searchQuery != null) {
      queryParams['search'] = searchQuery;
    }

    final url =
        Uri.parse('${Config.categories}?${_getQueryString(queryParams)}');
    final respone = await http.get(
      url,
      headers: {
        'Authorization': 'JWT $token',
      },
    );
    final extractedData = json.decode(respone.body);
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
      headers: {
        'Authorization': 'JWT $token',
      },
    );
    final extractedData = json.decode(respone.body);
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
      headers: {
        'Authorization': 'JWT $token',
      },
    );
    final extractedData = json.decode(respone.body);
    // log('$extractedData');
    return extractedData;
  }

  String _getQueryString(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}
