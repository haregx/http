class ApiConfig {
  // Base URL des Servers
  static const String baseUrl = 'https://dog.ceo/api';
  
  // Timeout-Konfiguration
  static const Duration timeout = Duration(seconds: 30);
  
  // Standard-Headers
  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}

