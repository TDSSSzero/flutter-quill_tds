import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:flutter/material.dart' as material;



/// Controls color styles.
///
/// When pressed, this button displays overlay toolbar with
/// buttons for each color.
class MindsetColorButton extends StatefulWidget {
  const MindsetColorButton({
    required this.icon,
    required this.controller,
    required this.background,
    this.iconSize = kDefaultIconSize,
    this.iconTheme,
    this.afterButtonPressed,
    this.tooltip,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final bool background;
  final QuillController controller;
  final QuillIconTheme? iconTheme;
  final VoidCallback? afterButtonPressed;
  final String? tooltip;

  @override
  _MindsetColorButtonState createState() => _MindsetColorButtonState();
}

class _MindsetColorButtonState extends State<MindsetColorButton> {
  late bool _isToggledColor;
  late bool _isToggledBackground;
  late bool _isWhite;
  late bool _isWhiteBackground;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  Color _currentColor = Colors.black;

  void _didChangeEditingValue() {
    setState(() {
      _isToggledColor =
          _getIsToggledColor(widget.controller.getSelectionStyle().attributes);
      _isToggledBackground = _getIsToggledBackground(
          widget.controller.getSelectionStyle().attributes);
      _isWhite = _isToggledColor &&
          _selectionStyle.attributes['color']!.value == '#ffffff';
      _isWhiteBackground = _isToggledBackground &&
          _selectionStyle.attributes['background']!.value == '#ffffff';
    });
  }

  @override
  void initState() {
    super.initState();
    _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
    _isToggledBackground = _getIsToggledBackground(_selectionStyle.attributes);
    _isWhite = _isToggledColor &&
        _selectionStyle.attributes['color']!.value == '#ffffff';
    _isWhiteBackground = _isToggledBackground &&
        _selectionStyle.attributes['background']!.value == '#ffffff';
    widget.controller.addListener(_didChangeEditingValue);
  }

  bool _getIsToggledColor(Map<String, Attribute> attrs) {
    return attrs.containsKey(Attribute.color.key);
  }

  bool _getIsToggledBackground(Map<String, Attribute> attrs) {
    return attrs.containsKey(Attribute.background.key);
  }

  @override
  void didUpdateWidget(covariant MindsetColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
      _isToggledBackground =
          _getIsToggledBackground(_selectionStyle.attributes);
      _isWhite = _isToggledColor &&
          _selectionStyle.attributes['color']!.value == '#ffffff';
      _isWhiteBackground = _isToggledBackground &&
          _selectionStyle.attributes['background']!.value == '#ffffff';
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = _isToggledColor && !widget.background && !_isWhite
        ? stringToColor(_selectionStyle.attributes['color']!.value)
        : (widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color);

    final iconColorBackground =
    _isToggledBackground && widget.background && !_isWhiteBackground
        ? stringToColor(_selectionStyle.attributes['background']!.value)
        : (widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color);

    final fillColor = _isToggledColor && !widget.background && _isWhite
        ? stringToColor('#ffffff')
        : (widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor);
    final fillColorBackground =
    _isToggledBackground && widget.background && _isWhiteBackground
        ? stringToColor('#ffffff')
        : (widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor);

    return QuillIconButton(
      tooltip: widget.tooltip,
      highlightElevation: 0,
      hoverElevation: 0,
      size: widget.iconSize * kIconButtonFactor,
      icon: Icon(widget.icon,
          size: widget.iconSize,
          color: widget.background ? iconColorBackground : iconColor),
      fillColor: widget.background ? fillColorBackground : fillColor,
      borderRadius: widget.iconTheme?.borderRadius ?? 2,
      onPressed: _showColorPicker,
      afterPressed: widget.afterButtonPressed,
    );
  }

  void _changeColor(BuildContext context, Color color) {
    var hex = colorToHex(color);
    hex = '#$hex';
    widget.controller.formatSelection(
        widget.background ? BackgroundAttribute(hex) : ColorAttribute(hex));
  }

  void _showColorPicker() {
    var pickerType = 'material';

    var selectedColor = Colors.black;

    if (_isToggledColor) {
      selectedColor = widget.background
          ? hexToColor(_selectionStyle.attributes['background']?.value)
          : hexToColor(_selectionStyle.attributes['color']?.value);
    }

    // final hexController =
    // TextEditingController(text: colorToHex(selectedColor));
    late void Function(void Function()) colorBoxSetState;

    showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, dlgSetState) {
        return AlertDialog(
            title: const material.Text('Select Color'),
            actions: [
              TextButton(
                  onPressed: () {
                    _changeColor(context, _currentColor);
                    Navigator.of(context).pop();
                  },
                  child: const material.Text('OK')),
            ],
            backgroundColor: Theme.of(context).canvasColor,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            dlgSetState(() {
                              pickerType = 'material';
                            });
                          },
                          child: const material.Text('Material')),
                      TextButton(
                          onPressed: () {
                            dlgSetState(() {
                              pickerType = 'color';
                            });
                          },
                          child: const material.Text('Color')),
                    ],
                  ),
                  Column(children: [
                    if (pickerType == 'material')
                      MaterialPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (color) {
                          _changeColor(context, color);
                          Navigator.of(context).pop();
                        },
                      ),
                    if (pickerType == 'color')
                      ColorPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (color) {
                          // _changeColor(context, color);
                          // hexController.text = colorToHex(color);
                          _currentColor = color;
                          selectedColor = color;
                          colorBoxSetState(() {});
                        },
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        // SizedBox(
                        //   width: 100,
                        //   height: 60,
                        //   child:
                        //   TextFormField(
                        //     controller: hexController,
                        //     onChanged: (value) {
                        //       selectedColor = hexToColor(value);
                        //       _changeColor(context, selectedColor);
                        //
                        //       colorBoxSetState(() {});
                        //     },
                        //     decoration: InputDecoration(
                        //       labelText: 'Hex',
                        //       border: const OutlineInputBorder(),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        StatefulBuilder(builder: (context, mcolorBoxSetState) {
                          colorBoxSetState = mcolorBoxSetState;
                          return Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black45,
                              ),
                              color: selectedColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          );
                        }),
                      ],
                    ),
                  ])
                ],
              ),
            ));
      }),
    );
  }

  Color hexToColor(String? hexString) {
    if (hexString == null) {
      return Colors.black;
    }
    final hexRegex = RegExp(r'([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$');

    hexString = hexString.replaceAll('#', '');
    if (!hexRegex.hasMatch(hexString)) {
      return Colors.black;
    }

    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString);
    return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0xFF000000);
  }

  String colorToHex(Color color) {
    return color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
  }
  Color stringToColor(String? s, [Color? originalColor]) {
    switch (s) {
      case 'transparent':
        return Colors.transparent;
      case 'black':
        return Colors.black;
      case 'black12':
        return Colors.black12;
      case 'black26':
        return Colors.black26;
      case 'black38':
        return Colors.black38;
      case 'black45':
        return Colors.black45;
      case 'black54':
        return Colors.black54;
      case 'black87':
        return Colors.black87;
      case 'white':
        return Colors.white;
      case 'white10':
        return Colors.white10;
      case 'white12':
        return Colors.white12;
      case 'white24':
        return Colors.white24;
      case 'white30':
        return Colors.white30;
      case 'white38':
        return Colors.white38;
      case 'white54':
        return Colors.white54;
      case 'white60':
        return Colors.white60;
      case 'white70':
        return Colors.white70;
      case 'red':
        return Colors.red;
      case 'redAccent':
        return Colors.redAccent;
      case 'amber':
        return Colors.amber;
      case 'amberAccent':
        return Colors.amberAccent;
      case 'yellow':
        return Colors.yellow;
      case 'yellowAccent':
        return Colors.yellowAccent;
      case 'teal':
        return Colors.teal;
      case 'tealAccent':
        return Colors.tealAccent;
      case 'purple':
        return Colors.purple;
      case 'purpleAccent':
        return Colors.purpleAccent;
      case 'pink':
        return Colors.pink;
      case 'pinkAccent':
        return Colors.pinkAccent;
      case 'orange':
        return Colors.orange;
      case 'orangeAccent':
        return Colors.orangeAccent;
      case 'deepOrange':
        return Colors.deepOrange;
      case 'deepOrangeAccent':
        return Colors.deepOrangeAccent;
      case 'indigo':
        return Colors.indigo;
      case 'indigoAccent':
        return Colors.indigoAccent;
      case 'lime':
        return Colors.lime;
      case 'limeAccent':
        return Colors.limeAccent;
      case 'grey':
        return Colors.grey;
      case 'blueGrey':
        return Colors.blueGrey;
      case 'green':
        return Colors.green;
      case 'greenAccent':
        return Colors.greenAccent;
      case 'lightGreen':
        return Colors.lightGreen;
      case 'lightGreenAccent':
        return Colors.lightGreenAccent;
      case 'blue':
        return Colors.blue;
      case 'blueAccent':
        return Colors.blueAccent;
      case 'lightBlue':
        return Colors.lightBlue;
      case 'lightBlueAccent':
        return Colors.lightBlueAccent;
      case 'cyan':
        return Colors.cyan;
      case 'cyanAccent':
        return Colors.cyanAccent;
      case 'brown':
        return Colors.brown;
    }

    if (s!.startsWith('rgba')) {
      s = s.substring(5); // trim left 'rgba('
      s = s.substring(0, s.length - 1); // trim right ')'
      final arr = s.split(',').map((e) => e.trim()).toList();
      return Color.fromRGBO(int.parse(arr[0]), int.parse(arr[1]),
          int.parse(arr[2]), double.parse(arr[3]));
    }

    // TODO: take care of "color": "inherit"
    if (s.startsWith('inherit')) {
      return originalColor ?? Colors.black;
    }

    if (!s.startsWith('#')) {
      throw 'Color code not supported';
    }

    var hex = s.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff$hex' : hex;
    final val = int.parse(hex, radix: 16);
    return Color(val);
  }
}
