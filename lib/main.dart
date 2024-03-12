import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MyFirebaseAuth myFirebaseAuth = MyFirebaseAuth();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  dynamic userData;
  dynamic isCustomer;
  if (myFirebaseAuth.getCurrentUser != null) {
    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(myFirebaseAuth.getCurrentUser!.uid)
        .get();
    isCustomer = userData.exists;
  } else {
    userData = 'null';
    isCustomer = 'null';
  }

  
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  GrandTotalProvider grandTotalProvider = new GrandTotalProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
  }

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<DarkThemeProvider>(
              create: (context) => themeChangeProvider),
          ChangeNotifierProvider<GrandTotalProvider>(
              create: (context) => grandTotalProvider)
        ],
        child: MyApp(
            settingsController: settingsController,
            currentUser: myFirebaseAuth.getCurrentUser,
            isCustomer: isCustomer)),
  );
}
