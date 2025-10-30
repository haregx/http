import 'package:flutter/foundation.dart';
import 'package:http_req/api/breed_service.dart';
import 'package:http_req/api/breed_class.dart';
import 'package:http_req/lang/strings.dart';

class HomeModel extends ChangeNotifier {
  final BreedsService _breedService = BreedsService();

  List<String> dropdownItems = [];
  String selectedValue = '';
  String imageUrl = '';
  bool loading = false;
  bool buttonDisabled = false;

  HomeModel() {
    loadBreeds();
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : '');
  }

  Future<void> loadBreeds() async {
    debugPrint('HomeModel: loadBreeds() start');
    final result = await _breedService.get();
    if (result.isSuccess) {
      try {
        final data = result.data as Map<String, dynamic>;
        final breedsResp = BreedsResponse.fromJson(data);
        breedsResp.debugPrintBreeds();

        dropdownItems.clear();
        dropdownItems.add(Strings.allBreeds);
        breedsResp.breeads.forEach((breed, subs) {
          if (subs.isEmpty) {
            dropdownItems.add(_capitalize(breed));
          } else {
            for (var sub in subs) {
              dropdownItems.add('${_capitalize(breed)} ${_capitalize(sub)}');
            }
          }
        });

        selectedValue = dropdownItems.first;
        notifyListeners();
        // After breeds are loaded, immediately fetch the first image.
        debugPrint(
          'HomeModel: calling fetchRandomDog for initial selection: $selectedValue',
        );
        await fetchRandomDog(
          selectedValue == Strings.allBreeds ? null : selectedValue,
        );
      } catch (e) {
        debugPrint('parse error: $e');
      }
    } else {
      debugPrint('Failed to fetch breeds: ${result.error}');
    }
  }

  Future<void> fetchRandomDog(String? selected) async {
    debugPrint('HomeModel: fetchRandomDog(selected=$selected)');
    // Allow `selected` to be null which means "random from all breeds".
    final String? breedParam =
        (selected == null || selected == Strings.allBreeds) ? null : selected;
    loading = true;
    notifyListeners();
    final result = await _breedService.getRandomDog(breedParam);
    if (result.isSuccess) {
      try {
        final data = result.data as Map<String, dynamic>;
        final url = data['message'] as String? ?? '';
        imageUrl = url;
        debugPrint('HomeModel: fetched imageUrl=$imageUrl');
      } catch (e) {
        debugPrint('parse random dog error: $e');
      }
    } else {
      debugPrint('Failed to fetch random dog: ${result.error}');
    }
    loading = false;
    notifyListeners();
  }

  // Cooldown helper used by button/image taps
  Future<void> loadNextImage() async {
    if (loading || buttonDisabled) return;
    buttonDisabled = true;
    notifyListeners();
    //  await Future.delayed(const Duration(milliseconds: 800));
    buttonDisabled = false;
    notifyListeners();
    await fetchRandomDog(selectedValue);
  }
}
