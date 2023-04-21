class Config {
  static const String apiUrl = "http://192.168.1.8:8001";
  static const String simpleMeds = '$apiUrl/medicine/simple_meds/';
  static const String interactionMain = '$apiUrl/medicine/interactions/';
  static const String login = '$apiUrl/auth/jwt/create/';
  static const String register = '$apiUrl/auth/users/';
}
