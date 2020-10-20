import 'package:flutter/material.dart';

Widget appBarMain() {
    return AppBar(
        title: Image.asset('assets/images/logo.png', height: 40,),
    );
}

InputDecoration textFieldInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.white54,
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
        )
    );
}

TextStyle simpleTextStyle() {
    return TextStyle(
        color: Colors.white,
        fontSize: 16,
    );
}