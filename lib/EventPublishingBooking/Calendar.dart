import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:async';
import 'dart:convert';
import './EventByDate.dart';

class Calendar extends StatefulWidget {
  //optional
  Calendar({Key key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  List data;
  EventList<Event> _markedDateMap = new EventList<Event>();
  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8080/findAllEvents"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      data = jsonDecode(response.body);
    });
    //Add data to calendar _markedDateMap
    for (int i = 0; i < data.length; i++) {
      _markedDateMap.add(
          new DateTime(
              data == null ? 0 : int.parse(data[i]["date"].substring(0, 4)),
              data == null ? 0 : int.parse(data[i]["date"].substring(5, 7)),
              data == null ? 0 : int.parse(data[i]["date"].substring(8, 10))),
          new Event(
            date: DateTime(
                data == null ? 0 : int.parse(data[i]["date"].substring(0, 4)),
                data == null ? 0 : int.parse(data[i]["date"].substring(5, 7)),
                data == null ? 0 : int.parse(data[i]["date"].substring(8, 10))),
            title: data == null ? "wait" : data[i]["name"],
            //title: data[0]["name"],
            icon: _eventIcon,
          ));
    }
    return "success!";
  }

  //Icon
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.cyan, width: 5.0)),
    child: new Icon(
      Icons.event,
      color: Colors.black,
    ),
  );

  @override
  void initState() {
    this.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      //Today
      todayBorderColor: Colors.green,
      todayTextStyle: TextStyle(color: Theme.of(context).primaryColor),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(color: Colors.yellow),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle:
          TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      //inactiveDaysTextStyle: TextStyle(color: Colors.cyan, fontSize: 16),

      showHeader: true,
      headerTextStyle:
          TextStyle(fontSize: 35, color: Theme.of(context).primaryColor),
      //Header
      weekDayBackgroundColor: Colors.white,
      weekdayTextStyle: TextStyle(fontSize: 20, color: Colors.black),
      weekFormat: false,

      //Days
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: false,
      dayButtonColor: Colors.transparent,
      daysTextStyle:
          TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
      weekendTextStyle:
          TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
      thisMonthDayBorderColor: Colors.grey,
      markedDatesMap: _markedDateMap,
      height: 440.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),

      //Event days
      markedDateCustomTextStyle: TextStyle(fontSize: 30, color: Colors.red),
      markedDateShowIcon: true,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      //markedDateMoreShowTotal: true,

      //Action
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EventByDate(date: date.toString().substring(0, 10));
        }));
      },
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return new Scaffold(
        //backgroundColor: Colors.black38,
        appBar: new AppBar(
          title: new Text("Event Calendar"),
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
