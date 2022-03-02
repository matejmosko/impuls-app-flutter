import 'package:flutter/material.dart';
import 'package:impuls/pages/EventDetailPage.dart';
import 'package:impuls/providers/AppSettings.dart';
import 'package:impuls/providers/EventsProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:impuls/models/Event.dart';



class CalendarView extends StatefulWidget {
  CalendarView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.utc(2022, 8, 29); // DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart = DateTime.utc(2022, 8, 29);
  DateTime _rangeEnd = DateTime.utc(2022, 9, 4);
  AnimationController _animationController;
 // List events;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_fetchEvents(_selectedDay));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  List<Event> _fetchEvents(DateTime day) {
    EventsProvider eventsProvider =
        Provider.of<EventsProvider>(context, listen: false);
    final events = eventsProvider.events;
    return events.where((event) {
      return event.startTime.year == day.year &&
          event.startTime.month == day.month &&
          event.startTime.day == day.day;
    }).toList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      setSelectedDay(selectedDay);
    });
    _fetchEvents;
  }

  void setSelectedDay(DateTime day) {
    final EventsProvider eventsProvider =
        Provider.of<EventsProvider>(context, listen: false);
    eventsProvider.setSelectedDay(day);
  }



/*  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    fetchEvents(context);
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          child: _buildTableCalendarWithBuilders(),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 1.0, // has the effect of softening the shadow
                spreadRadius: 5.0, // has the effect of extending the shadow
              )
            ],
          ),
        ),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    final ColorProvider colorTheme = Provider.of<ColorProvider>(context);
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);

    return Container(
      color: Colors.white,
      child: TableCalendar(
        locale: 'sk_SK',
        firstDay: _rangeStart,
        lastDay: _rangeEnd,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
        eventLoader: _fetchEvents, //(day){ return events;},
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableGestures: AvailableGestures.all,
        availableCalendarFormats: const {
          CalendarFormat.week: 'Týždeň',
        },
        /*calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            weekendStyle: TextStyle().copyWith(
              color: colorTheme.mainColor, fontWeight: FontWeight.bold),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
        ),*/
        /*
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonVisible: false,
        ),*/
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, _) {
            return FadeTransition(
              opacity:
                  Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: Container(
                color: colorTheme.secondaryColor,
                width: 100,
                height: 100,
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(fontSize: 16.0),
                  ),
                ),
              ),
            );
          },
          todayBuilder: (context, date, _) {
            return Container(
              decoration: BoxDecoration(
                border:
                    Border.all(width: 3.0, color: colorTheme.secondaryColor),
                borderRadius: BorderRadius.all(Radius.circular(
                        4.0) //                 <--- border radius here
                    ),
              ),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(fontSize: 16.0),
                ),
              ),
            );
          },
         markerBuilder: (context, date, List events) {
            if (events.isNotEmpty) {
              return Positioned(
                bottom: 1,
                right: 1,
                child: _buildEventsMarker(date, events),
              );
            } else {
               return SizedBox.shrink();

            }
          },
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {

    final ColorProvider colorTheme = Provider.of<ColorProvider>(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration:
          BoxDecoration(shape: BoxShape.rectangle, color: colorTheme.mainColor),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    final ColorProvider colorTheme = Provider.of<ColorProvider>(context);
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    return Container(
        color: colorTheme.secondaryColor,
        child: AnimatedOpacity(
          opacity: eventsProvider.selectedEvents.length > 0 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: ListView(
            padding: EdgeInsets.all(8),
            children: eventsProvider.selectedEvents
                .map((event) => EventListItem(event: event))
                .toList(),
          ),
        ));
  }
}

class EventListItem extends StatelessWidget {
  final event;

  const EventListItem({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorProvider colorTheme = Provider.of<ColorProvider>(context);

//    String Formatting
    //Start & End-time
    final startTime = event.startTime != null
        ? new DateFormat("HH:mm").format(event.startTime)
        : '';
    final endTime = event.endTime != null
        ? "\n${new DateFormat("HH:mm").format(event.endTime)}"
        : '';

    //Location
    final location = event.location != null ? "\nSted: ${event.location}" : '';

    return Hero(
      child: Card(
        color: Colors.white,
        child: ListTile(
          leading: Column(
            children: <Widget>[Text("$startTime$endTime")],
          ),
          dense: true,
//          trailing:
//              event.image != null ? Image.network(event.image) : SizedBox(),
          trailing: event.description != null
              ? Icon(Icons.keyboard_arrow_right,
                  color: Colors.black38, size: 30.0)
              : SizedBox.shrink(),
          title: Text("${event.title ?? ''}$location"),
          subtitle: Text(
            "${event.description ?? ''}",
            maxLines: 3,
            overflow: TextOverflow.fade,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(
                event: event,
              ),
            ),
          ),
        ),
      ),
      tag: event.id,
    );
  }
}
