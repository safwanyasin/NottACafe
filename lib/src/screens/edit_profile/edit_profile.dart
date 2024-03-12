import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ffi';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_components/auth_textfield.dart';
import 'package:nottacafe/shared_components/loading_dialog.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_functions/show_toast.dart';
import 'package:nottacafe/shared_functions/user_responses.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/auth/forgot_password/forgot_password.dart';
import 'package:nottacafe/src/screens/home/home.dart';
import 'package:nottacafe/src/screens/home/vendor_home.dart';
import 'package:nottacafe/styles/assets.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const String routeName = "/editProfile";

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late bool _formContainsErrors;
  late GlobalKey<FormState> _editProfileFormKey;
  late TextEditingController _sIDController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late MyFirebaseAuth _myFirebaseAuth;
  late Future getUserDetails;
  late DocumentSnapshot userDetails;

  // XFile? imageFile;
  // File? convImageFile;
  // String imageUrl = '';
  // String restaurantPic = '';

  // Future takeImage(ImageSource source) async {
  //   ImagePicker imagePicker = ImagePicker();
  //   imageFile = await imagePicker.pickImage(source: source);
  //   setState(() {
  //     this.convImageFile = File(imageFile!.path);
  //   });
  // }

  // Future uploadImage() async {
  //   //String cuID = _myFirebaseAuth.getCurrentUser!.uid;
  //   String imageName = _signUpEmailController.text;
  //   print("******************");
  //   print(_signUpEmailController.text);
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceImageToUpload =
  //       referenceRoot.child('restaurantImages/${imageName}');
  //   //Reference referenceImageToUpload = referenceDirImages.child('${imageName}');

  //   try {
  //     await referenceImageToUpload.putFile(File(imageFile!.path));
  //     imageUrl = await referenceImageToUpload.getDownloadURL();
  //     // final data = {'profPic': imageUrl.toString()};
  //     // await FirebaseFirestore.instance
  //     //     .collection('users')
  //     //     .doc(cuID)
  //     //     .set(data, SetOptions(merge: true));
  //     restaurantPic = imageUrl.toString();
  //   } catch (e) {}
  // }

  @override
  void initState() {
    super.initState();
    _formContainsErrors = false;
    _editProfileFormKey = GlobalKey<FormState>();
    _myFirebaseAuth = MyFirebaseAuth();
    getUserDetails = getDetails();
  }

  Future getDetails() async {
    userDetails = await FirebaseFirestore.instance
        .collection('users')
        .doc(_myFirebaseAuth.getCurrentUser!.uid)
        .get();
    _sIDController = TextEditingController(text: userDetails['sid']);
    _nameController = TextEditingController(text: userDetails['name']);
    _phoneController = TextEditingController(text: userDetails['phone']);
    _emailController = TextEditingController(text: userDetails['email']);
    _addressController = TextEditingController(text: userDetails['address']);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeChange.darkTheme;
    return Scaffold(
      //extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: AppTextStyles.secondaryHeadingWhite,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))),
      ),
      body: Container(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
            future: getUserDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 30),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Form(
                          key: _editProfileFormKey,
                          autovalidateMode:
                              _formContainsErrors ? AutovalidateMode.always : null,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).size.height / 40),
                                child: AuthTextfield(
                                  initialValue: userDetails['sid'],
                                  hintText: "Student ID",
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  //textEditingController: _sIDController,
                                  readOnly: true,
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
                                    bottom:
                                        MediaQuery.of(context).size.height / 40),
                                child: AuthTextfield(
                                  //initialValue: userDetails['name'],
                                  hintText: "Name",
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _nameController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        value.isEmpty) {
                                      return "Name cannot be left empty";
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
                                    bottom:
                                        MediaQuery.of(context).size.height / 40),
                                child: AuthTextfield(
                                  //initialValue: userDetails['phone'],
                                  hintText: "Phone Number",
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _phoneController,
                                  readOnly: false,
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
                                    bottom:
                                        MediaQuery.of(context).size.height / 40),
                                child: AuthTextfield(
                                  readOnly: true,
                                  hintText: "Email Address",
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _emailController,
                                  //initialValue: userDetails['email'],
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
                                    bottom:
                                        MediaQuery.of(context).size.height / 40),
                                child: AuthTextfield(
                                  //initialValue: userDetails['address'],
                                  hintText: "Delivery Address",
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _addressController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Delivery cannot be left empty";
                                    }
                                    return null;
                                  },
                                  // inputFormatters: [
                                  //   FilteringTextInputFormatter.digitsOnly,
                                  //   LengthLimitingTextInputFormatter(8),
                                  // ],
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //       bottom: MediaQuery.of(context).size.height / 40),
                              //   child: TextButton(
                              //       child: SizedBox(
                              //         width: MediaQuery.of(context).size.width * 0.8,
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Text(
                              //             "Upload Photo",
                              //             style: AppTextStyles.buttonTextWhite,
                              //             textAlign: TextAlign.center,
                              //           ),
                              //         ),
                              //       ),
                              //       style: ButtonStyle(
                              //           shape: MaterialStateProperty.all<
                              //                   RoundedRectangleBorder>(
                              //               RoundedRectangleBorder(
                              //                   borderRadius: BorderRadius.only(
                              //                       topRight: Radius.circular(20),
                              //                       bottomLeft: Radius.circular(20),
                              //                       topLeft: Radius.circular(20),
                              //                       bottomRight: Radius.circular(20))
                              //                   // side: BorderSide(color: Colors.red)
                              //                   )),
                              //           backgroundColor:
                              //               MaterialStateProperty.all(AppColors.blueTwo)),
                              //       onPressed: () async {
                              //         await takeImage(ImageSource.camera);
                              //       }),
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.35,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Save",
                                            style: AppTextStyles.buttonTextWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      topLeft: Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20))
                                                  // side: BorderSide(color: Colors.red)
                                                  )),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.blueTwo)),
                                      // buttonText: "Create Account",
                                      // buttonColor: Theme.of(context).colorScheme.primary,
                                      // buttonTextStyle: AppTextStyles.buttonTextWhite,
                                      onPressed: () async {
                                        if (_editProfileFormKey.currentState!
                                            .validate()) {
                                          String name = _nameController.text;
                                          String phone = _phoneController.text;
                                          String address = _addressController.text;
                                          final data = {
                                            'name': _nameController.text,
                                            'phone': _phoneController.text,
                                            'address': _addressController.text
                                          };
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(_myFirebaseAuth
                                                  .getCurrentUser!.uid)
                                              .set(data, SetOptions(merge: true));
                                          showToast("Profile updated successfully!",
                                              Toast.LENGTH_SHORT);
                                          Navigator.pop(context);
                                        } else {
                                          setState(() {
                                            _formContainsErrors = true;
                                          });
                                        }
                                      }),
                                  TextButton(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.35,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Cancel",
                                            style: AppTextStyles.buttonTextWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      topLeft: Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20))
                                                  // side: BorderSide(color: Colors.red)
                                                  )),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.blueOne)),
                                      // buttonText: "Create Account",
                                      // buttonColor: Theme.of(context).colorScheme.primary,
                                      // buttonTextStyle: AppTextStyles.buttonTextWhite,
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Widget _editProfileForm() {
    return FutureBuilder(
        future: getUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Form(
                key: _editProfileFormKey,
                autovalidateMode:
                    _formContainsErrors ? AutovalidateMode.always : null,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 40),
                      child: AuthTextfield(
                        labelAbove: true,
                        initialValue: userDetails['sid'],
                        hintText: "Student ID",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textEditingController: _sIDController,
                        readOnly: true,
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
                        labelAbove: true,
                        initialValue: userDetails['name'],
                        hintText: "Name",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textEditingController: _nameController,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.isEmpty) {
                            return "Name cannot be left empty";
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
                        initialValue: userDetails['phone'],
                        hintText: "Phone Number",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textEditingController: _phoneController,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a valid 8-digit student ID.";
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
                        readOnly: true,
                        hintText: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        textEditingController: _emailController,
                        initialValue: userDetails['email'],
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
                        initialValue: userDetails['address'],
                        hintText: "Delivery Address",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textEditingController: _addressController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Delivery cannot be left empty";
                          }
                          return null;
                        },
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly,
                        //   LengthLimitingTextInputFormatter(8),
                        // ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       bottom: MediaQuery.of(context).size.height / 40),
                    //   child: TextButton(
                    //       child: SizedBox(
                    //         width: MediaQuery.of(context).size.width * 0.8,
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(
                    //             "Upload Photo",
                    //             style: AppTextStyles.buttonTextWhite,
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //       style: ButtonStyle(
                    //           shape: MaterialStateProperty.all<
                    //                   RoundedRectangleBorder>(
                    //               RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.only(
                    //                       topRight: Radius.circular(20),
                    //                       bottomLeft: Radius.circular(20),
                    //                       topLeft: Radius.circular(20),
                    //                       bottomRight: Radius.circular(20))
                    //                   // side: BorderSide(color: Colors.red)
                    //                   )),
                    //           backgroundColor:
                    //               MaterialStateProperty.all(AppColors.blueTwo)),
                    //       onPressed: () async {
                    //         await takeImage(ImageSource.camera);
                    //       }),
                    // ),
                    Row(
                      children: [
                        TextButton(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Save",
                                  style: AppTextStyles.buttonTextWhite,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))
                                        // side: BorderSide(color: Colors.red)
                                        )),
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.blueTwo)),
                            // buttonText: "Create Account",
                            // buttonColor: Theme.of(context).colorScheme.primary,
                            // buttonTextStyle: AppTextStyles.buttonTextWhite,
                            onPressed: () async {
                              if (_editProfileFormKey.currentState!
                                  .validate()) {
                                loadingAlert(context);
                                String name = _nameController.text;
                                String phone = _phoneController.text;
                                String address = _addressController.text;
                                final data = {
                                  'name': _nameController.text,
                                  'phone': _phoneController.text,
                                  'address': _addressController.text
                                };
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_myFirebaseAuth.getCurrentUser!.uid)
                                    .set(data, SetOptions(merge: true));
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _formContainsErrors = true;
                                });
                              }
                            }),
                        TextButton(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Cancel",
                                  style: AppTextStyles.buttonTextWhite,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))
                                        // side: BorderSide(color: Colors.red)
                                        )),
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.blueOne)),
                            // buttonText: "Create Account",
                            // buttonColor: Theme.of(context).colorScheme.primary,
                            // buttonTextStyle: AppTextStyles.buttonTextWhite,
                            onPressed: () async {
                              Navigator.pop(context);
                            }),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
