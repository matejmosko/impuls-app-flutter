import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:scenickazatva_app/providers/InfoProvider.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:scenickazatva_app/views/CalendarView.dart';
import 'package:scenickazatva_app/views/InfoView.dart';
import 'package:scenickazatva_app/views/NewsView.dart';
import 'package:scenickazatva_app/views/MagazineView.dart';
import 'package:provider/provider.dart';

class TabPage extends StatefulWidget {
  final initialIndex;
  TabPage({required this.initialIndex});
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  static List<Widget> _widgetOptions = <Widget>[
    MagazineView(),
    CalendarView(),
    NewsView(),
    InfoView(),
//    MagazineView(),
  ];

  int _selectedIndex = 0;
  PageController _pageController = PageController();

  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(
      initialPage: widget.initialIndex,
      keepPage: true,
    );
  }

  void _itemTapped(int index, newsProvider, eventsProvider, infoProvider) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void pageChanged(
      int index, newsProvider, eventsProvider, infoProvider) async {
    if (index == 2) {
      newsProvider.fetchWpNews("news_src");
    } else if (index == 1) {
      await eventsProvider.fetchAllEvents();
      await eventsProvider.fetchLocations();
    } else if (index == 3) {
      await infoProvider.fetchInfo();
    } else if (index == 0) {
      newsProvider.fetchWpMagazine("magazine_src");
    }
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
          _selectedIndex == 0 ? "javisko.sk" : "Scénická žatva",
        ),
        actions: <Widget>[
          kIsWeb == true
              ? IconButton(
                  icon: Icon(
                    Icons.settings,
                  ),
                  onPressed: () {
                    context.go('/settings');
                  },
                )
              : SizedBox(),
          kIsWeb == true
              ? IconButton(
                  icon: Icon(
                    Icons.person,
                  ),
                  onPressed: () {
                    // TODO Pridať možnosť prihlásiť sa na webe.
                    context.go('/settings');
                  },
                )
              : SizedBox(),
        ],
      ),
      body: Center(
        child: buildPageView(newsProvider, eventsProvider, infoProvider),
      ),
      bottomNavigationBar: NavigationBar(
          destinations: <Widget>[
            NavigationDestination(
              icon: Icon(Icons.menu_book),
              label: 'javisko.sk',
            ),
            NavigationDestination(
              icon: Icon(Icons.date_range),
              label: 'Program',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications),
              label: 'Novinky',
            ),
            NavigationDestination(
              icon: Icon(Icons.info),
              label: 'Info',
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) =>
              _itemTapped(index, newsProvider, eventsProvider, infoProvider)),
    );
  }
}
