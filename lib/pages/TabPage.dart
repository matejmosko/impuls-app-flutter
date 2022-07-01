import 'package:flutter/material.dart';
import 'package:impuls/providers/EventsProvider.dart';
import 'package:impuls/providers/InfoProvider.dart';
import 'package:impuls/providers/NewsProvider.dart';
import 'package:impuls/views/CalendarView.dart';
import 'package:impuls/views/InfoView.dart';
import 'package:impuls/views/NewsView.dart';
import 'package:impuls/views/MagazineView.dart';
import 'package:provider/provider.dart';

class TabPage extends StatefulWidget {
  static List<Widget> _widgetOptions = <Widget>[
    NewsView(),
    CalendarView(),
    MagazineView(),
    InfoView(),
  ];

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, newsProvider, eventsProvider, infoProvider) {
    if (index == 0) {
      newsProvider.fetchNews();
    } else if (index == 1) {
      eventsProvider.fetchAllEvents();
    } else if (index == 2) {
      newsProvider.fetchMagazine();
    } else if (index == 3) {
      infoProvider.fetchInfo();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final NewsProvider newsProvider = Provider.of<NewsProvider>(context);
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    final InfoProvider infoProvider = Provider.of<InfoProvider>(context);

    //final ColorProvider colorTheme = Provider.of<ColorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scénická žatva 100",
        ),
      ),
      body: Center(
        child: TabPage._widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type:BottomNavigationBarType.fixed,
        backgroundColor: Colors.black87,
        unselectedItemColor: Colors.white70,
        selectedItemColor: Color(0xffdf9f4a),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Novinky',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Kalendár',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Festník',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        currentIndex: _selectedIndex,
        /* selectedItemColor: colorTheme.textColor,
        unselectedItemColor: colorTheme.textColor,*/
        showUnselectedLabels: true,
        onTap: (index) =>
            _onItemTapped(index, newsProvider, eventsProvider, infoProvider),
      ),
    );
  }
}
