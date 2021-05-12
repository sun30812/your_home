import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String APPNAME = 'Your Home';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      title: APPNAME,
      home: MainPage(),
    );
  }
}

Color smartColor() {
  return CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.black, darkColor: CupertinoColors.white);
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home),
        activeIcon: Icon(
          CupertinoIcons.home,
          color: smartColor(),
        )),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.doc_append),
        activeIcon: Icon(
          CupertinoIcons.doc_append,
          color: smartColor(),
        )),
  ];

  List<BottomNavigationBarItem> tabBarItems(BuildContext context) =>
      bottomItems;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: tabBarItems(context)),
      tabBuilder: (context, _index) {
        switch (_index) {
          case 0:
            return HomePage();
          default:
            return MemoPage();
        }
      },
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '${DateTime.now().month}/${DateTime.now().day}',
          style: TextStyle(
            fontSize: 40.0,
          ),
        ),
        Text(
          '오늘도 할일을 빨리 끝내봅시다!',
          style: TextStyle(fontSize: 23.0),
        ),
      ]),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  List<String> todoLists = [];
  List<bool> doneLists = [];
  FocusNode focusNode = FocusNode();
  bool _isQuickDelete = false;

  void getQuickDeleteBoolean() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _isQuickDelete = preferences.getBool('settings: 1') ?? false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getQuickDeleteBoolean();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('남은 항목: ${todoLists.length}개'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CupertinoTextField(
                        cursorColor: CupertinoColors.black,
                        focusNode: focusNode,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: '여기에 할일을 입력해보세요',
                        controller: _controller,
                        autofocus: false,
                      ),
                    ),
                  ),
                  CupertinoButton(
                      child: Icon(
                        CupertinoIcons.add,
                        color: CupertinoColors.black,
                      ),
                      onPressed: () {
                        if (_controller.text == '/set') {
                          Navigator.of(context).push(
                              CupertinoPageRoute(builder: (_) => Settings()));
                        } else if (_controller.text.isNotEmpty) {
                          setState(() {
                            todoLists.add(_controller.text);
                            doneLists.add(false);
                          });
                        }
                        _controller.text = '';
                        focusNode.unfocus();
                      })
                ],
              ),
              Welcome(),
              Expanded(
                child: ListView.builder(
                    itemCount: todoLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CupertinoButton(
                                    child: Icon(
                                        doneLists[index]
                                            ? CupertinoIcons
                                                .check_mark_circled_solid
                                            : CupertinoIcons.check_mark_circled,
                                        color: CupertinoColors.black),
                                    onPressed: () => setState(() {
                                          doneLists[index] = !doneLists[index];
                                        })),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(todoLists[index]),
                              ],
                            ),
                            CupertinoButton(
                                child: Icon(
                                  CupertinoIcons.delete,
                                  color: CupertinoColors.black,
                                ),
                                onPressed: () => setState(() {
                                      if (!_isQuickDelete) {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                            title: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .exclamationmark_triangle,
                                                    color:
                                                        CupertinoColors.black,
                                                  ),
                                                  Text('삭제 경고')
                                                ],
                                              ),
                                            ),
                                            content:
                                                Text('해당 목록을 삭제합니다 삭제하시겠습니까?'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: Text('취소'),
                                                isDefaultAction: true,
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('삭제'),
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  todoLists.removeAt(index);
                                                  doneLists.removeAt(index);
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        todoLists.removeAt(index);
                                        doneLists.removeAt(index);
                                      }
                                    }))
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('메모장'),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '아직 이 기능은 개발되지 않았습니다!',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              )
            ],
          ),
        ));
  }
}

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
