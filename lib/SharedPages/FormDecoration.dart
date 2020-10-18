import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    hintText: 'গ্রাহকের নাম',
    fillColor: Colors.white60,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.green,
          width: 2.0,
        )),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.green,
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        )),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2.0,
      ),
    ));

const modalDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
    bottomLeft: Radius.circular(10.0),
    bottomRight: Radius.circular(10.0),
  ),
);