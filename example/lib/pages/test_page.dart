import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../widgets/mindset_quill_editor.dart';
import '../widgets/mindset_quill_toolbar.dart';
import 'test_logic.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  TestLogic logic = TestLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Container(
              color: Colors.black26,
              width: 200,
              height: 150,
              child: MindsetQuillEditor(
                quillController: logic.controller,
                scrollController: logic.scrollController,
                maxTextLength: logic.limit,
                onTextChanged: (doc){
                  // print("doc : ${doc.toPlainText()}");
                },
                focusNode: FocusNode(),
                autoFocus: false,
                document: quill.Document(),
                defaultFontSize: 20,
              ),
            ),
            ElevatedButton(onPressed: (){}, child: Text("key")),
            // ElevatedButton(onPressed: logic.onSave, child: Text("save")),
            // ElevatedButton(onPressed: logic.onRestore, child: Text("restore")),
            KeyboardVisibilityBuilder(builder: (_, isShow) =>
                Container(
                  width: 500,
                    height: 50,
                    child: isShow
                        ? MindsetQuillBar(controller: logic.controller)
                        : const SizedBox()
                )
            ),
          ],
        ),
      ),
    );
  }
}
