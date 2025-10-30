import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http_req/widgets/fancy_button.dart';
import 'package:http_req/widgets/platform_constants.dart';
import 'package:http_req/models/home_model.dart';
import 'package:http_req/lang/strings.dart';
// import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* @override
  void initState() {
    super.initState();
  }
    */

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeModel(),
      child: Consumer<HomeModel>(
        builder: (context, model, _) {
          // Compute available width inside the Padding (16 left + 16 right) and
          // use it as the height to make the image container a square.
          final double side = MediaQuery.of(context).size.width - (16.0 * 2);
          return Scaffold(
            appBar: AppBar(title: const Text(Strings.appBarTitle)),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      Strings.yourHotdog,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                    const SizedBox(height: 12),
                  GestureDetector(
                    onTap: (model.loading || !model.buttonEnabled)
                        ? null
                        : model.loadNextImage,
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
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                            child: model.loading
                                ? SizedBox.expand(
                                    key: const ValueKey('loading'),
                                    child: Center(
                                      child: Text(
                                        Strings.loadingImage,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                : (model.imageUrl.isNotEmpty)
                                    ? ClipRRect(
                                        key: ValueKey(model.imageUrl),
                                        borderRadius:
                                            BorderRadius.circular(PlatformConstants.buttonBorderRadius),
                                        child: SizedBox.expand(
                                          child: Image.network(
                                            model.imageUrl,
                                            fit: BoxFit.cover,
                                            // If the image fails to load, show a textual placeholder instead of an asset.
                                            errorBuilder: (c, e, s) => Center(
                                              child: Text(
                                                Strings.noImageAvailable,
                                                style: TextStyle(color: Colors.grey[700]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.expand(
                                        key: const ValueKey('no-image'),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.image, size: 64, color: Colors.grey[600]),
                                              const SizedBox(height: 8),
                                              Text(Strings.noImageAvailable, style: TextStyle(color: Colors.grey[700])),
                                            ],
                                          ),
                                        ),
                                      ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  DropdownButton<String>(
                    value: model.selectedValue.isEmpty
                        ? null
                        : model.selectedValue,
                    hint: const Text(Strings.hintPleaseSelect),
                    isExpanded: true,
                    items: model.dropdownItems
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      model.selectedValue = value;
                      model.fetchRandomDog(
                        value == Strings.allBreeds ? null : value,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                /*  IntrinsicWidth(
                    stepHeight: 60,
                    child: Builder(builder: (context) {
                      final bool btnEnabled = !model.loading && model.buttonEnabled;
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 2000),
                        opacity: btnEnabled ? 1.0 : 0.0,
                        curve: Curves.easeInOut,
                        child: IgnorePointer(
                          ignoring: !btnEnabled,
                          child: FancyButton(
                            // Button is enabled only when not loading and not in cooldown.
                            enabled: btnEnabled,
                            // Reuse the centralized trigger so button and image tap behave the same.
                            onPressed: btnEnabled ? model.loadNextImage : null,
                            // Use the actual PNG as a multi-colour image in the leading slot.
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/hotdog.png',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            // Keep a text color; the Image.asset will retain its original colours.
                            textStyle: const TextStyle(color: Colors.white),
                            label: Strings.loadNewHotdog,
                          ),
                        ),
                      );
                    }),
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
