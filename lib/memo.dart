import 'package:flutter/cupertino.dart';

import 'class/memo_class.dart';

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  List<Container> menu = [];
  TextEditingController _controller = TextEditingController();
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
                        controller: _controller,
                        cursorColor: CupertinoColors.black,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        placeholder: '여기에 간단한 메모를 입력해보세요',
                      ),
                    ),
                  ),
                  CupertinoButton(
                      child: Icon(
                        CupertinoIcons.add,
                        // color: CupertinoColors.black,
                      ),
                      onPressed: (() {
                        if (_controller.text.isEmpty) {
                          Navigator.of(context).pushNamed('/newMemo');
                        } else {
                          Memo memo = Memo(title: _controller.text);
                          setState(() {
                            _controller.text = '';
                          Memo.list.add(memo);

                          });
                        }
                      }) )
                ],
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: Memo.list.length,
                  itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoContextMenu(
                      actions: [
                        CupertinoContextMenuAction(child:
                            Row(
                              children: [
                                Icon(CupertinoIcons.delete),
                                Text('지우기')
                              ],
                            )
                        )
                      ],
                      child: PhysicalModel(
                        elevation: 5.0, color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(3.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Memo.list[index].title,
                          style: TextStyle(
                                fontSize: 24.0,
                            fontWeight: FontWeight.bold
                              ),),
                              Text((Memo.list[index].content) ?? ''),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },),
              ),
            ],
          ),
        )
    );
  }
}