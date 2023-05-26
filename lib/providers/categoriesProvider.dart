import 'dart:developer';

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
  List<dynamic> _subCatList = [];
  List<dynamic> _catList = [];
  String? _nextPageEndPoint;
  String? _previousPageEndPoint;

  String? get nextPageEndPoint {
    return _nextPageEndPoint;
  }

  String? get previousPageEndPoint {
    return _previousPageEndPoint;
  }

  List<dynamic> get subCatItems {
    return [..._subCatList];
  }

  List<dynamic> get catItems {
    return [..._catList];
  }

  Future<void> getGeneralCategories({String? searchQuery}) async {
    final extractedData =
        await categoryService.fetchGeneralCat(searchQuery: searchQuery);
    _catList = extractedData['results'];
    _nextPageEndPoint = extractedData['next'];
    _previousPageEndPoint = extractedData['previous'];

    notifyListeners();
  }

  Future<void> getSubCategories({String? searchQuery, int? id}) async {
    final extractedData =
        await categoryService.fetchSubCat(id: id, searchQuery: searchQuery);
    // log('$extractedData');
    _subCatList = extractedData['results'];
    _nextPageEndPoint = extractedData['next'];
    _previousPageEndPoint = extractedData['previous'];

    notifyListeners();
  }

  Future<void> getNextCat(String? nextUrl) async {
    if (nextUrl != null) {
      final extractedData = await categoryService.fetchNextCat(nextUrl);
      // log('$extractedData');
      _subCatList.addAll(extractedData['results']);
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
