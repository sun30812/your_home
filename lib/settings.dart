import 'dart:io';
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

  void switchClick(int index, bool value, bool? isRequiredRestart) {
    setState(() {
      _settingsData[index] = value;
    });
    setSettingsData(index);
    if (isRequiredRestart == true) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('안내'),
            content: Text('설정을 위해 앱을 지금 종료합니다.'),
            actions: [
              CupertinoDialogAction(
                child: Text('확인'),
                isDefaultAction: true,
                onPressed: () => exit(0),
              )
            ],
          );
        },
      );
    }
  }

  GestureDetector settingsItem(
      {required int index,
      required String data,
      required String infoData,
      bool? isRequiredRestart}) {
    return GestureDetector(
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('안내'),
              content: Text(infoData),
              actions: [
                CupertinoDialogAction(
                  child: Text('확인'),
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          },
        );
      },
      child: ListBody(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data,
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                  ),
                ),
                CupertinoSwitch(
                    value: _settingsData[index] ?? false,
                    onChanged: (value) =>
                        switchClick(index, value, isRequiredRestart))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSettingsData(0);
    getSettingsData(1);
    getSettingsData(2);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('설정'),
      ),
      child: ListView(
        children: [
          settingsItem(
              index: 0,
              data: '설정 아이콘 추가하기(현재 미지원, 앱 재시작 필요)',
              infoData: '하단 바에 설정 아이콘을 추가합니다. 해당 기능은 앱을 재시작한 후에 적용됩니다.',
              isRequiredRestart: true),
          settingsItem(
              index: 1,
              data: '삭제 시 경고 표시하지 않기',
              infoData: '항목을 지울 시 경고가 뜨지 않습니다.'),
          settingsItem(
              index: 2,
              data: '개발자 모드 활성화',
              infoData: '개발자용 명령어를 앱의 홈화면에서 사용할 수 있게 됩니다.(사용에 주의바람)'),
        ],
      ),
    );
  }
}
