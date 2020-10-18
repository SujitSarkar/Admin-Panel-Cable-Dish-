import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

customLoadingBar(){
  return Container(
    alignment: Alignment.center,
    child: SpinKitThreeBounce(
      color: Colors.white,
      size: 50.0,
    ),
  );
}

greenLoadingBar(){
  return Container(
    alignment: Alignment.center,
    child: SpinKitThreeBounce(
      color: Colors.green,
      size: 50.0,
    ),
  );
}