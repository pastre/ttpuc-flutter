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
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    print("Selected ${this.isSelected} $date");
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
        onTap: onDateSelected,
        child: new Container(
          decoration: isSelected
              ? new BoxDecoration(
//            shape: BoxShape.circle,
//            color: Colors.grey,
//            gradient: RadialGradient(colors: <Color>[Colors.grey, Colors.white], radius: 0.2)
          )
              : new BoxDecoration(),
          alignment: Alignment.center,
          child: new Text(
            Utils.formatDay(date).toString(),
            style: isSelected ? new TextStyle(color: PUC_COLOR) : dateStyles,
//            style: isSelected ? new TextStyle(color: Colors.white) : dateStyles,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
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