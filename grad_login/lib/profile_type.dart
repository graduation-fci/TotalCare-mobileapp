enum ProfileType {
  prf,
  std,
}

extension ProfileTypeExtention on ProfileType {
  String get name {
    switch (this) {
      case ProfileType.prf:
        return 'Professor';
      case ProfileType.std:
        return 'Student';
    }
  }
}
