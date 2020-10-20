import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/screens/chat_rooms.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
    //SharedPreferences.setMockInitialValues({});
    runApp(MyApp());
}

class MyApp extends StatefulWidget {
    MyAppState createState()=> MyAppState();
}

class MyAppState extends State<MyApp> {

    bool userLogin = false;

    void initState() {
        super.initState();
        getLoginState();
    }

    getLoginState() async{
        await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            setState(() {
                if(value != null)
                    userLogin = value;
                else
                    userLogin = false;
            });
        });
    }
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                scaffoldBackgroundColor: Color(0xff1F1F1F),
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: userLogin != null? userLogin ?  ChatRoom() : Authenticate() : Authenticate(),
        );
    }
}
