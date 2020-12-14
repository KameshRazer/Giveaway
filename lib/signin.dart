import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'components/validate.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => new SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController passInputController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
                        child: Text('Give',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 105.0, 0.0, 0.0),
                        child: Text('Away',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(210.0, 175.0, 0.0, 0.0),
                        child: Text('Small Action, BIG Change!',
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                      )
                    ],
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
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
                            SizedBox(height: 20.0),
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
                            SizedBox(height: 5.0),
                            Container(
                              alignment: Alignment(1.0, 0.0),
                              padding: EdgeInsets.only(top: 15.0, left: 20.0),
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
                            SizedBox(height: 40.0),
                            Container(
                                height: 40.0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (loginFormKey.currentState.validate()) {
                                      checkLogin();
                                    }
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.greenAccent,
                                    color: Colors.green,
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
                            SizedBox(height: 20.0),
                          ],
                        ))),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to GiveAway ?',
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 5.0),
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
            )));
  }

  Future checkLogin() async {
    try {
      await Firebase.initializeApp();
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailInputController.text,
              password: passInputController.text)
          .then((value) async {
        print("LOGIN SUCESS :");
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((onError) {
        print("Login Error : ${onError.message} ");
        emailInputController.clear();
        passInputController.clear();
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
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 5,
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
                    height: 10.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Firebase.initializeApp();
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailresetController.text);
                      },
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            fontSize: 20.0,
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
