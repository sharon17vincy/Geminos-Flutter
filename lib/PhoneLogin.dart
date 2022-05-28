import 'dart:ui';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geminos_group/HomePage.dart';
import 'package:geminos_group/Theme.dart';
import 'package:geminos_group/Widgets/SolidButton.dart';
import 'package:geminos_group/mixins/loading.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    "https://www.googleapis.com/auth/userinfo.profile"

  ],
);

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  _LoginWithPhoneState createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> with LoadingStateMixin{
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  late AnimationController _controller;

  bool otpVisibility = false;

  String verificationID = "";
  String phoneNo = "";
  String countryCode = "+971";
  bool bOtp = false;
  bool mobileVerification = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _1 = TextEditingController();
  final TextEditingController _2 = TextEditingController();
  final TextEditingController _3 = TextEditingController();
  final TextEditingController _4 = TextEditingController();
  final TextEditingController _5 = TextEditingController();
  final TextEditingController _6 = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white,),
      ),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: appTheme.accentColor,
        disabledTextColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }



  Widget phoneLogin() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
        color: Colors.black.withOpacity(0.5),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.white24,
            blurRadius: 5.0,
            offset: Offset(5.0, 5.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          !bOtp
              ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/logo (2).png', width: 50, height: 50, ),
                      SizedBox(width: 8,),
                      Image.asset('assets/images/name.png', width: 140, height: 140, ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 50,
                      // width: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: borderColor),
                        boxShadow: const [
                          BoxShadow(
                            color: borderColor,
                            // spreadRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: CountryCodePicker(
                        hideMainText: false,
                        showDropDownButton: true,
                        onChanged: (code) {
                          print(code);
                          countryCode = code.toString();
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        showCountryOnly: true,
                        showFlag: true,
                        hideSearch: false,
                        textStyle: TextStyle(fontSize: 15, color: Colors.black),
                        showFlagDialog: true,
                        initialSelection: countryCode,
                        dialogSize: Size(300, 600),
                        padding: EdgeInsets.only(left: 0, right: 0),
                        barrierColor: Colors.transparent,
                        dialogBackgroundColor: Colors.white,
                        boxDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 4, left: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.1,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: borderColor),
                          boxShadow: const [
                            BoxShadow(
                              color: borderColor,
                              // spreadRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter mobile number',
                                hintStyle: TextStyle(fontSize: 14)),
                            onChanged: (value) {
                              setState(() {
                                bOtp = false;
                                // _phoneController.text = countryCode + value;
                                this.phoneNo = countryCode + value;
                                print(phoneNo);
                                print('***********');
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40,),

            ],
          ),
              )
              : Column(
            children: [
              Text(
                "Verification Code",
                style: titleNormalBoldStyle.copyWith(color: Colors.white),
              ),
              SizedBox(height: 16,),
              Text(
                "Type the verfication code we have sent you",
                style: normalStyle.copyWith(fontWeight: FontWeight.w300, color: Colors.white),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: otpView(),
              ),
              SizedBox(height: 40,),

            ],
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                  onTap: () async {
                    print(this.phoneController.text);
                    {
                      setState(()  {
                        if (!bOtp) {
                          print(countryCode);
                          print(phoneNo);
                          sendOTP();
                        } else {
                          var otp = _1.text +
                              _2.text +
                              _3.text +
                              _4.text +
                              _5.text +
                              _6.text;
                          verifyOTP(otp);
                        }
                      });
                    }
                  },
                  child: SolidButton(title : bOtp ? "VERIFY" : "SEND OTP", loading: loading, width: MediaQuery.of(context).size.width/2, solid: true,onTap: (){},))
          ),
        ],
      ),
    );
  }

  Widget otpView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        otpBox(1, _1),
        otpBox(2, _2),
        otpBox(3, _3),
        otpBox(4, _4),
        otpBox(5, _5),
        otpBox(6, _6),
      ],
    );
  }

  Widget otpBox(int val, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              // spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            maxLength: 1,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: "",
              // border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 8, bottom: 10),
              hintText: '',
            ),
            onChanged: (value) {
              print(val);
              setState(() {
                if (val == 1) {
                  _1.text = value;
                  value != ""
                      ? FocusScope.of(context).nextFocus()
                      : FocusScope.of(context).unfocus();
                  // FocusScope.of(context).previousFocus();
                } else if (val == 2) {
                  _2.text = value;
                  value != ""
                      ? FocusScope.of(context).nextFocus()
                      : FocusScope.of(context).previousFocus();
                } else if (val == 3) {
                  _3.text = value;
                  value != ""
                      ? FocusScope.of(context).nextFocus()
                      : FocusScope.of(context).previousFocus();
                }
                if (val == 4) {
                  _4.text = value;
                  value != ""
                      ? FocusScope.of(context).nextFocus()
                      : FocusScope.of(context).previousFocus();
                } else if (val == 5) {
                  _5.text = value;
                  value != ""
                      ? FocusScope.of(context).nextFocus()
                      : FocusScope.of(context).previousFocus();
                } else if (val == 6) {
                  _6.text = value;
                  value != ""
                      ? FocusScope.of(context).unfocus()
                      : FocusScope.of(context).previousFocus();

                  // FocusScope.of(context).hasFocus;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage ('assets/images/wall.jpg',
      )
      ),),
        child: !mobileVerification ? phoneLogin() :
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            shape: BoxShape.rectangle,
            color: Colors.black.withOpacity(0.5),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.white24,
                blurRadius: 5.0,
                offset: Offset(5.0, 5.0),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: (){
              _handleSignIn();
            },
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  // color: Color(0xffEEF6F2)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              SolidButton(title : "Connect to Google Account", loading: loading, width: MediaQuery.of(context).size.width/1.5, solid: true,onTap: (){},)

          ],
              ),
            ),
          ),
        ))
    );
  }

  void signOut() {
    // Firebase sign out
    _googleSignIn.signOut();
  }


  Future<void> _handleSignIn() async {
    setLoading(true);
    try {
      signOut();

      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        print(googleSignInAuthentication.accessToken);
        print(googleSignInAuthentication.idToken);

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await auth.signInWithCredential(credential);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userCredential)));
          print(userCredential.user);
          setLoading(false);
        } on FirebaseAuthException catch (e) {
          setLoading(false);
          print(e);
         showSnackBar(e);
        } catch (e) {
          setLoading(false);
          print(e);
          showSnackBar(e);
        }
      }
    } catch (error) {
      print(error);
      setLoading(false);
      showSnackBar(error);
    }
  }

  void sendOTP() async {
    setLoading(true);
    auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value){
          print("logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        setLoading(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setLoading(false);
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {
          bOtp = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );
  }

  void verifyOTP(String otp) async {

    setLoading(true);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otp);

    await auth.signInWithCredential(credential).then((value){
      print("logged in successfully");
      setLoading(false);
      mobileVerification = true;
    }).catchError((error)
    {
      print(error);
      setLoading(false);
      showSnackBar(error);
    });
  }
}