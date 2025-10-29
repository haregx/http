import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_req/api/config.dart';
import 'package:http_req/widgets/fancy_snackbar.dart';

/// SimpleHttpsGet - Utility class for sending HTTPS GET requests and receiving JSON response.
class SimpleHttpsGet {
  /// Sends a GET request to the given [url].
  /// Returns the decoded JSON response as a Map.
  /// Throws an exception if the request fails or the response is not valid JSON.
  static Future<Map<String, dynamic>> getJson({
    required String url,
    Map<String, String>? headers,
  }) async {
    final defaultHeaders = {
      'Accept': 'application/json',
      ...?headers,
    };
    debugPrint('➡️ GET Request to ${url.replaceAll(ApiConfig.baseUrl, '')}');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: defaultHeaders,
      );
      debugPrint('⬅️ Response StatusCode: ${response.statusCode}');
      debugPrint('⬅️ Response JSON: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        final errorJson = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('⬅️ JSON: $errorJson');
        throw SimpleHttpsPostBadRequestException(errorJson);
      } else if (response.statusCode == 404) {
        debugPrint('❌ 404: Not Found. URL: ${url.replaceAll(ApiConfig.baseUrl, '')}');
        throw SimpleHttpsPostNotFoundException(url.replaceAll(ApiConfig.baseUrl, ''));
      } else if (response.statusCode == 405) {
        debugPrint('❌ 405: Method Not Allowed. URL: ${url.replaceAll(ApiConfig.baseUrl, '')}');
        throw SimpleHttpsPostMethodNotAllowedException(url.replaceAll(ApiConfig.baseUrl, ''));
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}\n${response.body}');
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException) {
        debugPrint('❌ Network error (Native): $e');
        throw SimpleHttpsPostNetworkException();
      }
      rethrow;
    }
  }
}

// Exception for HTTP 404 Not Found
class SimpleHttpsPostNotFoundException implements Exception {
  final String url;
  SimpleHttpsPostNotFoundException(this.url);
  @override
  String toString() => '404 Not Found: $url';
}

// Exception for HTTP 400 Bad Request with JSON body
class SimpleHttpsPostBadRequestException implements Exception {
  final Map<String, dynamic> errorJson;
  SimpleHttpsPostBadRequestException(this.errorJson);
  @override
  String toString() => '$errorJson';
}

// Exception for network errors (e.g., no internet)
class SimpleHttpsPostNetworkException implements Exception {
  const SimpleHttpsPostNetworkException();
  @override
  String toString() => 'No internet connection or server not reachable.';
}

// Exception for HTTP 405 Method Not Allowed
class SimpleHttpsPostMethodNotAllowedException implements Exception {
  final String url;
  SimpleHttpsPostMethodNotAllowedException(this.url);
  @override
  String toString() => '405 Method Not Allowed: $url';
}

class ErrorCodes {
  static String translate(int code) {
    switch (code) {
      default:
        return 'ERROR CODE $code';
    }
  }
}


class HttpsErrorHandler {
  static void handle(BuildContext context, Object e) {
    debugPrint('❌ ${e.runtimeType}');
    if (e is SimpleHttpsPostBadRequestException) {
      debugPrint('❌ SimpleHttpsPostBadRequestException: $e');
      // Zugriff auf Fehlerdetails:
      final errorCode = e.errorJson['code'];
      final errorMessage = ErrorCodes.translate(errorCode);
      debugPrint('❌ Code: $errorCode');
      debugPrint('❌ Message: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        FancySnackbar.build(errorMessage, type: FancySnackbarType.error),
      );
    } else if (e is SimpleHttpsPostNotFoundException) {
      debugPrint('❌ SimpleHttpsPostNotFoundException: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        FancySnackbar.build('Site not Found ERROR', type: FancySnackbarType.error),
      );
    } else if (e is SimpleHttpsPostNetworkException) {
      debugPrint('❌ SimpleHttpsPostNetworkException: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        FancySnackbar.build('Network ERROR', type: FancySnackbarType.error),
      );
    } else {
      debugPrint('❌ Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        FancySnackbar.build('UNEXPECTED ERROR', type: FancySnackbarType.error),
      );
    }
  }
}