import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';

import '../common/fonts.dart';
import 'embed_time.dart';
import 'mindset_color_button.dart';

///需要 选择字体、字体颜色、加粗、下划线、斜体、删除、有序、无序列表、添加时间
class MindsetQuillBar extends StatefulWidget {
  final QuillController controller;
  final QuillIconTheme? iconTheme;

  const MindsetQuillBar({super.key,required this.controller,this.iconTheme});

  @override
  State<MindsetQuillBar> createState() => _MindsetQuillBarState();
}

class _MindsetQuillBarState extends State<MindsetQuillBar> {

  late final QuillController controller;

  final double toolbarIconSize = 18;
  double toolbarSectionSpacing = kToolbarSectionSpacing;
  WrapAlignment toolbarIconAlignment = WrapAlignment.center;
  WrapCrossAlignment toolbarIconCrossAlignment = WrapCrossAlignment.center;
  List<QuillCustomButton> customButtons = const [];
  Map<String, String>? fontFamilyValues;
  VoidCallback? afterButtonPressed;
  List<EmbedButtonBuilder>? embedButtons;

  int? fontIndex;

  //default button tooltips
  final buttonTooltips =
      <ToolbarButtons, String>{
        ToolbarButtons.fontFamily: 'Font family'.i18n,
        ToolbarButtons.fontSize: 'Font size'.i18n,
        ToolbarButtons.bold: 'Bold'.i18n,
        ToolbarButtons.subscript: 'Subscript'.i18n,
        ToolbarButtons.superscript: 'Superscript'.i18n,
        ToolbarButtons.italic: 'Italic'.i18n,
        ToolbarButtons.small: 'Small'.i18n,
        ToolbarButtons.underline: 'Underline'.i18n,
        ToolbarButtons.strikeThrough: 'Strike through'.i18n,
        ToolbarButtons.inlineCode: 'Inline code'.i18n,
        ToolbarButtons.color: 'Font color'.i18n,
        ToolbarButtons.backgroundColor: 'Background color'.i18n,
        ToolbarButtons.clearFormat: 'Clear format'.i18n,
        ToolbarButtons.leftAlignment: 'Align left'.i18n,
        ToolbarButtons.centerAlignment: 'Align center'.i18n,
        ToolbarButtons.rightAlignment: 'Align right'.i18n,
        ToolbarButtons.justifyAlignment: 'Justify win width'.i18n,
        ToolbarButtons.direction: 'Text direction'.i18n,
        ToolbarButtons.headerStyle: 'Header style'.i18n,
        ToolbarButtons.listNumbers: 'Numbered list'.i18n,
        ToolbarButtons.listBullets: 'Bullet list'.i18n,
        ToolbarButtons.listChecks: 'Checked list'.i18n,
        ToolbarButtons.codeBlock: 'Code block'.i18n,
        ToolbarButtons.quote: 'Quote'.i18n,
        ToolbarButtons.indentIncrease: 'Increase indent'.i18n,
        ToolbarButtons.indentDecrease: 'Decrease indent'.i18n,
        ToolbarButtons.link: 'Insert URL'.i18n,
        ToolbarButtons.search: 'Search'.i18n,
      };

  //default font family values
  final fontFamilies =
      {
        'Dream': Fonts.dream,
        'Efectiva': Fonts.efectiva,
        'Floane': Fonts.floane,
        'Clear'.i18n: 'Clear'
      };
  QuillIconTheme? iconTheme;

  bool _isShowFontList = false;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    iconTheme = widget.iconTheme;
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        _isShowFontList
        ? SizedBox(
            width: 600,
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (_,index)=>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: material.Text("$index"),
                    )
            ))
            :const SizedBox(),
        ///需要 选择字体、字体颜色、加粗、下划线、斜体、删除、有序、无序列表、添加时间
        QuillToolbar(
          color: Colors.black, //multiRowsDisplay 为true时不生效
            axis: Axis.horizontal,
            toolbarSize: toolbarIconSize,
            toolbarSectionSpacing: toolbarSectionSpacing,
            toolbarIconAlignment: toolbarIconAlignment,
            toolbarIconCrossAlignment: toolbarIconCrossAlignment,
            customButtons: customButtons,
            locale: Locale("zh"),
            afterButtonPressed: afterButtonPressed,
            children: [
              // QuillFontFamilyButton(
              //   iconTheme: iconTheme,
              //   iconSize: toolbarIconSize,
              //   tooltip: buttonTooltips[ToolbarButtons.fontFamily],
              //   attribute: Attribute.font,
              //   controller: controller,
              //   rawItemsMap: fontFamilies,
              //   afterButtonPressed: afterButtonPressed,
              // ),
              // Builder(
              //   builder: (context) {
              //     return CustomButton(
              //       onPressed: () {
              //         SmartDialog.showAttach(
              //           maskColor: Colors.transparent,
              //           alignment: Alignment.topLeft,
              //             targetContext: context,
              //             targetBuilder: (targetOffset,size){
              //             print("targetOffset : $targetOffset , size : $size");
              //             return Offset(targetOffset.dx, targetOffset.dy + 336 - 10);
              //             },
              //             builder: (_){
              //           return Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 margin: const EdgeInsets.all(0),
              //                 // width: 100,
              //                 height: 50,
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.all(Radius.circular(20))
              //                     ,color: Colors.grey.shade600),
              //                 child: ListView.builder(
              //                     scrollDirection: Axis.horizontal,
              //                     itemCount: fontFamilies.length,
              //                     shrinkWrap:true,
              //                     itemBuilder: (_,index)=>
              //                         GestureDetector(
              //                           onTap:(){
              //                             if (!mounted) return;
              //                             setState(() {
              //                               if(index != fontFamilies.length - 1){
              //                                 widget.controller.formatSelection(Attribute.fromKeyValue('font', Fonts.list[index]));
              //                                 // widget.onSelected?.call(newValue);
              //                               }else{
              //                                 widget.controller.formatSelection(Attribute.fromKeyValue('font', null));
              //                               }
              //                             });
              //                           },
              //                           child: Container(
              //                             padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //                             child: material.Text("${fontFamilies.keys.toList()[index]}"),
              //                           ),
              //                         )
              //                 ),
              //               ),
              //               Container(
              //                   padding: const EdgeInsets.only(left: 37 + 6),
              //                 child: RotatedBox(quarterTurns: 1,child: Icon(Icons.play_arrow_rounded)),
              //               )
              //             ],
              //           );
              //         });
              //       },
              //         icon: Icons.font_download_rounded
              //     );
              //   }
              // ),
              Builder(builder: (context) => GestureDetector(
                  onTap: () => _showFontDialog(context),
                  child: Container(
                    color: Colors.white,
                    width: toolbarIconSize * 2,
                    height: toolbarIconSize * 2 - 4,
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black87
                      ),
                      child: material.Text("Aa",style: TextStyle(
                          fontFamily: _getCurrentFontFamily(),
                          color: Colors.white,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              )),
              MindsetColorButton(
                icon: Icons.color_lens,
                iconSize: toolbarIconSize,
                tooltip: buttonTooltips[ToolbarButtons.color],
                controller: controller,
                background: false,
                iconTheme: iconTheme,
                afterButtonPressed: afterButtonPressed,
              ),
              ToggleStyleButton(
                attribute: Attribute.bold,
                icon: Icons.format_bold,
                iconSize: toolbarIconSize,
                tooltip: buttonTooltips[ToolbarButtons.bold],
                controller: controller,
                iconTheme: iconTheme,
                afterButtonPressed: afterButtonPressed,
              ),
              ToggleStyleButton(
                attribute: Attribute.underline,
                icon: Icons.format_underline,
                iconSize: toolbarIconSize,
                tooltip: buttonTooltips[ToolbarButtons.underline],
                controller: controller,
                iconTheme: iconTheme,
                afterButtonPressed: afterButtonPressed,
              ),
              ToggleStyleButton(
                attribute: Attribute.italic,
                icon: Icons.format_italic,
                iconSize: toolbarIconSize,
                tooltip: buttonTooltips[ToolbarButtons.italic],
                controller: controller,
                iconTheme: iconTheme,
                afterButtonPressed: afterButtonPressed,
              ),
              ToggleStyleButton(
                attribute: Attribute.strikeThrough,
                icon: Icons.format_strikethrough,
                iconSize: toolbarIconSize,
                tooltip: buttonTooltips[ToolbarButtons.strikeThrough],
                controller: controller,
                iconTheme: iconTheme,
                afterButtonPressed: afterButtonPressed,
              ),
              ToggleStyleButton(
                attribute: Attribute.ol,
                tooltip: buttonTooltips[ToolbarButtons.listNumbers],
                controller: controller,
                icon: Icons.format_list_numbered,
                iconSize: toolbarIconSize,
                iconTheme: iconTheme,
                afterButtonPressed: afterButtonPressed,
              ),
              ToggleStyleButton(
                attribute: Attribute.ul,
                tooltip: buttonTooltips[ToolbarButtons.listBullets],
                controller: controller,
                icon: Icons.format_list_bulleted,
                iconSize: toolbarIconSize,
                iconTheme: iconTheme,
                afterButtonPressed: afterButtonPressed,
              ),
              CustomButton(onPressed: ()=>_insertTimeStamp(widget.controller), icon: Icons.access_time_filled),
              _buildCloseKeyboardButton()
            ])
      ],
    )
    ;
  }

  Widget _buildCloseKeyboardButton(){
    // if(Platform.isIOS) return null;
    return CustomButton(onPressed: (){
      FocusScopeNode currentFocus = FocusScope.of(context);
      if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null){
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }, icon: Icons.close_rounded);
  }

  void _showFontDialog(BuildContext context){
    SmartDialog.showAttach(
        maskColor: Colors.transparent,
        alignment: Alignment.topLeft,
        targetContext: context,
        targetBuilder: (targetOffset,size){
          print("targetOffset : $targetOffset , size : $size");
          return Offset(targetOffset.dx, targetOffset.dy + 336 - 10);
        },
        builder: _buildMindsetFontFamily
    );
  }

  String? _getCurrentFontFamily(){
    if(fontIndex == null) return null;
    if(fontIndex == fontFamilies.length - 1) return null;
    return Fonts.list[fontIndex!];
  }

  Widget _buildMindsetFontFamily(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(0),
          // width: 100,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))
              ,color: Colors.grey.shade600),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: fontFamilies.length,
              shrinkWrap:true,
              itemBuilder: (_,index)=>
                  GestureDetector(
                    onTap:(){
                      if (!mounted) return;
                      setState(() {
                        fontIndex = index;
                        if(index != fontFamilies.length - 1){
                          widget.controller.formatSelection(Attribute.fromKeyValue('font', Fonts.list[index]));
                          // widget.onSelected?.call(newValue);
                        }else{
                          widget.controller.formatSelection(Attribute.fromKeyValue('font', null));
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: material.Text("${fontFamilies.keys.toList()[index]}"),
                    ),
                  )
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 37 + 6),
          child: RotatedBox(quarterTurns: 1,child: Icon(Icons.play_arrow_rounded)),
        )
      ],
    );
  }

  void _insertTimeStamp(QuillController controller) {

    String time = DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(
      controller.selection.extentOffset,
      TimeStampEmbed(time),
    );

    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, ' ');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );
  }

  String? _getKeyName(String value) {
    for (final entry in fontFamilies.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return null;
  }


}
