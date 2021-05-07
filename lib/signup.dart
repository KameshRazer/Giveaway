import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'Components/validate.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupPage> {
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
  TextEditingController phoneNoInputController = new TextEditingController();
  TextEditingController nameInputController = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 90.0, 0.0, 0.0),
                  child: Text(
                    'Register',
                    style:
                        TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(310.0, 95.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Form(
                key: signupFormKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'NAME ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: nameInputController,
                      validator: nameValidator,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),

                          // hintStyle: ,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: emailInputController,
                      validator: emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Phone No ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      controller: phoneNoInputController,
                      validator: phoneNoValidator,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      obscureText: true,
                      controller: pwdInputController,
                      validator: pwdValidator,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      height: 40.0,
                      child: GestureDetector(
                          onTap: () async {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if (signupFormKey.currentState.validate()) {
                              await Firebase.initializeApp();
                              try {
                                UserCredential user = await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                        email: emailInputController.text,
                                        password: pwdInputController.text);
                                CollectionReference users = FirebaseFirestore
                                    .instance
                                    .collection('users');
                                users
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .set({
                                  'Email': emailInputController.text,
                                  'Password': pwdInputController.hashCode,
                                  'Name': nameInputController.text,
                                  'type': "Public",
                                  'Contact': phoneNoInputController.text
                                }).then((value) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home');
                                }).catchError((err) =>
                                        print("Failed to add user: $err"));
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  print("SignUp : Email already In use");
                                  scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Email already Registered")));
                                  emailInputController.clear();
                                }
                              } catch (e) {
                                // print("SignUp : $e");
                              }
                            }
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.green,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'SIGNUP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text('Go Back',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
  }
}
