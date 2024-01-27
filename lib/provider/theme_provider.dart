import 'package:cunty/src/imports.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  static double minWidth = 400;

  ThemeProvider() {
    SharedPreferences.getInstance().then((prefs) {
      String theme = prefs.getString('theme') ?? 'light';
      if (theme == 'light') {
        themeMode = ThemeMode.light;
      } else {
        themeMode = ThemeMode.dark;
      }
      notifyListeners();
    });
  }

  double getScalingFactor(double width, double height) {
    double scalingFactor = width / 400;
    if (scalingFactor > 5) {
      scalingFactor = 5;
    }
    return scalingFactor;
  }

  TextStyle headlineTextStyle(BuildContext context) {

    double scalingFactor = MediaQuery.of(context).size.width / 400;
    return GoogleFonts.roboto(
      fontSize: 28 * scalingFactor,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle exSmallTextStyle(BuildContext context) {
    double scalingFactor = MediaQuery.of(context).size.width / 400;
    return GoogleFonts.roboto(
      fontSize: 11 * scalingFactor,
    );
  }
  
  TextStyle smallestTextStyle(BuildContext context) {
    double scalingFactor = MediaQuery.of(context).size.width / 400;
    return GoogleFonts.roboto(
      fontSize: 7 * scalingFactor,
    );
  }

  TextStyle verySmallTextStyle(BuildContext context) {
    double scalingFactor = MediaQuery.of(context).size.width / 400;
    return GoogleFonts.roboto(
      fontSize: 14 * scalingFactor,
    );
  }

  TextStyle smallTextStyle(BuildContext context) {
    double scalingFactor = MediaQuery.of(context).size.width / 400;
    return GoogleFonts.roboto(
      fontSize: 18 * scalingFactor,
    );
  }

  TextStyle mediumTextStyle(BuildContext context) {
    double scalingFactor = MediaQuery.of(context).size.width / 400;
    return GoogleFonts.roboto(
      fontSize: 22 * scalingFactor,
    );
  }

  TextStyle largeTextStyle(BuildContext context) {
    double scalingFactor = MediaQuery.of(context).size.width / 400;
    return GoogleFonts.roboto(
      fontSize: 26 * scalingFactor,
    );
  }

  void toggleTheme(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }
}
