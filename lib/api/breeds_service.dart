import 'package:flutter/material.dart';
import 'package:http_req/api/config.dart';
import 'package:http_req/api/https_service.dart';

class BreedsService {
  Future<BreedResponse> get () async {
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
        return BreedResponse.success(response);
      } 
      return BreedResponse.error('Unknown code: $code');
    } catch (e) {
      return BreedResponse.error(e);
    }
  }

  Future getRandomDog(String? breed) async {
    String url;
    if (breed == null || breed.isEmpty) {
      url = '${ApiConfig.baseUrl}/breeds/image/random';
    } else {
      final parts = breed.toLowerCase().split(' ');
      if (parts.length == 1) {
        url = '${ApiConfig.baseUrl}/breed/${parts[0]}/images/random';
      } else if (parts.length == 2) {
        url = '${ApiConfig.baseUrl}/breed/${parts[0]}/${parts[1]}/images/random';
      } else {
        return BreedResponse.error('Invalid breed format: $breed');
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
        return BreedResponse.success(response);
      } 
      return BreedResponse.error('Unknown code: $code');
    } catch (e) {
      return BreedResponse.error(e);
    }
  }
}

class BreedResponse {
  final bool isSuccess;
  final dynamic data;
  final Object? error;

  BreedResponse.success(this.data)
      : isSuccess = true,
        error = null;

  BreedResponse.error(this.error)
      : isSuccess = false,
        data = null;
}