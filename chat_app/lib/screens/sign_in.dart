import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'chat_rooms.dart';

class SignIn extends StatefulWidget {
    final Function toggle;
    SignIn(this.toggle);
    SignInState createState()=> SignInState();
}

class SignInState extends State<SignIn> {
    final formKey= GlobalKey<FormState>();
    QuerySnapshot snapShotUserInfo;
    DataBaseMethod dataBaseMethod = new DataBaseMethod();
    TextEditingController emailController= new TextEditingController();
    TextEditingController passwordController= new TextEditingController();
    AuthMethods _authMethods= new AuthMethods();
    bool isLoading= false;
    signIn() async {
        if(formKey.currentState.validate()) {
            setState(() {
              isLoading = true;
            });
            
             await dataBaseMethod.getUserByEmail(emailController.text).then((value) {
                snapShotUserInfo = value;
                print(value);
            });



            await _authMethods.signInWithEmailAndPassword(emailController.text, passwordController.text).then((value){
                if(value != null) {
                    HelperFunctions.savedUserLoggedInSharedPreference(true);
                    print(snapShotUserInfo.documents);
                    HelperFunctions.savedUsernameSharedPreference(snapShotUserInfo.documents[0].data['name']);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context)=> ChatRoom()
                    ));
                }

                else {
                    setState(() {
                        isLoading = false;
                    });
                    flushBar(context);
                }
            });


        }
    }

    flushBar(BuildContext context) {
        Flushbar(
            message: "Username or password is wrong, Try again",
            duration: Duration(seconds: 3),
            flushbarPosition: FlushbarPosition.BOTTOM,
        )..show(context);
    }
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: appBarMain(),
            body: isLoading? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
            ) : SingleChildScrollView(
                child: Container(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Form(
                                    key: formKey,
                                    child: Column(
                                        children: <Widget>[
                                            TextFormField(
                                                style: simpleTextStyle(),
                                                decoration: textFieldInputDecoration('Email'),
                                                controller: emailController,
                                                validator: (value) {
                                                    return value.isEmpty || value.length < 4 ?'username must be more than 4 words' : null;
                                                },
                                            ),
                                            SizedBox(
                                                height: 8,
                                            ),
                                            TextFormField(
                                                obscureText: true,
                                                style: simpleTextStyle(),
                                                decoration: textFieldInputDecoration('Password'),
                                                controller: passwordController,
                                                validator: (value) {
                                                    return value.length < 5 ? 'password must be more than 5 words' : null;
                                                },
                                            ),
                                        ],
                                    ),
                                ),
                                SizedBox(
                                    height: 18,
                                ),
                                /*Container(
                                    alignment: Alignment.centerRight,
                                    child: Text('Forgot password?',style: simpleTextStyle(),),
                                ),
                                SizedBox(
                                    height: 20,
                                ),*/
                                GestureDetector(
                                    onTap: () {
                                        signIn();
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                    Color(0xff007EF4),
                                                    Color(0xff2A75BC)
                                                ]
                                            ),
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Text('Sign in',style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16
                                        ),),
                                    ),
                                ),
                                SizedBox(
                                    height: 20,
                                ),
                                /*Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text('Sign in with google',style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16
                                    ),),
                                ),
                                SizedBox(height: 20,),*/
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        Text("Don't have the account?  ", style: simpleTextStyle(),),
                                        GestureDetector(
                                            onTap: () {
                                                widget.toggle();
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                child: Text("Register now", style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    decoration: TextDecoration.underline
                                                    ),
                                                ),
                                            )
                                        ),

                                    ],
                                )
                            ],
                        ),
                    ),
                ),
            )
        );
    }
}