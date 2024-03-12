import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ffi';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_components/auth_textfield.dart';
import 'package:nottacafe/shared_components/loading_dialog.dart';
import 'package:nottacafe/shared_components/mediaSourceDialog.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_functions/user_responses.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/auth/forgot_password/forgot_password.dart';
import 'package:nottacafe/src/screens/home/home.dart';
import 'package:nottacafe/src/screens/home/vendor_home.dart';
import 'package:nottacafe/styles/assets.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class LoginRegisterVendor extends StatefulWidget {
  const LoginRegisterVendor({Key? key}) : super(key: key);

  static const String routeName = "/loginVendor";

  @override
  State<LoginRegisterVendor> createState() => _LoginRegisterVendorState();
}

class _LoginRegisterVendorState extends State<LoginRegisterVendor> {
  late bool _signInContainsErrors;
  late bool _signUpContainsErrors;
  late GlobalKey<FormState> _signInFormKey;
  late GlobalKey<FormState> _signUpFormKey;
  late TextEditingController _signInEmailController;
  late TextEditingController _signInPasswordController;
  late TextEditingController _signUpRestaurantNameController;
  late TextEditingController _signUpEmailController;
  late TextEditingController _signUpLocationController;
  late TextEditingController _signUpOpeningHourController;
  late TextEditingController _signUpClosingHourController;
  late TextEditingController _signUpImageController;
  late TextEditingController _signUpDescriptionController;
  late TextEditingController _signUpPasswordController;
  late TextEditingController _signUpConfirmPasswordController;
  late TextEditingController _phoneController;
  late bool _signInPasswordObscure;
  late bool _signUpPasswordObscure;
  late bool _signUpConfirmPasswordObscure;
  late MyFirebaseAuth _myFirebaseAuth;

  XFile? imageFile;
  File? convImageFile;
  String imageUrl = '';
  String restaurantPic = '';

  Future selectTime(bool option) async {
    final time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    String minute = '';
    String hour = '';
    if (time!.hour == 0) {
      hour = "00";
    } else if (time!.hour < 10) {
      hour = "0" + time!.hour.toString();
    } else {
      hour = time!.hour.toString();
    }

    if (time!.minute == 0) {
      minute = "00";
    } else if (time!.minute < 10) {
      minute = "0" + time!.minute.toString();
    } else {
      minute = time!.minute.toString();
    }
    if (option) {
      _signUpOpeningHourController.text = '${hour}:${minute}';
    } else {
      _signUpClosingHourController.text = '${hour}:${minute}';
    }
  }

  Future takeImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    imageFile = await imagePicker.pickImage(source: source);
    setState(() {
      this.convImageFile = File(imageFile!.path);
    });
  }

  Future uploadImage() async {
    //String cuID = _myFirebaseAuth.getCurrentUser!.uid;
    String imageName = _signUpEmailController.text;
    print("******************");
    print(_signUpEmailController.text);
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImageToUpload =
        referenceRoot.child('${_signUpEmailController.text}/${imageName}');
    //Reference referenceImageToUpload = referenceDirImages.child('${imageName}');

    try {
      await referenceImageToUpload.putFile(File(imageFile!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      // final data = {'profPic': imageUrl.toString()};
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(cuID)
      //     .set(data, SetOptions(merge: true));
      restaurantPic = imageUrl.toString();
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _signInContainsErrors = false;
    _signUpContainsErrors = false;
    _signInFormKey = GlobalKey<FormState>();
    _signUpFormKey = GlobalKey<FormState>();
    _signInEmailController = TextEditingController();
    _signInPasswordController = TextEditingController();
    _signUpRestaurantNameController = TextEditingController();
    _signUpEmailController = TextEditingController();
    _signUpLocationController = TextEditingController();
    _signUpOpeningHourController = TextEditingController();
    _signUpClosingHourController = TextEditingController();
    _signUpImageController = TextEditingController();
    _signUpDescriptionController = TextEditingController();
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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeChange.darkTheme;
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
                  hintText: "Restaurant Name",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textEditingController: _signUpRestaurantNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Restaurant name cannot be left empty";
                    }
                    return null;
                  },
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  //   LengthLimitingTextInputFormatter(8),
                  // ],
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
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a valid phone number.";
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
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: AuthTextfield(
                  hintText: "Restaurant Location",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textEditingController: _signUpLocationController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Restaurant Location cannot be left empty";
                    }
                    return null;
                  },
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  //   LengthLimitingTextInputFormatter(8),
                  // ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: AuthTextfield(
                        readOnly: true,
                        hintText: "Opening Hour",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textEditingController: _signUpOpeningHourController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Working Hours cannot be left empty";
                          }
                          return null;
                        },
                        onTap: () async => await selectTime(true),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly,
                        //   LengthLimitingTextInputFormatter(8),
                        // ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: AuthTextfield(
                        readOnly: true,
                        hintText: "Closing Hour",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textEditingController: _signUpClosingHourController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Working Hours cannot be left empty";
                          }
                          return null;
                        },
                        onTap: () async => await selectTime(false),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly,
                        //   LengthLimitingTextInputFormatter(8),
                        // ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: AuthTextfield(
                  hintText: "Description",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textEditingController: _signUpDescriptionController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Restaurant name cannot be left empty";
                    }
                    return null;
                  },
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  //   LengthLimitingTextInputFormatter(8),
                  // ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 40),
                child: TextButton(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Upload Photo",
                          style: AppTextStyles.buttonTextWhite,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20))
                                    // side: BorderSide(color: Colors.red)
                                    )),
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.blueTwo)),
                    onPressed: () async {
                      dynamic decision = await mediaSourceDialog(context);
                      decision == true
                          ? await takeImage(ImageSource.camera)
                          : decision == false
                              ? await takeImage(ImageSource.gallery)
                              : print("");
                    }),
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
                      String restaurantName =
                          _signUpRestaurantNameController.text;
                      String password = _signUpPasswordController.text;
                      String location = _signUpLocationController.text;
                      String workingHours =
                          '${_signUpOpeningHourController.text}-${_signUpClosingHourController.text}';
                      String description = _signUpDescriptionController.text;
                      String imageUrl =
                          'https://theme-assets.getbento.com/sensei/f9c493b.sensei/assets/images/catering-item-placeholder-704x520.png';
                      restaurantPic =
                          'https://theme-assets.getbento.com/sensei/f9c493b.sensei/assets/images/catering-item-placeholder-704x520.png';
                      String phone = _phoneController.text;
                      loadingAlert(context);
                      await _myFirebaseAuth
                          .signUpVendor(
                              email,
                              restaurantName,
                              password,
                              location,
                              workingHours,
                              description,
                              imageUrl,
                              phone)
                          .then((response) async {
                        if (response == null) {
                          await uploadImage();
                          final data = {'image': restaurantPic};
                          await FirebaseFirestore.instance
                              .collection('restaurants')
                              .doc(_myFirebaseAuth.getCurrentUser!.uid)
                              .set(data, SetOptions(merge: true));
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.restorablePopAndPushNamed(
                              context, VendorHome.routeName);
                        } else {
                          Navigator.pop(context);
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
