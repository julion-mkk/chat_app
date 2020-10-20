import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/screens/chat_rooms.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
    final Function toggle;
    SignUp(this.toggle);
    SignUpState createState()=> SignUpState();
}

class SignUpState extends State<SignUp> {

    AuthMethods authMethods= new AuthMethods();
    DataBaseMethod dataBaseMethod= new DataBaseMethod();
    bool loading = false;
    final formKey= GlobalKey<FormState>();
    TextEditingController usernameController= new TextEditingController();
    TextEditingController emailController= new TextEditingController();
    TextEditingController passwordController= new TextEditingController();

    signMeUp() {
        if(formKey.currentState.validate()) {
            setState(() {
                loading = true;
            });
            authMethods.signUpWithEmailAndPassword(emailController.text, passwordController.text).then((value) => print(value.userId));

            HelperFunctions.savedUserLoggedInSharedPreference(true);
            HelperFunctions.savedUsernameSharedPreference(usernameController.text);
            HelperFunctions.savedEmailSharedPreference(emailController.text);


            Map<String, String> userMap = {
                'name' : usernameController.text,
                'email' : emailController.text
            };
            dataBaseMethod.uploadUserInfo(userMap);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=> ChatRoom()
            ));
        }
    }

    Widget build(BuildContext context) {
        return Scaffold(
            appBar: appBarMain(),
            body: loading? Container(
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
                                                validator: (value) {
                                                    return value.isEmpty || value.length < 4 ?'username must be more than 4 words' : null;
                                                },
                                                controller: usernameController,
                                                style: simpleTextStyle(),
                                                decoration: textFieldInputDecoration('Username'),
                                            ),
                                            SizedBox(
                                                height: 8,
                                            ),
                                            TextFormField(
                                                validator: (value) {
                                                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ? null : 'please insert email';
                                                },
                                                controller: emailController,
                                                style: simpleTextStyle(),
                                                decoration: textFieldInputDecoration('Email'),
                                            ),
                                            SizedBox(
                                                height: 8,
                                            ),
                                            TextFormField(
                                                validator: (value) {
                                                    return value.length < 5 ? 'password must be more than 5 words' : null;
                                                },
                                                controller: passwordController,
                                                obscureText: true,
                                                style: simpleTextStyle(),
                                                decoration: textFieldInputDecoration('Password'),
                                            ),
                                        ],
                                    ),
                                ),
                                SizedBox(
                                    height: 18,
                                ),
                                Container(
                                    alignment: Alignment.centerRight,
                                    child: Text('Forgot password?',style: simpleTextStyle(),),
                                ),
                                SizedBox(
                                    height: 20,
                                ),
                                GestureDetector(
                                    onTap: () {
                                        signMeUp();
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
                                        child: Text('Sign up',style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16
                                        ),),
                                    ),
                                ),
                                SizedBox(
                                    height: 20,
                                ),
                                Container(
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
                                SizedBox(height: 20,),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        Text("Already have the account?  ", style: simpleTextStyle(),),
                                        GestureDetector(
                                            onTap: () {
                                                widget.toggle();
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                child: Text("Sign up now", style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    decoration: TextDecoration.underline
                                                    ),
                                                ),
                                            ),
                                        )

                                    ],
                                )
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}