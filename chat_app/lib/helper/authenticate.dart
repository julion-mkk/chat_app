import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/screens/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
    AuthenticateState createState()=> AuthenticateState();
}

class AuthenticateState extends State<Authenticate> {

    bool showSignIn= true;

    void toggleView() {
        setState(() {
          showSignIn = !showSignIn;
        });
    }

    Widget build(BuildContext context) {
        if(showSignIn)
            return SignIn(toggleView);
        else
            return SignUp(toggleView);
    }
}