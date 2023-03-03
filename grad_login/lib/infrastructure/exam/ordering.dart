enum OrderBy { asc, dec }

extension OrderByExtension on OrderBy {
  String get name {
    switch (this) {
      case OrderBy.asc:
        return 'this is an assending ';
      case OrderBy.dec:
        return 'this is a descenf=dasdn';
    }
  }
}
