import 'package:flutter/material.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scenickazatva_app/models/Event.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as MD;
import 'package:go_router/go_router.dart';

class CalendarView extends StatefulWidget {
  CalendarView({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _selectedDay;
  DateTime _rangeStart = DateTime.utc(2023, 8, 30);
  DateTime _rangeEnd = DateTime.utc(2023, 9, 2);
  DateTime _focusedDay = (DateTime.now().isBefore(DateTime.utc(2023, 8, 30)) ||
          DateTime.now().isAfter(DateTime.utc(2023, 8, 30)))
      ? DateTime.utc(2023, 8, 30)
      : DateTime.now();
  AnimationController? _animationController;
  List venues = [];
  // List events;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController?.forward();

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
      return event.startTime?.year == day.year &&
          event.startTime?.month == day.month &&
          event.startTime?.day == day.day;
    }).toList();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // print('CALLBACK: _onDaySelected');
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
      color: Theme.of(context).colorScheme.primary,
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
          outsideTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.onPrimary  ),
          defaultTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.onTertiary),
          disabledTextStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
          weekendTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Colors.white54,
            ),
            weekendStyle: TextStyle(
              color: Colors.white54,
            )),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, _) {
            return FadeTransition(
              opacity:
                  Tween(begin: 0.0, end: 1.0).animate(_animationController!),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).colorScheme.inverseSurface),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface)
                            .copyWith(fontSize: 16.0),
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
                right: 8,
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
            color: Theme.of(context).colorScheme.onTertiary,
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
        children: _fetchEvents(_selectedDay!)
            .map((event) => EventListItem(event: event))
            .toList(),
      ),
    ));
  }
}

class EventListItem extends StatelessWidget {
  final event;

  const EventListItem({Key? key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    /*final description = event.description != null
        ? event.description.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
        : '';*/
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    return GestureDetector(
      child: Card(
          child: Row(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
              width: 60,
              child: Column(
                /*crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,*/
                children: <Widget>[
                  Icon(eventsProvider.getLocationIcon(event.location),
                      color: eventsProvider.getLocationColor(event.location),
                      size: 26),
                  Text("$location",
                      style: TextStyle(
                          color:
                              eventsProvider.getLocationColor(event.location)),
                      textAlign: TextAlign.center),
                  Text("$startTime"),
                ],
              )),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${event.title ?? ''}",
                  style: Theme.of(context).textTheme.displaySmall),
              LimitedBox(
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(bounds);
                  },
                  child: Html(data: MD.markdownToHtml(event.description)),
                ),
                maxHeight: 70,
              )
            ],
          ),
        ),
        Container(
          width: 120.0,
          height: 120.0,
          child: event.image != ""
              ? Image(
                  image: FirebaseImageProvider(FirebaseUrl(event.image)),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset('assets/images/icon512.png');
                  },
                )
              : Image.asset('assets/images/icon512.png'),
        ),
      ])),
      onTap: () {
        Analytics().sendEvent(event.title);
        context.go("/events/" + event.id);
/*        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(
              eventId: event.id,
            ),
          ),
        );*/
      },
    );
  }
}
