import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hexString) : super(_getColorFromHex(hexString));
  static int _getColorFromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return int.parse(buffer.toString(), radix: 16);
  }
}

/// Custom Color Swatch similar to MaterialColor
/// Provides shade getters (shade50, shade100, ..., shade900)
class ColorSwatch extends Color {
  final Map<int, Color> _swatch;

  const ColorSwatch(super.primaryValue, this._swatch);

  Color operator [](int index) => _swatch[index] ?? this;

  /// The lightest shade.
  Color get shade50 => this[50];

  /// The second lightest shade.
  Color get shade100 => this[100];

  /// The third lightest shade.
  Color get shade200 => this[200];

  /// The fourth lightest shade.
  Color get shade300 => this[300];

  /// The fifth lightest shade.
  Color get shade400 => this[400];

  /// The default shade.
  Color get shade500 => this[500];

  /// The fourth darkest shade.
  Color get shade600 => this[600];

  /// The third darkest shade.
  Color get shade700 => this[700];

  /// The second darkest shade.
  Color get shade800 => this[800];

  /// The darkest shade.
  Color get shade900 => this[900];
}

/// Helper class to create ColorSwatch from existing shades
class ColorSwatchHelper {
  /// Create ColorSwatch from SystemColors pattern (95, 90, 80, ..., 5)
  /// Maps: 95->900, 90->800, 80->700, 70->600, 60->500, 50->400, 40->300, 30->200, 20->100, 10->50
  static ColorSwatch fromSystemShades({
    required Color shade95,
    required Color shade90,
    required Color shade80,
    required Color shade70,
    required Color shade60,
    required Color shade50,
    required Color shade40,
    required Color shade30,
    required Color shade20,
    required Color shade10,
    required Color shade5,
  }) {
    return ColorSwatch(
      shade50.value, // Primary color (shade500 equivalent)
      {
        50: shade10,
        100: shade20,
        200: shade30,
        300: shade40,
        400: shade50,
        500: shade60, // Default shade
        600: shade70,
        700: shade80,
        800: shade90,
        900: shade95,
      },
    );
  }

  /// Create ColorSwatch from standard Material pattern (50, 100, ..., 900)
  static ColorSwatch fromMaterialShades({
    required Color shade50,
    required Color shade100,
    required Color shade200,
    required Color shade300,
    required Color shade400,
    required Color shade500,
    required Color shade600,
    required Color shade700,
    required Color shade800,
    required Color shade900,
  }) {
    return ColorSwatch(shade500.value, {
      50: shade50,
      100: shade100,
      200: shade200,
      300: shade300,
      400: shade400,
      500: shade500,
      600: shade600,
      700: shade700,
      800: shade800,
      900: shade900,
    });
  }

  /// Create ColorSwatch from a single color (all shades will be the same)
  static ColorSwatch fromSingleColor(Color color) {
    return ColorSwatch(color.value, {
      50: color,
      100: color,
      200: color,
      300: color,
      400: color,
      500: color,
      600: color,
      700: color,
      800: color,
      900: color,
    });
  }
}

class AppColors {
  static const primary = Color(0xFF346448);
  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF5F7Fa);
  static const lightGrey = Color(0xFFF5F5F5);
  static const beige = Color(0xFFFFF4E5);
  static const lightF = Color(0xFFF9F8F8);
  static const lightFA = Color(0xFFFAFAFA);

  static const greyFx = Color(0xFFF5F7F9);
  /// Border & divider color
  static const greyC0 = Color(0xFFC0C0C0);
  static const greyB3 = Color(0xFFB3B3B3);
  static const grey97 = Color(0xFF979797);
  static const grey84 = Color(0xFF848484);
  static const grey = Color(0xFF4F4F4F);

  static const grayEA = Color(0xFFEAEAEA);
  static const gray7 = Color(0xFF777777);
  static const gray6A = Color(0xFF6A6A6A);
  static const gray4B = Color(0xFF4B4B4B);
  static const gray4A = Color(0xFF4A4A4A);

  static const black5 = Color(0xFF555555);
  static const black3 = Color(0xFF333333);
  static const black24 = Color(0xFF242424);
  static const black = Color(0xFF000000);

  static const green = Color(0xFF1B8145);
  static const scarlet = Color(0xFFE93C3A);
  static const red = Color(0xFFB42F2E);
  static const yellow = Color(0xFFFFC80B);

  static const cancel = Color(0xFFF90000);
  static const warning = Color(0xFFff9f43);
  static const success = Color(0xFF00B31B);
  static const info = Color(0xFF00BCFF);

  // Loading indicator colors
  static const loadingIndicatorLeftDot = Color(0xFF005C9D);
  static const loadingIndicatorRightDot = Color(0xFFf8350a);

  // ColorSwatch versions (all shades are the same as the base color)
  // Use these when you need MaterialColor-like shade access
  static final ColorSwatch primarySwatch = ColorSwatchHelper.fromSingleColor(
    primary,
  );
  static final ColorSwatch greenSwatch = ColorSwatchHelper.fromSingleColor(
    green,
  );
  static final ColorSwatch redSwatch = ColorSwatchHelper.fromSingleColor(red);
  static final ColorSwatch yellowSwatch = ColorSwatchHelper.fromSingleColor(
    yellow,
  );
}

class SystemColors extends AppColors {
  static final red = HexColor('#f8350a');

  // Secondary purple
  static final secondaryPurple95 = HexColor('#010008');
  static final secondaryPurple90 = HexColor('#02010D');
  static final secondaryPurple80 = HexColor('#02010D');
  static final secondaryPurple70 = HexColor('#030119');
  static final secondaryPurple60 = HexColor('#04021E');
  static final secondaryPurple50 = HexColor('#050226');
  static final secondaryPurple40 = HexColor('#373551');
  static final secondaryPurple30 = HexColor('#5C5A72');
  static final secondaryPurple20 = HexColor('#828092');
  static final secondaryPurple10 = HexColor('#A8A7B3');
  static final secondaryPurple5 = HexColor('#DAD9DF');

  // Secondary purple as ColorSwatch (can use .shade50, .shade100, etc.)
  static final ColorSwatch secondaryPurple = ColorSwatchHelper.fromSystemShades(
    shade95: secondaryPurple95,
    shade90: secondaryPurple90,
    shade80: secondaryPurple80,
    shade70: secondaryPurple70,
    shade60: secondaryPurple60,
    shade50: secondaryPurple50,
    shade40: secondaryPurple40,
    shade30: secondaryPurple30,
    shade20: secondaryPurple20,
    shade10: secondaryPurple10,
    shade5: secondaryPurple5,
  );

  // Quarter white
  static final quarterWhite95 = HexColor('#323232');
  static final quarterWhite90 = HexColor('#575757');
  static final quarterWhite80 = HexColor('#7D7D7D');
  static final quarterWhite70 = HexColor('#030119');
  static final quarterWhite60 = HexColor('#C8C8C8');
  static final quarterWhite50 = HexColor('#FAFAFA');
  static final quarterWhite40 = HexColor('#FBFBFB');
  static final quarterWhite30 = HexColor('#FCFCFC');
  static final quarterWhite20 = HexColor('#FCFCFC');
  static final quarterWhite10 = HexColor('#FDFDFD');
  static final quarterWhite5 = HexColor('#E8E8E8');

  // Quarter white as ColorSwatch
  static final ColorSwatch quarterWhite = ColorSwatchHelper.fromSystemShades(
    shade95: quarterWhite95,
    shade90: quarterWhite90,
    shade80: quarterWhite80,
    shade70: quarterWhite70,
    shade60: quarterWhite60,
    shade50: quarterWhite50,
    shade40: quarterWhite40,
    shade30: quarterWhite30,
    shade20: quarterWhite20,
    shade10: quarterWhite10,
    shade5: quarterWhite5,
  );

  // Primary Blue
  static final primaryBlue95 = HexColor('#031726');
  static final primaryBlue90 = HexColor('#052942');
  static final primaryBlue80 = HexColor('#083B5E');
  static final primaryBlue70 = HexColor('#0A4C7A');
  static final primaryBlue60 = HexColor('#0C5E96');
  static final primaryBlue50 = HexColor('#0F75BC');
  static final primaryBlue40 = HexColor('#3F91C9');
  static final primaryBlue30 = HexColor('#63A5D3');
  static final primaryBlue20 = HexColor('#87BADD');
  static final primaryBlue10 = HexColor('#ABCFE8');
  static final primaryBlue5 = HexColor('#DBEAF5');

  // Primary Blue as ColorSwatch
  static final ColorSwatch primaryBlue = ColorSwatchHelper.fromSystemShades(
    shade95: primaryBlue95,
    shade90: primaryBlue90,
    shade80: primaryBlue80,
    shade70: primaryBlue70,
    shade60: primaryBlue60,
    shade50: primaryBlue50,
    shade40: primaryBlue40,
    shade30: primaryBlue30,
    shade20: primaryBlue20,
    shade10: primaryBlue10,
    shade5: primaryBlue5,
  );

  // Tertiary Red
  static final tertiaryRed95 = HexColor('#2E0F07');
  static final tertiaryRed90 = HexColor('#50190D');
  static final tertiaryRed80 = HexColor('#732513');
  static final tertiaryRed70 = HexColor('#953018');
  static final tertiaryRed60 = HexColor('#B73A1E');
  static final tertiaryRed50 = HexColor('#E54925');
  static final tertiaryRed40 = HexColor('#EA6D51');
  static final tertiaryRed30 = HexColor('#EE8971');
  static final tertiaryRed20 = HexColor('#F2A492');
  static final tertiaryRed10 = HexColor('#F6BFB3');
  static final tertiaryRed5 = HexColor('#FBE4DF');

  // Tertiary Red as ColorSwatch
  static final ColorSwatch tertiaryRed = ColorSwatchHelper.fromSystemShades(
    shade95: tertiaryRed95,
    shade90: tertiaryRed90,
    shade80: tertiaryRed80,
    shade70: tertiaryRed70,
    shade60: tertiaryRed60,
    shade50: tertiaryRed50,
    shade40: tertiaryRed40,
    shade30: tertiaryRed30,
    shade20: tertiaryRed20,
    shade10: tertiaryRed10,
    shade5: tertiaryRed5,
  );
}
