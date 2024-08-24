import 'package:flutter/material.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:scenickazatva_app/providers/FestivalProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scenickazatva_app/models/ColorScheme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scenickazatva_app/models/Event.dart';
import 'package:scenickazatva_app/models/Festival.dart';
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
  DateTime _selectedDay = DateTime.now();
  DateTime _rangeStart = DateTime.utc(2024, 8, 28);
  DateTime _rangeEnd = DateTime.utc(2025, 12, 31);
  DateTime _focusedDay = DateTime.now();
  // static var _calendarKeyCount = 0;
  AnimationController? _animationController;
  Festival festival = Festival();
  List venues = [];
  Color foregroundColor = darkColor;
  Color backgroundColor = accentColor;
  Color selectedColor = lightColor;
  Color mainProgramColor = accentColor;
  Color offProgramColor = lightColorDarker;
  // List events;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _focusedDay =
        (_focusedDay.isBefore(_rangeStart) || _focusedDay.isAfter(_rangeEnd))
            ? _rangeStart
            : _focusedDay;

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

  Future<Festival> getFestival() async {
    FestivalProvider festivalProvider =
        Provider.of<FestivalProvider>(context, listen: false);
    festival = festivalProvider.festival;

    _rangeStart = festival.startDate ?? _rangeStart;
    _rangeEnd = festival.endDate ?? _rangeEnd;

    if (_focusedDay.isBefore(_rangeStart) || _focusedDay.isAfter(_rangeEnd)) {
      _focusedDay = _rangeStart;
    }
    foregroundColor = festivalProvider.foregroundColor;
    backgroundColor = festivalProvider.backgroundColor;
    selectedColor = festivalProvider.selectedColor;
    mainProgramColor = festivalProvider.mainProgramColor;
    offProgramColor = festivalProvider.offProgramColor;

    //_calendarKeyCount += 1;
    return festival;
  }
/*
  Festival fetchFestival() {
    FestivalProvider festivalProvider =
        Provider.of<FestivalProvider>(context, listen: false);
    final festival = festivalProvider.festival;

    foregroundColor = festivalProvider.foregroundColor;
    backgroundColor = festivalProvider.backgroundColor;
    selectedColor = festivalProvider.selectedColor;
    mainProgramColor = festivalProvider.mainProgramColor;
    offProgramColor = festivalProvider.offProgramColor;
    return festival;
  }*/

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      setSelectedDay(selectedDay);
    });
    //_fetchEvents;
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
          /*decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 1.0, // has the effect of softening the shadow
                spreadRadius: 5.0, // has the effect of extending the shadow
              )
            ],
          ),*/
        ),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return Container(
      color: festivalBackgroundColor,
      child: FutureBuilder(
          future: getFestival(),
          builder: (BuildContext context, AsyncSnapshot<Festival> snapshot) {
            if (snapshot.hasData) {
              return TableCalendar(
                locale: 'sk_SK',
                firstDay: snapshot.data!.startDate ?? _rangeStart,
                lastDay: snapshot.data!.endDate ?? _rangeEnd,
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
                  outsideTextStyle: TextStyle(color: foregroundColor),
                  defaultTextStyle: TextStyle(color: foregroundColor),
                  disabledTextStyle: TextStyle(color: foregroundColor),
                  weekendTextStyle: TextStyle(color: foregroundColor),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: foregroundColor,
                    ),
                    weekendStyle: TextStyle(
                      color: foregroundColor,
                    )),
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, date, _) {
                    return FadeTransition(
                      opacity: Tween(begin: 0.0, end: 1.0)
                          .animate(_animationController!),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: selectedColor),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            /*style: TextStyle(
                                  color: Theme.of(context).colorScheme.onInverseSurface)
                              .copyWith(fontSize: 16.0),*/
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
                          /* style: TextStyle().copyWith(fontSize: 16.0),*/
                        ),
                      ),
                    );
                  },
                  markerBuilder: (context, date, List events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 0,
                        right: 0,
                        child: _buildEventsMarker(date, events),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Row(children: [
                Text(
                  "Nepodarilo sa načítať informácie o festivale. Skontrolujte svoje pripojenie k internetu.",
                ),
              ]);
            } else

              // Future hasn't finished yet, return a placeholder
              return Row(children: [
                Text(
                  "Načítavam...",
                ),
              ]);
          }),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
          color: festivalForegroundColor, shape: BoxShape.rectangle),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: festivalThirdColor,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);

    return Container(
        /* decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          )
        ),*/
        child: AnimatedOpacity(
      opacity: eventsProvider.events.length > 0 ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: ListView(
        padding: EdgeInsets.all(8),
        children: _fetchEvents(_selectedDay)
            .map((event) => EventListItem(event: event, festival: festival))
            .toList(),
      ),
    ));
  }
}

class EventListItem extends StatelessWidget {
  final event;
  final Festival festival;

  const EventListItem({Key? key, @required this.event, required this.festival}) : super(key: key);

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

    final playing = (event.startTime.isAfter(DateTime.now()) &&
            event.endTime.isBefore(DateTime.now()))
        ? true
        : false; // Check if the event is currently on.

    print(festival.mainProgramColor);

    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    final FestivalProvider festivalProvider = Provider.of<FestivalProvider>(context);

    return GestureDetector(
        child: Card(
            shape: playing
                ? RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  )
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
            color: event.type == "offprogram"
                ? festivalProvider.offProgramColor
                : event.type == "partner"
                    ? festivalProvider.partnerProgramColor
                    : festivalProvider.mainProgramColor,
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
                            color:
                                eventsProvider.getLocationColor(event.location),
                            size: 26),
                        Text("$location",
                            style: TextStyle(
                                color: eventsProvider
                                    .getLocationColor(event.location)),
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
                        image: FirebaseImageProvider(
                          FirebaseUrl(event.image),
                        ),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image(
                              image: FirebaseImageProvider(
                                  FirebaseUrl(festivalProvider.festival.logo)));
                          //return Image.asset('assets/images/icon512.png');
                        },
                      )
                    : Image(
                        image: FirebaseImageProvider(
                            FirebaseUrl(festivalProvider.festival.logo))),
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
        });
  }
}
