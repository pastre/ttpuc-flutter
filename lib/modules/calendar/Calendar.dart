import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:date_utils/date_utils.dart';
import 'package:horariopucpr/modules/calendar/CalendarTile.dart';
import 'package:horariopucpr/modules/calendar/Translator.dart';


typedef DayBuilder(BuildContext context, DateTime day);

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRangeChange;
  final bool isExpandable;
  final DayBuilder dayBuilder;
  final bool showChevronsToChangeRange;
  final bool showTodayAction;
  final bool showCalendarPickerIcon;
  final DateTime initialCalendarDateOverride;
  var eventos;

  Calendar({
    this.onDateSelected,
    this.onSelectedRangeChange,
    this.isExpandable: false,
    this.dayBuilder,
    this.showTodayAction: false,
    this.showChevronsToChangeRange: true,
    this.showCalendarPickerIcon: false,
    this.initialCalendarDateOverride,
    this.eventos,
  });

  @override
  _CalendarState createState() => new _CalendarState();

  List<CalendarEvent> getEvents() {
    List<CalendarEvent>ret = new List<CalendarEvent>();

    for(var i in eventos){
      ret.add(new CalendarEvent(i['nome'], i['descricao'], i['materia'], i['data']));
    }

    return ret;
  }

}

class _CalendarState extends State<Calendar> {
  final calendarUtils = new Utils();

  DateTime today = new DateTime.now();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate;
  Tuple2<DateTime, DateTime> selectedRange;
  String currentMonth;
  bool isExpanded = true;
  String displayMonth;
  DateTime get selectedDate => _selectedDate;

  void initState() {
    super.initState();

    if(widget.initialCalendarDateOverride != null) today = widget.initialCalendarDateOverride;
    selectedMonthsDays = Utils.daysInMonth(today);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
    selectedWeeksDays = Utils
        .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
        .toList()
        .sublist(0, 7);
    _selectedDate = today;
    displayMonth = (Utils.formatMonth(Utils.firstDayOfWeek(today)));
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilded');
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          new ExpansionCrossFade(
            collapsed: calendarGridView,
            expanded: calendarGridView,
            isExpanded: isExpanded,
          ),
          expansionButtonRow
        ],
      ),
    );
  }


  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays =
    isExpanded ? selectedMonthsDays : selectedWeeksDays;

    Utils.weekdays.forEach(
          (day) {
        dayWidgets.add(
          new CalendarTile(
            isDayOfWeek: true,
            dayOfWeek: day,hasEvent: true,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
          (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            new CalendarTile(
              child: this.widget.dayBuilder(context, day),
            ),
          );
        } else {addCalendarTile(day, dayWidgets);
//          if(day.day % 3 == 0){
//            dayWidgets.add(
//              new CalendarTile(
//                onDateSelected: () => handleSelectedDateAndUserCallback(day),
//                date: day,
//                dateStyles: configureDateStyle(monthStarted, monthEnded),
//                isSelected: Utils.isSameDay(selectedDate, day),
//                hasEvent: true,
//              ),
//            );
//          }else {
//            dayWidgets.add(
//              new CalendarTile(
//                onDateSelected: () => handleSelectedDateAndUserCallback(day),
//                date: day,
//                dateStyles: configureDateStyle(monthStarted, monthEnded),
//                isSelected: Utils.isSameDay(selectedDate, day),
//                hasEvent: false,
//              ),
//            );
//          }
        }
      },
    );
    return dayWidgets;
  }

  void addCalendarTile(day, dayWidgets){
    List<CalendarEvent> eventos = widget.getEvents();
    for(CalendarEvent e in eventos){
      print('${day.month} == ${e.data.month} && ${day.day} == ${e.data.day}');
      if(day.month == e.data.month && day.day == e.data.day){
        print('Achei!');
        dayWidgets.add(
          new CalendarTile(
            onDateSelected: () => handleSelectedDateAndUserCallback(day),
            date: day,
            isSelected: Utils.isSameDay(selectedDate, day),
            hasEvent: true,
          ),
        );

        return;
      }
    }
    dayWidgets.add(
      new CalendarTile(
        onDateSelected: () => handleSelectedDateAndUserCallback(day),
        date: day,
        isSelected: Utils.isSameDay(selectedDate, day),
        hasEvent: false,
      ),
    );

  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    if (isExpanded) {
      dateStyles = monthStarted && !monthEnded
          ? new TextStyle(color: Colors.black)
          : new TextStyle(color: Colors.black38);
    } else {
      dateStyles = new TextStyle(color: Colors.black);
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(Utils.fullDayFormat(selectedDate)),
          new IconButton(
            iconSize: 20.0,
            padding: new EdgeInsets.all(0.0),
            onPressed: toggleExpanded,
            icon: isExpanded
                ? new Icon(Icons.arrow_drop_up)
                : new Icon(Icons.arrow_drop_down),
          ),
        ],
      );
    } else {
      return new Container();
    }
  }

  Widget get nameAndIconRow {
    var leftInnerIcon;
    var rightInnerIcon;
    var leftOuterIcon;
    var rightOuterIcon;
    if (widget.showCalendarPickerIcon) {
      rightInnerIcon = new IconButton(
        onPressed: () => selectDateFromPicker(),
        icon: new Icon(Icons.calendar_today),
      );
    } else {
      rightInnerIcon = new Container();
    }

    if (widget.showChevronsToChangeRange) {
      leftOuterIcon = new IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: new Icon(Icons.chevron_left),
      );
      rightOuterIcon = new IconButton(
        onPressed: isExpanded ? nextMonth : nextWeek,
        icon: new Icon(Icons.chevron_right),
      );
    } else {
      leftOuterIcon = new Container();
      rightOuterIcon = new Container();
    }

    if (widget.showTodayAction) {
      leftInnerIcon = new InkWell(
        child: new Text('Today'),
        onTap: resetToToday,
      );
    } else {
      leftInnerIcon = new Container();
    }

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftOuterIcon ?? new Container(),
        leftInnerIcon ?? new Container(),
        new Text(
          displayMonth,
          style: new TextStyle(
            fontSize: 20.0,
          ),
        ),
        rightInnerIcon ?? new Container(),
        rightOuterIcon ?? new Container(),
      ],
    );
  }

  Widget get calendarGridView {
    return new Container(
      child: new GestureDetector(
        onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
        onHorizontalDragUpdate: (gestureDetails) =>
            getDirection(gestureDetails),
        onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),

        child: new GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          childAspectRatio: 0.9,
          mainAxisSpacing: 0.0,
          children: calendarBuilder(),
        ),
      ),
    );
  }

  void resetToToday() {
    today = new DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);

    setState(() {
      _selectedDate = today;
      selectedWeeksDays = Utils
          .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList();
      displayMonth =(Utils.formatMonth(Utils.firstDayOfWeek(today)));
    });

    _launchDateSelectionCallback(today);
  }

  void nextMonth() {
    setState(() {
      today = Utils.nextMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void previousMonth() {
    setState(() {
      today = Utils.previousMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void nextWeek() {
    setState(() {
      today = Utils.nextWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays = Utils
          .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList()
          .sublist(0, 7);
      displayMonth = (Utils.formatMonth(Utils.firstDayOfWeek(today)));
    });
  }

  void previousWeek() {
    setState(() {
      today = Utils.previousWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays = Utils
          .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList()
          .sublist(0, 7);
      displayMonth = (Utils.formatMonth(Utils.firstDayOfWeek(today)));
    });
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    selectedRange = new Tuple2<DateTime, DateTime>(start, end);
    if (widget.onSelectedRangeChange != null) {
      widget.onSelectedRangeChange(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );



    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);


      setState(() {
        _selectedDate = selected;
        selectedWeeksDays = Utils
            .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList();
        selectedMonthsDays = Utils.daysInMonth(selected);
        displayMonth = (Utils.formatMonth(Utils.firstDayOfWeek(today)));
      });

      _launchDateSelectionCallback(selected);
    }
  }

  var gestureStart;
  var gestureDirection;
  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      if (isExpanded) {
        nextMonth();
      } else {
        nextWeek();
      }
    } else {
      if (isExpanded) {
        previousMonth();
      } else {
        previousWeek();
      }
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      _selectedDate = day;
      selectedWeeksDays = Utils
          .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList();
      selectedMonthsDays = Utils.daysInMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      flex: 1,
      child: new AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class CalendarEvent{
  String nome, descricao, materia;
  DateTime data;

  CalendarEvent(nome, descricao, materia, data){
    this.nome = nome;
    this.descricao = descricao;
    this.materia = materia;
    this.data = DateTime.fromMillisecondsSinceEpoch(data);
  }

  @override
  String toString(){
    return "$data, $materia, $descricao, $nome";
  }
}