// ignore_for_file: non_constant_identifier_names

class User {
  String username;
  String first_name;
  String last_name;
  String email;
  String password;
  String profileType;
  String? phoneNumber;
  String? birthDate;
  String? bloodType;
  String? gender;

  User({
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.password,
    required this.profileType,
    this.phoneNumber,
    this.birthDate,
    this.bloodType,
    this.gender,
  });
}
