import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showPush = false;
  final List<String> festivals = [
    'Scénická žatva',
    'Tvorba',
    'Belopotockého Mikuláš'
  ];
  String selectedFestival;

  @override
  Widget build(BuildContext context) {
    selectedFestival = festivals[0];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scénická žatva 100",
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Všeobecné'),
            tiles: <SettingsTile>[
             /* SettingsTile(
                leading: Icon(Icons.language),
                title: Text('Vyberte si festival'),
                value: Text(selectedFestival),
                onPressed: (context) {
                  _showMessageDialog(context);
                  //Navigator.of(context).restorablePush(_dialogBuilder);
                },
              ),*/
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    showPush = value;
                  });
                },
                initialValue: showPush,
                leading: Icon(Icons.notifications),
                title: Text('Upozorňovať na program v notifikáciách'),
              ),
            ],
          ),
          /*SettingsSection(
            title: Text('Festival'),
            tiles: <SettingsTile>[],
          ),*/
        ],
      ),
    );
  }

  /*static Route<Object> _dialogBuilder( /* https://medium.com/codechai/flutter-speed-upbuild-the-alertdialogs-single-choice-dialog-multiple-choice-dialog-textfield-7011ec4bac67 */
      BuildContext context, Object arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
      AlertDialog(
        title: Text("Select one country"),
    content: SingleChildScrollView(
    child: Container(
    width: double.infinity,
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: festivals
        .map((e) => RadioListTile(
    title: Text(e),
    value: e,
    /*groupValue: _singleNotifier.currentCountry,
    selected: _singleNotifier.currentCountry == e,*/
    onChanged: (value) {
    /*if (value != _singleNotifier.currentCountry) {
    _singleNotifier.updateCountry(value);*/
    Navigator.of(context).pop();

    },
    ))
        .toList(),

  )
  )
  )
      ),
    );
  }*/
  _showMessageDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Select one country"),
            content: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: festivals
                          .map((e) => RadioListTile(
                                title: Text(e),
                                value: e,
                                groupValue: selectedFestival,
                                /*groupValue: _singleNotifier.currentCountry,
                     selected: _singleNotifier.currentCountry == e,*/
                                onChanged: (value) {
                                  /*if (value != _singleNotifier.currentCountry) {
                       _singleNotifier.updateCountry(value);*/
                                  if (value != selectedFestival) {
                                    selectedFestival = value;
                                    Navigator.of(context).pop();
                                  }
                                },
                              ))
                          .toList(),
                    )))),
      );
}
