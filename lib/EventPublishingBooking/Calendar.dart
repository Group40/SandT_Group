import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class Calendar extends StatefulWidget {
  //optional
  Calendar({Key key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime(2019, 2, 3);
  DateTime _currentDate2 = DateTime(2019, 2, 3);
  String _currentMonth = DateFormat.yMMM().format(DateTime(2019, 2, 3));
  DateTime _targetDateTime = DateTime(2019, 2, 3);

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
//        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.cyan, width: 5.0)),
    child: new Icon(
      Icons.event,
      color: Colors.black,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2019, 2, 10): [
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        new DateTime(2019, 2, 25),
        new Event(
          date: new DateTime(2019, 2, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime(2019, 2, 10),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(new DateTime(2019, 2, 11), [
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      //Today
      todayBorderColor: Colors.green,
      todayTextStyle: TextStyle(color: Colors.blue),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(color: Colors.yellow),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(fontSize: 16, color: Colors.cyan),
      //inactiveDaysTextStyle: TextStyle(color: Colors.cyan, fontSize: 16),

      showHeader: true,
      headerTextStyle: TextStyle(fontSize: 35, color: Colors.cyan),
      //Header
      weekDayBackgroundColor: Colors.white,
      weekdayTextStyle: TextStyle(fontSize: 20, color: Colors.black),
      weekFormat: false,

      //Days
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: false,
      dayButtonColor: Colors.transparent,
      daysTextStyle: TextStyle(fontSize: 20, color: Colors.cyan),
      weekendTextStyle: TextStyle(fontSize: 20, color: Colors.cyan),
      thisMonthDayBorderColor: Colors.grey,
      markedDatesMap: _markedDateMap,
      height: 440.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),

      //Event days
      markedDateCustomTextStyle: TextStyle(fontSize: 30, color: Colors.red),
      markedDateShowIcon: true,
      markedDateIconBuilder: (event){return event.icon;},
      //markedDateMoreShowTotal: true,

      //Action
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },
      onCalendarChanged: (DateTime date){
        this.setState((){
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date){print('long pressed date $date');},
    );

    return new Scaffold(
        //backgroundColor: Colors.black38,
        appBar: new AppBar(
          title: new Text("Cale"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 40.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ), //
            ],
          ),
        ));
  }
}
