import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// author TDSSS
/// datetime 2023/11/16 16:21
class TestLogic {


  final QuillController controller = QuillController.basic();
  final ScrollController scrollController = ScrollController();

  final minSize = 16.0;
  final fontSize = 20.0;
  Delta before = Delta();
  Delta after = Delta();
  final textData = "";

  final textKey = GlobalKey();

  var json;
  final isOut = false;

  BoxConstraints? size;

  int limit = 200;

  final currentLength = 0;
}