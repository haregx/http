import 'package:flutter/foundation.dart';

class BreedsResponse {
	final Map<String, List<String>> breeads;
	final String status;

	const BreedsResponse({required this.breeads, required this.status});

	factory BreedsResponse.fromJson(Map<String, dynamic> json) {
		final messageMap = (json['message'] as Map<String, dynamic>? ?? {});
		final breeds = messageMap.map(
			(key, value) => MapEntry(
				key,
				(value as List<dynamic>).map((item) => item.toString()).toList(),
			),
		);
		return BreedsResponse(
			breeads: breeds,
			status: json['status']?.toString() ?? '',
		);
	}

		/// Debug helper: print alle Rassen und ihre Sub-Breeds via `debugPrint`.
		void debugPrintBreeds() {
			debugPrint('Breeds (${breeads.length}):');
			breeads.forEach((breed, subs) {
				if (subs.isEmpty) {
					debugPrint(' - $breed: []');
				} else {
					debugPrint(' - $breed: ${subs.join(', ')}');
				}
			});
		}

	@override
	String toString() => 'BreedsResponse{status: $status, message: ${breeads.runtimeType}}';
}

