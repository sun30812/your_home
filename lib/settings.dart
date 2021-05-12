import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<int, bool> _settingsData = {};

  void getSettingsData(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool value = preferences.getBool('settings: $index') ?? false;
    setState(() {
      _settingsData.addAll({index: value});
    });
  }

  void setSettingsData(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
        'settings: $index', _settingsData[index] ?? false);
  }

  void switchClick(int index, bool value) {
    setState(() {
      _settingsData[index] = value;
    });
    setSettingsData(index);
  }

  ListBody settingsItem(int index, String data) {
    return ListBody(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data,
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
              CupertinoSwitch(
                  value: _settingsData[index] ?? false,
                  onChanged: (value) => switchClick(index, value))
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getSettingsData(0);
    getSettingsData(1);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('설정'),
      ),
      child: ListView(
        children: [
          settingsItem(0, '설정 아이콘 추가하기(현재 미지원)'),
          settingsItem(1, '삭제 시 경고 표시하지 않기'),
        ],
      ),
    );
  }
}