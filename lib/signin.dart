import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'Components/validate.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => new SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  TextEditingController emailInputController =
      new TextEditingController(text: "public1@gmail.com");
  TextEditingController passInputController =
      new TextEditingController(text: "123456789");
  var spinkit;

  @override
  void initState() {
    super.initState();
    // sendNotification();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    spinkit = SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: deviceSize.width, maxHeight: deviceSize.height),
        designSize: Size(deviceSize.width, deviceSize.height),
        allowFontScaling: false);

    return new LoadingOverlay(
      child: SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              resizeToAvoidBottomPadding: false,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  deviceSize.width * 0.01,
                                  deviceSize.height * 0.2,
                                  0.0,
                                  0.0),
                              child: SafeArea(
                                child: Container(
                                    width: deviceSize.width * 0.19,
                                    height: deviceSize.width * 0.19,
                                    decoration: BoxDecoration(
                                        // color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: Image.asset('assets/logo.png')),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  deviceSize.width * 0.025,
                                  deviceSize.height * 0.17,
                                  0.0,
                                  0.0),
                              child: Text('GiveLife',
                                  style: TextStyle(
                                    fontSize: 52.ssp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Courgette',
                                  )),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(deviceSize.width * 0.42,
                              deviceSize.height * 0.26, 0.0, 0.0),
                          child: Text('Small Action, BIG Change!',
                              style: TextStyle(
                                  fontSize: 13.ssp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          top: deviceSize.height * 0.06,
                          left: deviceSize.width * 0.05,
                          right: deviceSize.width * 0.05),
                      child: Form(
                          key: loginFormKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                validator: emailValidator,
                                controller: emailInputController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'EMAIL',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                              ),
                              SizedBox(height: 0.022.sh),
                              TextFormField(
                                controller: passInputController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'PASSWORD',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                                obscureText: true,
                              ),
                              SizedBox(height: 0.022.sh),
                              Container(
                                alignment: Alignment(1.0, 0.0),
                                padding: EdgeInsets.only(
                                    top: 0.025.sh, left: 0.020.sw),
                                child: InkWell(
                                  onTap: () {
                                    showReset();
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.040.sh),
                              Container(
                                  height: 0.05.sh,
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (loginFormKey.currentState
                                          .validate()) {
                                        checkLogin(context);
                                      }
                                    },
                                    child: Material(
                                      borderRadius: BorderRadius.circular(18.r),
                                      shadowColor: Colors.greenAccent,
                                      color: Color(0xFF4CAF50),
                                      elevation: 7.0,
                                      child: Center(
                                        child: Text(
                                          'LOGIN',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 0.020.sh),
                            ],
                          ))),
                  SizedBox(height: 0.025.sh),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'New to GiveAway ?',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      SizedBox(width: 0.03.sw),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ))),
      isLoading: isLoading,
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
    );
  }

  Future checkLogin(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Firebase.initializeApp();
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailInputController.text,
              password: passInputController.text)
          .then((value) async {
        // print("LOGIN SUCESS :");
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((onError) {
        print("Login Error : ${onError.message} ");
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Invalid User Credential")));
        emailInputController.clear();
        passInputController.clear();
        if (this.mounted)
          setState(() {
            isLoading = false;
          });
      });
    } catch (e) {
      print("Error ${e.message}");
    }
  }

  void showReset() {
    TextEditingController emailresetController = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: 0.33.sw,
              height: 0.15.sh,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailresetController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'example@gmail.com',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 0.02.sh,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(25.r),
                    color: Colors.white,
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Firebase.initializeApp();
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailresetController.text);
                      },
                      padding: EdgeInsets.fromLTRB(
                          0.010.sw, 0.015.sh, 0.010.sw, 0.015.sh),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            fontSize: 20.ssp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
