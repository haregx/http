import 'package:flutter/material.dart';
import 'package:http_req/api/breeds_service.dart';
import 'package:http_req/api/breed_class.dart';
import 'package:http_req/api/https_service.dart';
import 'package:http_req/widgets/fancy_button.dart';
import 'package:http_req/widgets/platform_constants.dart';
// import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedValue;
  final List<String> _dropdownItems = [];
  final BreedsService _breedsService = BreedsService();
  final String all = '所有犬种';
  String? _imageUrl;
  bool _loadingImage = false;
  // Prevent rapid re-clicks: simple cooldown after pressing the button.
  bool _buttonDisabled = false;

  /// Trigger loading the next image with the same cooldown used by the
  /// button. Safe to call from button or image tap.
  void _triggerNextImage() {
    if (_loadingImage || _buttonDisabled) return;
    setState(() => _buttonDisabled = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _buttonDisabled = false);
    });
    fetchRandomDog(_selectedValue ?? all);
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : '');
  }

  @override
  void initState() {
    super.initState();
    fetchBreeds();
  }

  @override
  Widget build(BuildContext context) {
    // Compute available width inside the Padding (16 left + 16 right) and
    // use it as the height to make the image container a square.
    final double side = MediaQuery.of(context).size.width - (16.0 * 2);
    return Scaffold(
      appBar: AppBar(title: const Text('犬种浏览')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('你的下一个美味热狗')),
            const SizedBox(height: 12),
            // Asset image shown above the dropdown
            /*	ClipRRect(
								borderRadius: BorderRadius.circular(8),
								child: Image.asset(
									'assets/images/hotdog.png',
									height: 80,
									width: double.infinity,
									fit: BoxFit.fitHeight,
									errorBuilder: (c, e, s) => Container(
										height: 120,
										color: Colors.grey[200],
										child: const Center(child: Icon(Icons.image, size: 48)),
									),
								),
							),
							const SizedBox(height: 8),
              */
            GestureDetector(  
              onTap: (_loadingImage || _buttonDisabled) ? null : _triggerNextImage,
              behavior: HitTestBehavior.opaque,
              child: Container(
              height: side,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(
                  PlatformConstants.buttonBorderRadius,
                ),
                color: Colors.grey[200],
              ),
              child: _loadingImage
                  ? const Center(child: CircularProgressIndicator())
                  : (_imageUrl != null && _imageUrl!.isNotEmpty)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        PlatformConstants.buttonBorderRadius,
                      ),
                      child: Image.network(
                        _imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            const Center(child: Icon(Icons.broken_image)),
                        // Use frameBuilder to fade the image in when the first frame arrives.
                        frameBuilder:
                        (
                          BuildContext context,
                          Widget child,
                          int? frame,
                          bool wasSynchronouslyLoaded,
                        ) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeIn,
                            child: child,
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image, size: 64, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            '暂无图片',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
        ),
        ),
      const SizedBox(height: 12),
            DropdownButton<String>(
              value: _selectedValue,
              hint: const Text('请选择'),
              isExpanded: true,
              items: _dropdownItems
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                  fetchRandomDog(_selectedValue);
                });
              },
            ),
            const SizedBox(height: 24),
            IntrinsicWidth(

              stepHeight: 60,
              child: FancyButton(
                // Button is enabled only when not loading and not in cooldown.
                enabled: !_loadingImage && !_buttonDisabled,
                // Reuse the centralized trigger so button and image tap behave the same.
                onPressed: (_loadingImage || _buttonDisabled) ? null : _triggerNextImage,
                // Use the actual PNG as a multi-colour image in the leading slot.
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/hotdog.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.fastfood),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                // Keep a text color; the Image.asset will retain its original colours.
                textStyle: const TextStyle(color: Colors.white),
                label: '你的下一个热狗',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchBreeds() async {
    // Simulate a network call and fetch dog breeds
    final result = await _breedsService.get();
    if (result.isSuccess) {
      try {
        final data = result.data as Map<String, dynamic>;
        final breedsResp = BreedsResponse.fromJson(data);
        breedsResp.debugPrintBreeds();
        setState(() {
          _dropdownItems.clear();
          _dropdownItems.addAll([all]);
          // Add each breed. If it has sub-breeds, add entries for each
          // sub-breed as "Breed SubBreed". If it has no sub-breeds, add
          // the breed itself so standalone breeds are selectable.
          breedsResp.breeads.forEach((breed, subs) {
            if (subs.isEmpty) {
              _dropdownItems.add(_capitalize(breed));
            } else {
              for (var subBreed in subs) {
                _dropdownItems.add('${_capitalize(breed)} ${_capitalize(subBreed)}');
              }
            }
          });
          _selectedValue = all;
        });
        if (mounted) fetchRandomDog(all);
      } catch (e) {
        debugPrint('Failed to parse breeds response: $e');
      }
    } else {
      debugPrint('Failed to fetch breeds: ${result.error}');
      if (mounted) {
        HttpsErrorHandler.handle(context, result.error as Object);
      }
    }
  }

  void fetchRandomDog(String? selectedValue) async {
    if (selectedValue == null) return;
    setState(() {
      _loadingImage = true;
    });
    final result = await _breedsService.getRandomDog(
      selectedValue == all ? null : selectedValue,
    );
    if (result.isSuccess) {
      try {
        final data = result.data as Map<String, dynamic>;
        debugPrint('Random Dog Image Data: $data');
        // Extract the image URL and update the UI
        String imageUrl = data['message'] as String? ?? '';
        if (imageUrl.isNotEmpty) {
          debugPrint('Fetched random dog image URL: $imageUrl');
          if (mounted) {
            setState(() {
              _imageUrl = imageUrl;
            });
          }
        }
      } catch (e) {
        debugPrint('Failed to parse random dog response: $e');
      }
    } else {
      debugPrint('Failed to fetch random dog: ${result.error}');
      if (mounted) {
        HttpsErrorHandler.handle(context, result.error as Object);
      }
    }
    if (mounted) {
      setState(() {
        _loadingImage = false;
      });
    }
  }
}
