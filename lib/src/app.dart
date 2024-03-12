import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nottacafe/src/screens/auth/forgot_password/forgot_password.dart';
import 'package:nottacafe/src/screens/auth/login_register/login_register.dart';
import 'package:nottacafe/src/screens/auth/login_register/login_register_vendor.dart';
import 'package:nottacafe/src/screens/cuisines/cuisines.dart';
import 'package:nottacafe/src/screens/food/food.dart';
import 'package:nottacafe/src/screens/home/home.dart';
import 'package:nottacafe/src/screens/home/vendor_home.dart';
import 'package:nottacafe/src/screens/walkthrough/walkthrough.dart';
import 'package:nottacafe/src/screens/welcome/welcome.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings/settings_controller.dart';
import 'package:nottacafe/main.dart';

class MyApp extends StatefulWidget {
  final SettingsController settingsController;
  final User? currentUser;
  final dynamic isCustomer;

  const MyApp({
    Key? key,
    required this.settingsController,
    required this.currentUser,
    required this.isCustomer,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  @override
  void initState() {
    super.initState();
    // getCurrentAppTheme();
  }

  // void getCurrentAppTheme() async {
  //   themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  // }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return Consumer<DarkThemeProvider>(builder: (context, value, child) {
          return MaterialApp(
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: value.darkTheme ? darkTheme() : lightTheme(),
            // darkTheme: ThemeData.dark(),
            // themeMode: settingsController.themeMode,
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case WalkThrough.routeName:
                      return const WalkThrough();
                    case LoginRegister.routeName:
                      return const LoginRegister();
                    case ForgotPassword.routeName:
                      return const ForgotPassword();
                    case Home.routeName:
                      return const Home();
                    case VendorHome.routeName:
                      return const VendorHome();
                    case Cuisines.routeName:
                      return const Cuisines();
                    case Food.routeName:
                      return const Food();
                    case Welcome.routeName:
                      return const Welcome();
                    case LoginRegisterVendor.routeName:
                      return const LoginRegisterVendor();
                    default:
                      if (widget.currentUser == null) {
                        return const Welcome();
                      } else {
                        return widget.isCustomer
                            ? const Home()
                            : const VendorHome();
                      }
                  }
                },
              );
            },
          );
        });
      },
    );
  }
}

ThemeData myTheme(bool isDarkTheme, BuildContext context) {
  return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.blueOne,
        onPrimary: AppColors.blueTwo,
        primaryContainer: AppColors.blueThree,
        onPrimaryContainer:
            isDarkTheme ? AppColors.blueFive : AppColors.neutralOne,
        secondary: AppColors.neutralOne,
        // onSecondary: AppColors.neturalTwo,
        secondaryContainer: !isDarkTheme ? AppColors.white : AppColors.darkGrey,
        onSecondaryContainer:
            !isDarkTheme ? AppColors.darkGrey : AppColors.white,
        tertiary: AppColors.yellow,
        error: AppColors.errorRed,
        shadow: AppColors.black70,
      ),
      appBarTheme:
          const AppBarTheme(iconTheme: IconThemeData(color: AppColors.white)));
}

ThemeData lightTheme() {
  return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.blueOne,
        onPrimary: AppColors.neutralOne,
        primaryContainer: AppColors.white,
        onPrimaryContainer: AppColors.blueOne,
        secondary: AppColors.blueFive,
        tertiary: AppColors.black, // use this for the black text
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.blueOne,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ));
}

ThemeData darkTheme() {
  return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.blueTwo,
        onPrimary: AppColors.neutralTwo,
        primaryContainer: AppColors.darkGrey,
        onPrimaryContainer: AppColors.blueTwo,
        secondary: AppColors.lightGrey,
        tertiary: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.blueOne,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ));
}

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  // Future<bool> getInitial() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool("THEME_STATUS") ?? false;
  // }

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class GrandTotalProvider with ChangeNotifier {
  num _grandTotal = 0;

  num get grandTotal => _grandTotal;

  set grandTotal(num value) {
    _grandTotal = value;
    notifyListeners();
  }
}
