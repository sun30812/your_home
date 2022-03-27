import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_home/class/memo_class.dart';
class NewMemoPage extends StatefulWidget {
  const NewMemoPage({Key? key}) : super(key: key);

  @override
  State<NewMemoPage> createState() => _NewMemoPageState();
}

class _NewMemoPageState extends State<NewMemoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('새로운 메모 작성'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('제목'),
                  ),
                  Flexible(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(controller: _titleController,),
                  )),
                  CupertinoButton(child: Text('완료'), onPressed: () {
                    if (_titleController.text.isEmpty) {
                       showCupertinoDialog(context: context, builder: ((context) {
                        return CupertinoAlertDialog(
                          title: Text('안내'),
                          content: Text('제목을 입력하세요'),
                          actions: [
                            CupertinoDialogAction(child: Text('확인'),
                              isDefaultAction: true,
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        );

                      }));
                    } else {
                      Memo memo = Memo(title: _titleController.text, content: _contentController.text);
                      Memo.list.add(memo);
                      Navigator.pop(context);
                    }
                    // Navigator.pop(context);
                  })
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoTextField(
                  minLines: 15,
                  maxLines: 50,
controller: _contentController,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
