import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Definição das cores da marca Zymmo
  static const Color primaryColor = Color(0xFFF79605); // Laranja principal
  static const Color primaryVariantColor = Color(0xFFFBB040); // Laranja mais claro

  static const Color secondaryColor = Color(0xFFFA7B4D); // Coral/Salmão
  static const Color secondaryVariantColor = Color(0xFFEF7357); // Coral/Salmão mais escuro

  static const Color neutralLightColor = Color(0xFFFBF9F6); // Branco/Creme (fundo)
  static const Color neutralDarkColor = Color(0xFF7A7771); // Cinza escuro (texto secundário)
  static const Color neutralMediumColor = Color(0xFFBFBBB6); // Cinza médio
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.white;
  static const Color textOnBackground = Color(0xFF444340); // Cinza bem escuro para texto principal

  // Tipografia
  static final TextTheme _lightTextTheme = TextTheme(
    // Headings com "Unna"
    displayLarge: GoogleFonts.unna(
        fontSize: 40, fontWeight: FontWeight.bold, color: textOnBackground, letterSpacing: 1.1),
    displayMedium: GoogleFonts.unna(
        fontSize: 32, fontWeight: FontWeight.bold, color: textOnBackground, letterSpacing: 1.1),
    displaySmall: GoogleFonts.unna(
        fontSize: 28, fontWeight: FontWeight.bold, color: textOnBackground, letterSpacing: 1.1),
    headlineLarge: GoogleFonts.unna(
        fontSize: 24, fontWeight: FontWeight.bold, color: textOnBackground, letterSpacing: 1.1),
    headlineMedium: GoogleFonts.unna(
        fontSize: 20, fontWeight: FontWeight.bold, color: textOnBackground, letterSpacing: 1.1),
    headlineSmall: GoogleFonts.unna(
        fontSize: 18, fontWeight: FontWeight.bold, color: textOnBackground, letterSpacing: 1.1),
    titleLarge: GoogleFonts.unna( // Usado para AppBar titles, por exemplo
        fontSize: 22, fontWeight: FontWeight.bold, color: textOnBackground, letterSpacing: 1.1),
    titleMedium: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w600, color: textOnBackground, letterSpacing: 0.15),
    titleSmall: GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w500, color: textOnBackground, letterSpacing: 0.1),

    // Body text com "Open Sans"
    bodyLarge: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.normal, color: textOnBackground, height: 1.5),
    bodyMedium: GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.normal, color: textOnBackground, height: 1.5),
    bodySmall: GoogleFonts.openSans(
        fontSize: 12, fontWeight: FontWeight.normal, color: neutralDarkColor, height: 1.5),

    // Labels (para botões, etc.) com "Open Sans"
    labelLarge: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w600, color: textOnPrimary, letterSpacing: 1.25),
    labelMedium: GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w600, color: textOnPrimary, letterSpacing: 1.2),
    labelSmall: GoogleFonts.openSans(
        fontSize: 12, fontWeight: FontWeight.w500, color: neutralDarkColor, letterSpacing: 1.0),
  );

  // Tema Claro
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: neutralLightColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: textOnPrimary,
      primaryContainer: primaryVariantColor,
      onPrimaryContainer: textOnBackground,
      secondary: secondaryColor,
      onSecondary: textOnSecondary,
      secondaryContainer: secondaryVariantColor,
      onSecondaryContainer: textOnBackground,
      tertiary: Color(0xFF54CB99), // Verde para status/alerta
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFE6F8F1),
      onTertiaryContainer: Color(0xFF002019),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      background: neutralLightColor,
      onBackground: textOnBackground,
      surface: neutralLightColor, // Cor de superfície para Cards, Dialogs, etc.
      onSurface: textOnBackground,
      surfaceVariant: Color(0xFFF0F0F0), // Uma variação sutil da superfície
      onSurfaceVariant: neutralDarkColor,
      outline: neutralMediumColor,
      outlineVariant: Color(0xFFE8E5E1),
      shadow: Colors.black.withOpacity(0.1),
      scrim: Colors.black.withOpacity(0.4),
      inverseSurface: neutralDarkColor,
      onInverseSurface: neutralLightColor,
      inversePrimary: primaryColor.withOpacity(0.8), // Usado para elementos interativos em superfícies escuras
      // surfaceTint: primaryColor, // Em M3, a cor primária tinge algumas superfícies
    ),
    textTheme: _lightTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: neutralLightColor, // Fundo da AppBar
      foregroundColor: textOnBackground, // Cor do título e ícones na AppBar
      elevation: 0, // Sem sombra por padrão, pode ser ajustado por tela
      iconTheme: const IconThemeData(color: primaryColor),
      titleTextStyle: _lightTextTheme.titleLarge,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimary,
        textStyle: _lightTextTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: _lightTextTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.9), // Um pouco de transparência ou cor sólida
      hintStyle: _lightTextTheme.bodyMedium?.copyWith(color: neutralDarkColor.withOpacity(0.7)),
      labelStyle: _lightTextTheme.bodyMedium?.copyWith(color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: neutralMediumColor, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: neutralMediumColor.withOpacity(0.5), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white, // Cor de fundo dos cards
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: neutralDarkColor.withOpacity(0.8),
      selectedLabelStyle: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: textOnSecondary,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: primaryColor.withOpacity(0.1),
      disabledColor: Colors.grey.withOpacity(0.5),
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: _lightTextTheme.bodySmall?.copyWith(color: primaryColor),
      secondaryLabelStyle: _lightTextTheme.bodySmall?.copyWith(color: textOnPrimary),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      side: BorderSide.none,
    ),
    // Você pode adicionar mais customizações de tema aqui (DialogTheme, TabBarTheme, etc.)
  );

  // Você também pode definir um AppTheme.darkTheme se desejar
}
