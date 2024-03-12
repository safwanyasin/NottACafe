import 'package:flutter/material.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_components/auth_textfield.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_functions/user_responses.dart';
import 'package:nottacafe/styles/assets.dart';
import 'package:nottacafe/styles/text_styles.dart';

class ForgotPassword extends StatefulWidget {
  
  const ForgotPassword({
    Key? key
  }) : super(key: key);

  static const String routeName = "/forgotPassword";

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  late bool _containsErrors;
  late GlobalKey<FormState> _forgotPasswordFormKey;
  late TextEditingController _emailController;
  late MyFirebaseAuth _myFirebaseAuth;

  @override
  void initState() {
    
    super.initState();
    _containsErrors = false;
    _forgotPasswordFormKey = GlobalKey<FormState> ();
    _emailController = TextEditingController();
    _myFirebaseAuth = MyFirebaseAuth();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    AppAssets.nottinghamBackground
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.70), 
                    BlendMode.darken
                  ),
                )                
              ),
              child: _forgotPassword(),
            ),
          ),
        )
      ),
    );
  }

  Widget _forgotPassword() {
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 150.0),
        child: Form(
          key: _forgotPasswordFormKey,
          autovalidateMode: _containsErrors ? 
            AutovalidateMode.always 
            : null,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 30),
                child: const Text(
                  "We will send you an email with a link to reset your password. Please enter the email associated with your account below.",
                  style: AppTextStyles.desriptionWhite,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 30),
                child: AuthTextfield(
                  hintText: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  textEditingController: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "Please enter a valid email.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RoundedButton(
                        buttonText: "Back", 
                        buttonColor: Theme.of(context).colorScheme.secondaryContainer, 
                        buttonTextStyle: AppTextStyles.buttonTextBlue, 
                        onTap: () {
                          Navigator.maybePop(context);
                        },
                       
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 20,),
                    Expanded(
                      flex: 1,
                      child: RoundedButton(
                        buttonText: "Send", 
                        buttonColor: Theme.of(context).colorScheme.primary, 
                        buttonTextStyle: AppTextStyles.buttonTextWhite, 
                        onTap: () async {
                          if (_forgotPasswordFormKey.currentState!.validate()) {
                            await _myFirebaseAuth.requestPasswordReset(_emailController.text).then((response) {
                              if (response == null) {
                                showSnackBar(
                                  context, 
                                  "An email with the password reset link has been sent to ${_emailController.text}. Please check your inbox and spam.", 
                                  Theme.of(context).colorScheme.primaryContainer, 
                                  const Duration(seconds: 5),
                                );
                                Future.delayed(const Duration(seconds: 6), () {
                                  Navigator.maybePop(context);
                                });
                              }
                              else {
                                showSnackBar(
                                  context, 
                                  "Error: The email entered is not associated with any existing account. Please recheck the email and try again.", 
                                  Theme.of(context).colorScheme.error, 
                                  const Duration(seconds: 3),
                                );
                              }
                            });
                          }
                          else {
                            setState(() {
                              _containsErrors = true;
                            });
                          }
                        },
                        
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}