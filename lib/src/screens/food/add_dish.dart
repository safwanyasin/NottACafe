import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ffi';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_components/auth_textfield.dart';
import 'package:nottacafe/shared_components/loading_dialog.dart';
import 'package:nottacafe/shared_components/mediaSourceDialog.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
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

class AddDish extends StatefulWidget {
  const AddDish({Key? key}) : super(key: key);

  static const String routeName = "/addDish";

  @override
  State<AddDish> createState() => _AddDishState();
}

class _AddDishState extends State<AddDish> {
  late bool _formContainsErrors;
  late GlobalKey<FormState> _addDishFormKey;
  late TextEditingController _nameController;
  late TextEditingController _calorieCountController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late MyFirebaseAuth _myFirebaseAuth;
  late DocumentSnapshot userDetails;
  late Future getUserDeatails;

  XFile? imageFile;
  File? convImageFile;
  String imageUrl = '';
  String dishPic = '';
  String randID = '';

  Future takeImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    imageFile = await imagePicker.pickImage(source: source);
    setState(() {
      this.convImageFile = File(imageFile!.path);
    });
  }

  Future uploadImage() async {
    //String cuID = _myFirebaseAuth.getCurrentUser!.uid;
    String imageName = _nameController.text;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImageToUpload =
        referenceRoot.child('${userDetails['email']}/${randID}');
    //Reference referenceImageToUpload = referenceDirImages.child('${imageName}');

    try {
      await referenceImageToUpload.putFile(File(imageFile!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      // final data = {'profPic': imageUrl.toString()};
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(cuID)
      //     .set(data, SetOptions(merge: true));
      dishPic = imageUrl.toString();
    } catch (e) {}
  }

  Future getDetails() async {
    randID = await FirebaseFirestore.instance.collection('food').doc().id;
    userDetails = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(_myFirebaseAuth.getCurrentUser!.uid)
        .get();
  }

  @override
  void initState() {
    super.initState();
    _formContainsErrors = false;
    _addDishFormKey = GlobalKey<FormState>();
    _myFirebaseAuth = MyFirebaseAuth();
    _nameController = TextEditingController();
    _calorieCountController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    getUserDeatails = getDetails();
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
          'Add a Dish',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    dynamic decision = await mediaSourceDialog(context);
                    decision == true
                        ? await takeImage(ImageSource.camera)
                        : decision == false
                            ? await takeImage(ImageSource.gallery)
                            : print('');
                  },
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: MediaQuery.of(context).size.width / 2.5,
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(2),
                                    bottomRight: Radius.circular(20)),
                                child: convImageFile != null
                                    ? Image.file(convImageFile!,
                                        // width: MediaQuery.of(context)
                                        //             .size
                                        //             .width /
                                        //         2 -
                                        //     8,
                                        // height: MediaQuery.of(context)
                                        //             .size
                                        //             .width /
                                        //         2 -
                                        //     8
                                        fit: BoxFit.cover)
                                    : Center(
                                        child: Icon(Icons.add,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            size: 60)))),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(25)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text('Add an image',
                            style: AppTextStyles.moreButton),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Form(
                  key: _addDishFormKey,
                  autovalidateMode:
                      _formContainsErrors ? AutovalidateMode.always : null,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 40),
                        child: AuthTextfield(
                          //initialValue: userDetails['name'],
                          hintText: "Dish Name",
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
                          //initialValue: userDetails['phone'],
                          hintText: "Dish Price",
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          textEditingController: _priceController,
                          //readOnly: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter a price for the dish";
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
                          //initialValue: userDetails['address'],
                          hintText: "Calorie Count",
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          textEditingController: _calorieCountController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Calorie Count cannot be left empty";
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
                          //initialValue: userDetails['name'],
                          hintText: "Description",
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textEditingController: _descriptionController,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.isEmpty) {
                              return "Description cannot be left empty";
                            }
                            return null;
                          },

                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly,
                          //   LengthLimitingTextInputFormatter(8),
                          // ],
                        ),
                      ),
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
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Add",
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
                                if (_addDishFormKey.currentState!.validate()) {
                                  loadingAlert(context);
                                  await uploadImage();
                                  String name = _nameController.text;
                                  int calorieCount =
                                      int.parse(_calorieCountController.text);
                                  num price = num.parse(_priceController.text);
                                  String description =
                                      _descriptionController.text;
                                  String image = dishPic;
                                  final data = {
                                    'name': name,
                                    'calorieCount': calorieCount,
                                    'price': price,
                                    'image': image,
                                    'cuisineID': 'bLrOvfYsHKrktG2OtK8r',
                                    'restaurantID':
                                        _myFirebaseAuth.getCurrentUser!.uid,
                                    'description': description
                                  };
                                  await FirebaseFirestore.instance
                                      .collection('food')
                                      .doc(randID)
                                      .set(data);
                                  showToast("Dish added successfully!",
                                      Toast.LENGTH_SHORT);
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
                                width: MediaQuery.of(context).size.width * 0.35,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
