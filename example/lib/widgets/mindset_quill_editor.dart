import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/src/widgets/raw_editor.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../../../function.dart';
import 'embed_time.dart';

class MindsetQuillEditor extends StatefulWidget {

  final QuillController quillController;
  final ScrollController scrollController;
  final double? defaultFontSize;
  final int maxTextLength;
  final FocusNode focusNode;
  final bool autoFocus;
  final Document document;

  final SingleCallback<Document> onTextChanged;
  final SingleCallback<double>? onTextFontChanged;

  final GlobalKey? testKey;

  const MindsetQuillEditor({
    super.key,
    required this.quillController,
    required this.scrollController,
    required this.maxTextLength,
    required this.onTextChanged,
    required this.focusNode,
    required this.autoFocus,
    required this.document,
    this.defaultFontSize,
    this.onTextFontChanged,
    this.testKey
  });

  @override
  State<MindsetQuillEditor> createState() => _MindsetQuillEditorState();
}

class _MindsetQuillEditorState extends State<MindsetQuillEditor> {

  StreamSubscription<DocChange>? sub;
  int offset = 0;

  bool isShowToast = false;
  double fontSize = 20;
  BoxConstraints? boxSize;

  GlobalKey key = GlobalKey();




  @override
  void didUpdateWidget(covariant MindsetQuillEditor oldWidget) {
    fontSize = widget.defaultFontSize!;
    _updateDiary();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    sub ??= widget.quillController.document.changes.listen((change) {
      _checkMaxTextLength();
      _calculateFontSize();
      test();
    });
    widget.quillController.onSelectionChanged = _checkTextSelection;
    //自动缩小字体
    fontSize = widget.defaultFontSize ?? 20;
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > 0){
        if(fontSize > 20){
          setState(() {
            fontSize -= 2;
            if(widget.onTextFontChanged != null){
              widget.onTextFontChanged!(fontSize);
            }
          });
        }
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    sub?.cancel();
    sub = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,size){
        boxSize = size;
        return QuillEditor(
          key: key,
          customStyles: DefaultStyles(
            paragraph: DefaultTextBlockStyle(
                TextStyle(fontSize: fontSize, color: Colors.black),
                const VerticalSpacing(0, 0),
                const VerticalSpacing(0, 0),
                null),
          ),
          controller: widget.quillController,
          readOnly: false,
          autoFocus: widget.autoFocus,
          focusNode: widget.focusNode,
          expands: false,
          minHeight: 100,
          scrollable: true,
          padding: const EdgeInsets.all(0),
          scrollController: widget.scrollController,
          embedBuilders: [
            ...FlutterQuillEmbeds.builders(),
            TimeStampEmbedBuilderWidget()
          ],
        );
      },
    );
  }

  void _updateDiary()async{
    await sub?.cancel();
    sub = null;
    sub ??= widget.quillController.document.changes.listen((change) {
      _checkMaxTextLength();
      test();
    });
    widget.quillController.onSelectionChanged = (textSelection){
      _checkTextSelection(textSelection);
    };
  }

  void test(){
    final quillEditorState = key.currentState as QuillEditorState;
    BuildContext? editorContext = quillEditorState.editableTextKey.currentContext;
    final rawEditorState = quillEditorState.editableTextKey.currentState as RawEditorState;
    // print("key ${key.currentState}");
    // print("editorKey ${quillEditorState.editableTextKey.currentState}");
    // print("key ${editorContext!.size}");
    // print("rawEditorState ${rawEditorState.editorKey.currentState}");
    // print("rawEditorState ${rawEditorState.editorKey.currentContext?.size}");
    print("translateKey ${rawEditorState.translateKey}");
    print("translateKey ${rawEditorState.translateKey.currentContext?.size}");
    // Future.delayed(const Duration(milliseconds: 500),(){
    //   print("translateKey 500 ${rawEditorState.translateKey}");
    //   print("translateKey 500 ${rawEditorState.translateKey.currentContext?.size}");
    // });
  }

  void _checkTextSelection(TextSelection textSelection){
    // Log().i("base : ${textSelection.base} , offset : ${textSelection.baseOffset}");
    setState(() {
      offset = textSelection.baseOffset;
    });
  }

  ///检查最大字数
  void _checkMaxTextLength()async{
    widget.onTextChanged(widget.quillController.document);
    int documentLength = widget.quillController.document.length;
    if (documentLength > widget.maxTextLength) {
      final addLength = documentLength - widget.maxTextLength;
      final latestIndex = offset - addLength;
      try{
        print("超出字数长度 $addLength,超出位置: $latestIndex}");
        widget.quillController.replaceText(
          latestIndex,
          addLength,
          '',
          TextSelection.collapsed(offset: latestIndex),
        );
      } catch(e){
        print("flutter quill error ${e.toString()}");
      }
    }
  }

  void _calculateFontSize(){
    print("fontSize value :$fontSize");
    if(boxSize != null){
      final span = TextSpan(
        style: TextStyle(fontSize: fontSize),
        text: widget.quillController.document.toPlainText(),
      );
      final textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: boxSize!.maxWidth);
      print("quill height ${textPainter.height},width ${textPainter.width}");
    }
  }

}
