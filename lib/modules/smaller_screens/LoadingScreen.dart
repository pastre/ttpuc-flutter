
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget{

  String message;
  Color bgColor;
  LoadingWidget({this.message, this.bgColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(
        child:Column(children: <Widget>[
          SpinKitThreeBounce(
              color: Colors.grey),
          this.message != null ? Text(this.message, style: TextStyle(color: Colors.grey),) : SizedBox(height: 1.0, width: 1.0,),
        ], mainAxisAlignment: MainAxisAlignment.center,), ),color: bgColor,
    );
  }
}