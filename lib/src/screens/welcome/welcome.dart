import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/auth/login_register/login_register.dart';
import 'package:nottacafe/src/screens/auth/login_register/login_register_vendor.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});
  static const String routeName = '/welcome';
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeChange.darkTheme;
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                  isDark ? 'assets/images/bgdark.png' : 'assets/images/bg.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        color: isDark ? AppColors.lightGrey : AppColors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text("You are a: ",
                              style: isDark
                                  ? AppTextStyles.primaryHeadingWhite
                                  : AppTextStyles.primaryHeadingBlack),
                          SizedBox(height: 25),
                          RoundedButton(
                            buttonText: 'Customer',
                            buttonColor: Theme.of(context).colorScheme.primary,
                            buttonTextStyle: AppTextStyles.buttonTextWhite,
                            onTap: () {
                              justPush(context, LoginRegister());
                            },
                          ),
                          RoundedButton(
                            buttonText: 'Vendor',
                            buttonColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            buttonTextStyle: isDark
                                ? AppTextStyles.buttonTextWhite
                                : AppTextStyles.buttonTextBlue,
                            onTap: () {
                              justPush(context, LoginRegisterVendor());
                            },
                          ),
                        ],
                      ),
                    )),
              ],
            )));
  }
}
