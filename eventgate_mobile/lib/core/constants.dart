class AppConstants {
  static const String baseUrl = "http://192.168.1.224:3000/api";
  // 192.168.1.227
  static const String loginEndpoint = "/auth/login";

  static const String eventsEndpoint = "/events";

  static const String participantsEndpoint = "/participants";
  static const String checkInEndpoint = "/participants/check-in";

  static const String authTokenKey = "auth_token";

  static const int connectionTimeout = 10000;
  static const int receiveTimeout = 10000;
}
