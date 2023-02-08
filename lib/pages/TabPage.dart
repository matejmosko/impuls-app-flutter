import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:scenickazatva_app/providers/InfoProvider.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:scenickazatva_app/views/CalendarView.dart';
//import 'package:scenickazatva_app/pages/SettingsPage.dart';
import 'package:scenickazatva_app/views/InfoView.dart';
import 'package:scenickazatva_app/views/NewsView.dart';
//import 'package:scenickazatva_app/views/MagazineView.dart';
import 'package:provider/provider.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  static List<Widget> _widgetOptions = <Widget>[
    NewsView(),
    CalendarView(),
    InfoView(),
//    MagazineView(),
  ];
  int _selectedIndex = 1;
  PageController _pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  void _itemTapped(int index, newsProvider, eventsProvider, infoProvider) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void pageChanged(int index, newsProvider, eventsProvider, infoProvider) {
    if (index == 0) {
      newsProvider.fetchNews("news_src");
    } else if (index == 1) {
      eventsProvider.fetchAllEvents();
    } else if (index == 2) {
      infoProvider.fetchInfo();
    }/* else if (index == 3) {
      newsProvider.fetchMagazine("magazine_src");
    }*/
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildPageView(newsProvider, eventsProvider, infoProvider) {
    return PageView(
        controller: _pageController,
        onPageChanged: (index) {
          pageChanged(index, newsProvider, eventsProvider, infoProvider);
        },
        children: _widgetOptions);
  }

  @override
  Widget build(BuildContext context) {
    final NewsProvider newsProvider = Provider.of<NewsProvider>(context);
    final EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    final InfoProvider infoProvider = Provider.of<InfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scénická žatva 100",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              context.go('/settings');
            },
          ),
          kIsWeb != null ? IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () { // TODO Pridať možnosť prihlásiť sa na webe.
              context.go('/settings');
            },
          ) : null,
        ],
      ),
      body: Center(
        child: buildPageView(newsProvider, eventsProvider,
            infoProvider),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          /*BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Festník',
          ),*/
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
            _itemTapped(index, newsProvider, eventsProvider, infoProvider),
      ),
    );
  }
}
