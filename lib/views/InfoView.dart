import 'package:flutter/material.dart';
import 'package:scenickazatva_app/providers/InfoProvider.dart';
import 'package:provider/provider.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:go_router/go_router.dart';

class InfoView extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    //final ColorProvider colorTheme = Provider.of<ColorProvider>(context);
    final InfoProvider infoProvider = Provider.of<InfoProvider>(context);

    return Stack(
      children: [
        Center(
          child: AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: infoProvider.loading ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Text(
              "Načítavam...",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: infoProvider.info.length > 0 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(
            child: Card(
              child: ListView.builder(
                itemCount: infoProvider.info.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = infoProvider.info[index];
                  return ListTile(
                      title: Text(item.title),
                      leading: Icon(
                          IconData(item.icon, fontFamily: 'MaterialIcons')),
                      subtitle: Text(
                        item.description,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                      onTap: () {
                        Analytics().sendEvent(item.title);
                        context.go("/info/"+item.id);
                      }
                      );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
