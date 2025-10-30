// 3D-styled common button used for primary actions throughout the app.
// This widget displays a 3D-styled button with gradients, shadow, and customizable text for primary actions.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http_req/widgets/platform_constants.dart';

enum FancyButtonColor { blue, red, green, grey, orange }

class FancyButton extends StatefulWidget {
  final FancyButtonColor backgroundColor;
  final double? iconTextSpacing;
  final IconData? leadingIcon;
  final Widget? leading;
  final IconData? trailingIcon;
  final String label;
  final double? height;
  final double borderRadius;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final double paddingHorizontal;
  final bool enabled;

  FancyButton({
    super.key,
    required this.label,
    this.height,
    double? borderRadius,
    this.textStyle,
    this.paddingHorizontal = 32,
    this.onPressed,
    this.enabled = true,
    this.leadingIcon,
    this.leading,
    this.trailingIcon,
    this.backgroundColor = FancyButtonColor.blue,
    this.iconTextSpacing,
  }) : borderRadius = borderRadius ?? PlatformConstants.buttonBorderRadius;
  // Blue type
  static const List<Color> _blueGradient = [
    Color.fromARGB(255, 30, 70, 161),
    Color.fromARGB(255, 45, 97, 201),
  ];
  static const Color _blueShadow = Color.fromARGB(64, 73, 135, 251);
  static const List<Color> _blueInnerGradient = [
    Color.fromARGB(0, 40, 91, 202),
    Color.fromARGB(126, 80, 150, 204),
  ];

  // Red type
  static const List<Color> _redGradient = [
    Color(0xFFD32F2F),
    Color(0xFFB71C1C),
  ];
  static const Color _redShadow = Color(0x40D32F2F);
  static const List<Color> _redInnerGradient = [
    Color(0x33FFCDD2),
    Color(0x00FFCDD2),
  ];

  // Orange type
  static const List<Color> _orangeGradient = [
    Color(0xFFFF9800),
    Color(0xFFF57C00),
  ];
  static const Color _orangeShadow = Color(0x40FF9800);
  static const List<Color> _orangeInnerGradient = [
    Color(0x33FFD180),
    Color(0x00FFD180),
  ];

  // Green type
  static const List<Color> _greenGradient = [
    Color(0xFF388E3C),
    Color(0xFF2E7D32),
  ];
  static const Color _greenShadow = Color(0x40388E3C);
  static const List<Color> _greenInnerGradient = [
    Color(0x3328A745),
    Color(0x0028A745),
  ];

  // Grey type
  static const List<Color> _greyGradient = [
    Color(0xFFB0B0B0),
    Color(0xFF888888),
  ];
  static const Color _greyShadow = Color(0x20202020);
  static const List<Color> _greyInnerGradient = [
    Color(0x33FFFFFF),
    Color(0x00FFFFFF),
  ];

  @override
  State<FancyButton> createState() => _FancyButtonState();
}

/// State for PrimaryButton3D, manages pressed and disabled visuals.
class _FancyButtonState extends State<FancyButton> {
  /// Returns the platform-conform spacing between icon and text.
  double _iconTextSpacing() {
    if (widget.iconTextSpacing != null) {
      return widget.iconTextSpacing!;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return 8.0;
      case TargetPlatform.android:
        return 12.0;
      default:
        return 10.0;
    }
  }

  double _responsiveHeight(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isTablet = shortestSide >= 600;
    return isTablet
        ? PlatformConstants.buttonHeightTablet
        : PlatformConstants.buttonHeight;
  }

  /// Whether the button is currently pressed.
  final ValueNotifier<bool> _pressed = ValueNotifier<bool>(false);

  /// Returns the background gradient colors depending on state and platform.
  List<Color> get _currentColors {
    final bool pressed = _pressed.value;
    if (!widget.enabled) {
      // Disabled: flat gradient, lighter shadow, less 3D
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return [
          const Color.fromARGB(255, 235, 235, 235),
          const Color.fromARGB(255, 225, 225, 225),
        ];
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return [
          const Color.fromARGB(255, 200, 200, 200),
          const Color.fromARGB(255, 180, 180, 180),
        ];
      } else {
        return [Colors.grey.shade200, Colors.grey.shade400];
      }
    }
    // Slightly darken when pressed
    switch (widget.backgroundColor) {
      case FancyButtonColor.red:
        return FancyButton._redGradient
            .map((c) => pressed ? _darken(c, 0.10) : c)
            .toList();
      case FancyButtonColor.green:
        return FancyButton._greenGradient
            .map((c) => pressed ? _darken(c, 0.10) : c)
            .toList();
      case FancyButtonColor.grey:
        return FancyButton._greyGradient
            .map((c) => pressed ? _darken(c, 0.10) : c)
            .toList();
      case FancyButtonColor.blue:
        return FancyButton._blueGradient
            .map((c) => pressed ? _darken(c, 0.10) : c)
            .toList();
      case FancyButtonColor.orange:
        return FancyButton._orangeGradient
            .map((c) => pressed ? _darken(c, 0.10) : c)
            .toList();
    }
  }

  /// Returns the inner vertical gradient overlay colors depending on state and platform.
  List<Color> get _currentInnerColors {
    final bool pressed = _pressed.value;
    if (!widget.enabled) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return [const Color(0xFFF2F2F7), const Color(0x00D1D1D6)];
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return [const Color(0xFFE0E0E0), const Color(0x00757575)];
      } else {
        return [Colors.grey.shade100, Colors.grey.shade400.withAlpha(0)];
      }
    }
    switch (widget.backgroundColor) {
      case FancyButtonColor.red:
        return FancyButton._redInnerGradient
            .map((c) => pressed ? _darken(c, 0.08) : c)
            .toList();
      case FancyButtonColor.green:
        return FancyButton._greenInnerGradient
            .map((c) => pressed ? _darken(c, 0.08) : c)
            .toList();
      case FancyButtonColor.grey:
        return FancyButton._greyInnerGradient
            .map((c) => pressed ? _darken(c, 0.08) : c)
            .toList();
      case FancyButtonColor.blue:
        return FancyButton._blueInnerGradient
            .map((c) => pressed ? _darken(c, 0.08) : c)
            .toList();
      case FancyButtonColor.orange:
        return FancyButton._orangeInnerGradient
            .map((c) => pressed ? _darken(c, 0.08) : c)
            .toList();
    }
  }

  /// Returns the shadow color depending on state and platform.
  Color get _currentShadowColor {
    final bool pressed = _pressed.value;
    if (!widget.enabled) {
      // Disabled: lighter, less blur
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return const Color(0x20D1D1D6); // much lighter
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return const Color(0x20202020); // much lighter
      } else {
        return Colors.grey.shade300.withAlpha(32);
      }
    }
    switch (widget.backgroundColor) {
      case FancyButtonColor.red:
        return pressed
            ? _darken(FancyButton._redShadow, 0.15)
            : FancyButton._redShadow;
      case FancyButtonColor.green:
        return pressed
            ? _darken(FancyButton._greenShadow, 0.15)
            : FancyButton._greenShadow;
      case FancyButtonColor.grey:
        return pressed
            ? _darken(FancyButton._greyShadow, 0.15)
            : FancyButton._greyShadow;
      case FancyButtonColor.blue:
        return pressed
            ? _darken(FancyButton._blueShadow, 0.15)
            : FancyButton._blueShadow;
      case FancyButtonColor.orange:
        return pressed
            ? _darken(FancyButton._orangeShadow, 0.15)
            : FancyButton._orangeShadow;
    }
  }

  /// Utility to darken a color by a given amount (0-1).
  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  void dispose() {
    _pressed.dispose();
    super.dispose();
  }

  /// Builds the button widget tree with all visual states and effects.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pressed,
      builder: (context, pressed, child) {
        final bool isDisabled = !widget.enabled;
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: isDisabled ? null : widget.onPressed,
            onTapDown: isDisabled ? null : (_) => _pressed.value = true,
            onTapUp: isDisabled ? null : (_) => _pressed.value = false,
            onTapCancel: isDisabled ? null : () => _pressed.value = false,
            splashColor: isDisabled ? Colors.transparent : null,
            highlightColor: isDisabled ? Colors.transparent : null,
            child: Opacity(
              opacity: isDisabled ? 0.6 : 1.0,
              child: Container(
                height: widget.height ?? _responsiveHeight(context),
                // Outer decoration: less 3D for disabled
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  gradient: isDisabled
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _currentColors,
                          stops: const [0.0, 1.0],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _currentColors,
                          stops: const [0.0, 1.0],
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: _currentShadowColor,
                      blurRadius: isDisabled ? 2 : 15,
                      offset: Offset(0, isDisabled ? 1 : 10),
                    ),
                    BoxShadow(
                      color: Colors.white.withAlpha(128),
                      blurRadius: 4,
                      offset: Offset(0, -1),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Container(
                  // Inner decoration: subtle vertical gradient overlay
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _currentInnerColors,
                      stops: const [0.0, 0.4],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.paddingHorizontal,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.leading != null) ...[
                            IconTheme.merge(
                              data: IconThemeData(
                                size: 22,
                                color: isDisabled
                                    ? (defaultTargetPlatform ==
                                              TargetPlatform.iOS
                                          ? const Color(0xFFAEAEB2)
                                          : defaultTargetPlatform ==
                                                TargetPlatform.android
                                          ? const Color(0xFF424242)
                                          : Colors.grey.shade600)
                                    : (widget.textStyle?.color ?? Colors.white),
                              ),
                              child: widget.leading!,
                            ),
                          ] else if (widget.leadingIcon != null) ...[
                            Icon(
                              widget.leadingIcon,
                              size: 22,
                              color: isDisabled
                                  ? (defaultTargetPlatform == TargetPlatform.iOS
                                        ? const Color(0xFFAEAEB2)
                                        : defaultTargetPlatform ==
                                              TargetPlatform.android
                                        ? const Color(0xFF424242)
                                        : Colors.grey.shade600)
                                  : (widget.textStyle?.color ?? Colors.white),
                            ),
                            SizedBox(width: _iconTextSpacing()),
                          ],
                          Text(
                            widget.label,
                            style:
                                (widget.textStyle ??
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ))
                                    .copyWith(
                                      color: isDisabled
                                          ? (defaultTargetPlatform ==
                                                    TargetPlatform.iOS
                                                ? const Color(
                                                    0xFFB0B0B0,
                                                  ) // medium gray for iOS
                                                : defaultTargetPlatform ==
                                                      TargetPlatform.android
                                                ? const Color(
                                                    0xFF888888,
                                                  ) // medium gray for Android
                                                : Colors
                                                      .grey
                                                      .shade500) // medium for others
                                          : (widget.textStyle?.color ??
                                                Colors.white),
                                    ),
                          ),
                          if (widget.trailingIcon != null) ...[
                            SizedBox(width: _iconTextSpacing()),
                            Icon(
                              widget.trailingIcon,
                              size: 22,
                              color: isDisabled
                                  ? (defaultTargetPlatform == TargetPlatform.iOS
                                        ? const Color(0xFFAEAEB2)
                                        : defaultTargetPlatform ==
                                              TargetPlatform.android
                                        ? const Color(0xFF424242)
                                        : Colors.grey.shade600)
                                  : (widget.textStyle?.color ?? Colors.white),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
