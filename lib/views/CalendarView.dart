import 'package:flutter/material.dart';
import 'package:scenickazatva_app/pages/EventDetailPage.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scenickazatva_app/models/Event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CalendarView extends StatefulWidget {
  CalendarView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay;
  DateTime _rangeStart = DateTime.utc(2022, 8, 29);
  DateTime _rangeEnd = DateTime.utc(2022, 9, 4);
  DateTime _focusedDay = (DateTime.now().isBefore(DateTime.utc(2022, 8, 29)) || DateTime.now().isAfter(DateTime.utc(2022, 9, 4))) ? DateTime.utc(2022, 8, 30) : DateTime.now();
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

    return Container(
      color: Theme.of(context).primaryColor,
      child: TableCalendar(
        locale: 'sk_SK',
        firstDay: _rangeStart,
        lastDay: _rangeEnd,
        focusedDay: _focusedDay,
        headerVisible: false,
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
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          outsideTextStyle: TextStyle(color: Theme.of(context).dividerColor),
          defaultTextStyle: TextStyle(color: Theme.of(context).backgroundColor),
        ),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, _) {
            return FadeTransition(
              opacity:
                  Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Theme.of(context).colorScheme.secondary),
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
                border: Border.all(width: 3.0),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(shape: BoxShape.rectangle),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Theme.of(context).backgroundColor,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    return Container(
        child: AnimatedOpacity(
      opacity: eventsProvider.events.length > 0 ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: ListView(
        padding: EdgeInsets.all(8),
        children: _fetchEvents(_selectedDay)
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
    //final ColorProvider colorTheme = Provider.of<ColorProvider>(context);
    Color locColor;
    IconData locIcon;
    String locName;
    switch (event.location) {
      case "Štúdio":
        locColor = Colors.orangeAccent;
        locIcon = Icons.corporate_fare;
        locName = "Štúdio SKD";
        break;
      case "ND":
        locColor = Colors.brown;
        locIcon = Icons.house;
        locName = "Národný Dom";
        break;
      case "TKS":
        locColor = Colors.greenAccent;
        locIcon = Icons.grass;
        locName = "Pred TKS";
        break;
      case "BarMuseum":
        locColor = Colors.deepPurple;
        locIcon = Icons.museum;
        locName = "BarMuseum";
        break;
      case "Stan":
        locColor = Colors.blueAccent;
        locIcon = Icons.storefront;
        locName = "Stan";
        break;
      case "Námestie":
        locColor = Colors.blueAccent;
        locIcon = Icons.storefront;
        locName = "Divadelné námestie";
        break;
      default:
        locColor = Colors.grey;
        locIcon = Icons.location_city;
        locName = "Martin";
        break;
    }
    print(locName);
//    String Formatting
    //Start & End-time
    final startTime = event.startTime != null
        ? new DateFormat("HH:mm").format(event.startTime)
        : '';
    /*final endTime = event.endTime != null
        ? new DateFormat("HH:mm").format(event.endTime)
        : '';*/

    //Location
    final location = event.location != null ? "${event.location}" : '';
    final description = event.description != null
        ? event.description.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
        : '';

    return GestureDetector(
      child: Card(
        child: Row(children: <Widget>[
          Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            /*crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,*/
            children: <Widget>[
              Icon(locIcon, color: locColor,size: 26),
              Text("$location", style: TextStyle(color: locColor)),
              Text("$startTime"),
            ],
          ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    "${event.title ?? ''}", style: Theme.of(context).textTheme.headline3),  //title: Text("${event.title ?? ''}$location"),
                Text(
                  "$description",
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
          event.image != null
              ? Container(
                  width: 120.0,
                  height: 120.0,
                  child: Hero(
                    child: CachedNetworkImage(
                      imageUrl: event.image,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    tag: event,
                  ),
                )
              : SizedBox.shrink(),
        ])
      ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(
              event: event,
            ),
          ),
        ),
    );
  }
}
