class Config {
  static const String apiUrl = "http://192.168.1.8:8001";
  static const String simpleMeds = '$apiUrl/medicine/simple_meds/';
  static const String interactionMain = '$apiUrl/medicine/interactions/';
  static const String login = '$apiUrl/auth/jwt/create/';
  static const String register = '$apiUrl/auth/users/';
  static const String myProfile = '$apiUrl/auth/users/me/';
  static const String userMedications = '$apiUrl/users/medications/';
  static const String refreshJWT = '$apiUrl/auth/jwt/refresh/';

  static const String addresses = '$apiUrl/users/addresses';
}
