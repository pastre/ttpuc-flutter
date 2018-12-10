
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Container(child: Center(
        child: SpinKitThreeBounce(
            color: Colors.grey)
        ,),color: Colors.white,
    );


  }

}