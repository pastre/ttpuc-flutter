import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import 'package:horariopucpr/modules/calendar/Translator.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback onDateSelected;
  final DateTime date;
  final String dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final bool hasEvent;
  final TextStyle dayOfWeekStyles;
  final TextStyle dateStyles;
  final Widget child;

  Translator t = new Translator();

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek: false,
    this.isSelected: false,
    this.hasEvent: false,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
//    print("Selected ${this.isSelected} $date");
    if (isDayOfWeek) {
      return new InkWell(
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            t.translateDay(dayOfWeek),
            style: dayOfWeekStyles,
          ),
        ),
      );
    } else {
      return new InkWell(
        highlightColor: Colors.cyan,
        onTap: onDateSelected,
        child: this.buildContainer(),

      );
    }
  }

  Widget buildContainer(){
    var list = hasEvent? <Widget>[
      Positioned(child:this.buildChild(), ),
      Positioned(right: 8.0, top: -0.0,child: new Icon(Icons.brightness_1, size: 8.0, color: Colors.green), )
    ] :
      <Widget>[Positioned(child:this.buildChild(), ),];
    return new Container(
        alignment: Alignment.center,
        child: Stack(fit: StackFit.expand, children: list,)
     );


  }

  Widget buildChild(){
    return new Text(
      Utils.formatDay(date).toString(),
      style: isSelected ?
      new TextStyle(color: PUC_COLOR,) :
      hasEvent?
      new TextStyle(
        decorationColor: Colors.orange,
      )
          :dateStyles,
      textAlign: TextAlign.center,
    );

  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return child;
    }
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: renderDateOrDayOfWeek(context),
    );
  }
}