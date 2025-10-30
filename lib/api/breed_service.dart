import 'package:flutter/material.dart';
import 'package:http_req/api/config.dart';
import 'package:http_req/api/https_service.dart';

class BreedsService {
  Future<Response> get () async {
    final url = '${ApiConfig.baseUrl}/breeds/list/all';
    
    try {
      var response = await SimpleHttpsGet.getJson(
        url: url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      debugPrint('🔑 response: $response');
      // Check for code in response
      String code = response['status'] as String? ?? 'false';
      if (code == 'success') {
        debugPrint('✅ success (code success)');
        return Response.success(response);
      } 
      return Response.error('Unknown code: $code');
    } catch (e) {
      return Response.error(e);
    }
  }

  Future getRandomDog(String? breed) async {
    String url;
    if (breed == null || breed.isEmpty) {
      url = '${ApiConfig.baseUrl}/breeds/image/random';
    } else {
      final parts = breed.toLowerCase().split(' ');
      if (parts.length == 1) {
        // Breed without sub-breed
        url = '${ApiConfig.baseUrl}/breed/${parts[0]}/images/random';
      } else {
        // Breed with sub-breed (format: "breed subbreed")
        url = '${ApiConfig.baseUrl}/breed/${parts[0]}/${parts[1]}/images/random';
      }
    }

    try {
      var response = await SimpleHttpsGet.getJson(
        url: url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      debugPrint('🔑 response: $response');
      // Check for code in response
      String code = response['status'] as String? ?? 'false';
      if (code == 'success') {
        debugPrint('✅ success (code success)');
        return Response.success(response);
      } 
      return Response.error('Unknown code: $code');
    } catch (e) {
      return Response.error(e);
    }
  }
}

class Response {
  final bool isSuccess;
  final dynamic data;
  final Object? error;

  Response.success(this.data)
      : isSuccess = true,
        error = null;

  Response.error(this.error)
      : isSuccess = false,
        data = null;
}