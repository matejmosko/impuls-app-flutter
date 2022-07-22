import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scenickazatva_app/providers/AppSettings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showPush = false;
  Map<String, String> festivals = {
  'scenickazatva2022': 'Scénická žatva',
  'tvorba2022': 'Tvorba',
  'belopotockehomikulas2023': 'Belopotockého Mikuláš'
  };
  String selectedFestival;

  @override
  Widget build(BuildContext context) {
    selectedFestival = festivals[1];
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
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          SwitchListTile(
            title: Text('Notifikácie na program'),
            subtitle: Text('Krátke správy o tom, že sa blíži predstavenie'),
            secondary: Icon(Icons.notifications),
            onChanged: (value) {
              setState(() {
                showPush = value;
                final _uid = userData.user.uid; //userCredential.user.uid;
                DatabaseReference users = FirebaseDatabase.instance.ref("users/$_uid");
                users.update({
                  "programNotifications": value,
                });
              });
              //save('adminNotifications', value);
            },
            value: showPush,
          ),
         /* Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  // A setting to change main festival in the app
                  title: Text('Vyberte si festival',
                      style: Theme.of(context).textTheme.headline6),
                ),
                RadioListTile(
                    // A setting to change main festival in the app
                    value: festivals.scenickazatva2022,
                    groupValue: selectedFestival,
                    onChanged: (value) {
                      setState(() {
                        selectedFestival = value;
                      });
                    },
                    title: Text('Scénická žatva 2022'),
                    subtitle: Text("30.8. - 4.9. 2022")),
                RadioListTile(
                  value: festivals['scenickazatva2022'],
                  groupValue: selectedFestival,
                  onChanged: (value) {
                    setState(() {
                      selectedFestival = value;
                      //_showMessageDialog(context);
                    });
                  },
                  title: Text('Tvorba 2022'),
                ),
                RadioListTile(
                  value: festivals['scenickazatva2022'],
                  groupValue: selectedFestival,
                  onChanged: (value) {
                    setState(() {
                      selectedFestival = value;
                      //_showMessageDialog(context);
                    });
                  },
                  title: Text('Belopotockého Mikuláš 2023'),
                ),
              ],
            ),
          )*/
        ],
      ),

      /*SettingsList(
        sections: [
          SettingsSection(
            title: Text('Všeobecné'),
            tiles: <SettingsTile>[
              /*SettingsTile(
                // A setting to change main festival in the app
                leading: Icon(Icons.language),
                title: Text('Vyberte si festival'),
                value: Text(selectedFestival),
                onPressed: (context) {
                  _showMessageDialog(context);
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
      ),*/
    );
  }

  /*_showMessageDialog(BuildContext context) => showDialog(
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
      );*/
}
