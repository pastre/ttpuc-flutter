
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget{

  String message;

  LoadingWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(
        child:Column(children: <Widget>[
          SpinKitThreeBounce(
              color: Colors.grey),
          this.message != null ? Text(this.message, style: TextStyle(color: Colors.grey),) : null,
        ], mainAxisAlignment: MainAxisAlignment.center,), ),color: Colors.white,
    );
  }
}