import 'package:flutter/material.dart';

import 'package:grad_login/infrastructure/categories.dart/categories_service.dart';

class CatItem with ChangeNotifier {
  int id;
  String name;
  String imgURL;

  CatItem({
    required this.id,
    required this.name,
    required this.imgURL,
  });
}

class Categories with ChangeNotifier {
  CategoriesService categoryService = CategoriesService();
  List<dynamic> _list = [];
  String? _nextPageEndPoint;
  String? _previousPageEndPoint;

  String? get nextPageEndPoint {
    return _nextPageEndPoint;
  }

  String? get previousPageEndPoint {
    return _previousPageEndPoint;
  }

  List<dynamic> get items {
    return [..._list];
  }

  Future<void> getCategories({String? searchQuery}) async {
    final extractedData =
        await categoryService.fetchCat(searchQuery: searchQuery);
    // log('$extractedData');
    _list = extractedData['results'];
    _nextPageEndPoint = extractedData['next'];
    _previousPageEndPoint = extractedData['previous'];

    notifyListeners();
  }

  Future<void> getNextCat(String? nextUrl) async {
    if (nextUrl != null) {
      final extractedData = await categoryService.fetchNextCat(nextUrl);
      // log('$extractedData');
      _list.addAll(extractedData['results']);
      _nextPageEndPoint = extractedData['next'];
      _previousPageEndPoint = extractedData['previous'];
      notifyListeners();
    }
  }

  Future<void> getPreviousCat(String? previousUrl) async {
    if (previousUrl != null) {
      final extractedData = await categoryService.fetchPreviousCat(previousUrl);
      // log('$extractedData');
      // _list.addAll(extractedData['results']);
      _nextPageEndPoint = extractedData['next'];
      _previousPageEndPoint = extractedData['previous'];
      notifyListeners();
    }
  }
}
