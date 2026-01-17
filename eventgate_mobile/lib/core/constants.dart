class AppConstants {
  // Change this to your local IP for physical devices.
  static const String baseUrl = "http://localhost:3000/api";

  static const String loginEndpoint = "/auth/login";

  static const String eventsEndpoint = "/events";

  static const String participantsEndpoint = "/participants";
  static const String checkInEndpoint = "/participants/check-in";

  static const String authTokenKey = "auth_token";

  static const int connectionTimeout = 10000;
  static const int receiveTimeout = 10000;
}
