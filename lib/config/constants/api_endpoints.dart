class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:3000/";
  //for your andriod phone
  // static const String baseUrl = "http://192.168.4.4:3000/api/v1/";

  // ====================== Auth Routes ======================
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String uploadImage = "/auth/uploadImage";
  static const String logout = "/auth/logout";
}
