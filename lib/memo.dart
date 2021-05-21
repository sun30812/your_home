import 'package:flutter/cupertino.dart';

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  List<Container> menu = [];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('메모장'),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CupertinoTextField(
                        cursorColor: CupertinoColors.black,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: '여기에 메모를 입력해보세요',
                        autofocus: false,
                      ),
                    ),
                  ),
                  CupertinoButton(
                      child: Icon(
                        CupertinoIcons.add,
                        // color: CupertinoColors.black,
                      ),
                      onPressed: null)
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                  return Padding(padding: EdgeInsets.all(8.0),
                  child: PhysicalModel(
                    elevation: 5.0, color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(3.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("제목",
                      style: TextStyle(
                            fontSize: 24.0,
                        fontWeight: FontWeight.bold
                          ),),
                          Text('곧 여기에 메모를 추가할 수 있습니다.'),
                        ],
                      ),
                    ),
                  )
                    ,);
                },),
              ),
            ],
          ),
        )
    );
  }
}