import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_components/auth_textfield.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_functions/user_responses.dart';
import 'package:nottacafe/src/screens/auth/forgot_password/forgot_password.dart';
import 'package:nottacafe/src/screens/home/home.dart';
import 'package:nottacafe/src/screens/home/vendor_home.dart';
import 'package:nottacafe/styles/assets.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  static const String routeName = "/login";

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  late bool _signInContainsErrors;
  late bool _signUpContainsErrors;
  late GlobalKey<FormState> _signInFormKey;
  late GlobalKey<FormState> _signUpFormKey;
  late TextEditingController _signInEmailController;
  late TextEditingController _signInPasswordController;
  late TextEditingController _signUpStudentIDController;
  late TextEditingController _signUpEmailController;
  late TextEditingController _signUpPasswordController;
  late TextEditingController _signUpConfirmPasswordController;
  late TextEditingController _phoneController;
  late bool _signInPasswordObscure;
  late bool _signUpPasswordObscure;
  late bool _signUpConfirmPasswordObscure;
  late MyFirebaseAuth _myFirebaseAuth;

  @override
  void initState() {
    super.initState();
    _signInContainsErrors = false;
    _signUpContainsErrors = false;
    _signInFormKey = GlobalKey<FormState>();
    _signUpFormKey = GlobalKey<FormState>();
    _signInEmailController = TextEditingController();
    _signInPasswordController = TextEditingController();
    _signUpStudentIDController = TextEditingController();
    _signUpEmailController = TextEditingController();
    _signUpPasswordController = TextEditingController();
    _signUpConfirmPasswordController = TextEditingController();
    _phoneController = TextEditingController();
    _signInPasswordObscure = true;
    _signUpPasswordObscure = true;
    _signUpConfirmPasswordObscure = true;
    _myFirebaseAuth = MyFirebaseAuth();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: AppTextStyles.secondaryHeadingWhite,
            indicatorColor: Theme.of(context).colorScheme.tertiary,
            tabs: const [
              Tab(
                text: "Sign In",
              ),
              Tab(
                text: "Sign Up",
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage(
                          AppAssets.nottinghamBackground,
                        ),
                        //DecorationImage (image: Image.asset('assets/images/nottingham_background.jpg')),
                        colorFilter: ColorFilter.mode(
                            Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.50),
                            BlendMode.darken),
                        fit: BoxFit.cover,
                      ),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height / 2)
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(70)),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                width: MediaQuery.of(context).size.width,
                child: TabBarView(children: [
                  _signInForm(),
                  _signUpForm(),
                ]),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _signInForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
        child: Form(
          key: _signInFormKey,
          autovalidateMode:
              _signInContainsErrors ? AutovalidateMode.always : null,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: AuthTextfield(
                  hintText: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textEditingController: _signInEmailController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "Please enter a valid email.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 30),
                child: AuthTextfield(
                  hintText: "Password",
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  textEditingController: _signInPasswordController,
                  obscureText: _signInPasswordObscure,
                  suffixIcon: _signInPasswordObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  suffixIconTap: () {
                    setState(() {
                      _signInPasswordObscure = !_signInPasswordObscure;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a valid password.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.restorablePushNamed(
                            context, ForgotPassword.routeName);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: AppTextStyles.descriptionBlack,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)))),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.blueOne)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Login",
                        style: AppTextStyles.buttonTextWhite,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  //buttonColor: Theme.of(context).colorScheme.primary,
                  //buttonTextStyle: AppTextStyles.buttonTextWhite,

                  onPressed: () async {
                    if (_signInFormKey.currentState!.validate()) {
                      String email = _signInEmailController.text;
                      String password = _signInPasswordController.text;
                      await _myFirebaseAuth
                          .signInUser(email, password)
                          .then((response) async {
                        if (response == null) {
                          final check = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(_myFirebaseAuth.getCurrentUser!.uid)
                              .get();
                          //check.exists ? Navigator.restorablePopAndPushNamed(context, Home.routeName) : Navigator.restorablePopAndPushNamed(context, VendorHome.routeName);
                          check.exists
                              ? Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const Home()),
                                  (route) => false)
                              : Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const VendorHome()),
                                  (route) => false);
                        } else {
                          showSnackBar(
                            context,
                            "Error: Incorrect Credentials. Please try again.",
                            Theme.of(context).colorScheme.error,
                            const Duration(seconds: 4),
                          );
                        }
                      });
                    } else {
                      setState(() {
                        _signUpContainsErrors = true;
                        Navigator.pop(context);
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
        child: Form(
          key: _signUpFormKey,
          autovalidateMode:
              _signUpContainsErrors ? AutovalidateMode.always : null,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: AuthTextfield(
                  hintText: "Student ID",
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textEditingController: _signUpStudentIDController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.length < 8) {
                      return "Please enter a valid 8-digit student ID.";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: AuthTextfield(
                  hintText: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textEditingController: _signUpEmailController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "Please enter a valid email.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: AuthTextfield(
                  hintText: "Phone Number",
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  textEditingController: _phoneController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a valid phone number.";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: AuthTextfield(
                  hintText: "Password",
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  textEditingController: _signUpPasswordController,
                  obscureText: _signUpPasswordObscure,
                  suffixIcon: _signUpPasswordObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  suffixIconTap: () {
                    setState(() {
                      _signUpPasswordObscure = !_signUpPasswordObscure;
                    });
                  },
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.isEmpty) {
                      return "Please enter a valid password.";
                    }
                    if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$')
                        .hasMatch(value)) {
                      return "Your password must contain at least:\n8 characters,\n1 uppercase letter,\n1 lowercase letter,\n1 number,\n1 special character.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 30),
                child: AuthTextfield(
                  hintText: "Confirm Password",
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  textEditingController: _signUpConfirmPasswordController,
                  obscureText: _signUpConfirmPasswordObscure,
                  suffixIcon: _signUpConfirmPasswordObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  suffixIconTap: () {
                    setState(() {
                      _signUpConfirmPasswordObscure =
                          !_signUpConfirmPasswordObscure;
                    });
                  },
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.isEmpty) {
                      return "Please enter a valid password.";
                    }
                    if (value != _signUpPasswordController.value.text) {
                      return "Both passwords do not match.";
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Create Account",
                        style: AppTextStyles.buttonTextWhite,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))
                              // side: BorderSide(color: Colors.red)
                              )),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.blueOne)),
                  // buttonText: "Create Account",
                  // buttonColor: Theme.of(context).colorScheme.primary,
                  // buttonTextStyle: AppTextStyles.buttonTextWhite,
                  onPressed: () async {
                    if (_signUpFormKey.currentState!.validate()) {
                      String email = _signUpEmailController.text;
                      String studentID = _signUpStudentIDController.text;
                      String password = _signUpPasswordController.text;
                      String phone = _phoneController.text;
                      await _myFirebaseAuth
                          .signUpUser(email, studentID, password, phone)
                          .then((response) async {
                        if (response == null) {
                          Navigator.restorablePopAndPushNamed(
                              context, Home.routeName);
                        } else {
                          showSnackBar(
                            context,
                            response.message!,
                            Theme.of(context).colorScheme.error,
                            const Duration(seconds: 4),
                          );
                        }
                      });
                    } else {
                      setState(() {
                        _signUpContainsErrors = true;
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
