import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Widget colorPick(
  BuildContext context,
  Color? color,
  Function(Color color) onUpdateColor,
) {
  return RawMaterialButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: MediaQuery.of(context).orientation ==
                      Orientation.portrait
                  ? const BorderRadius.vertical(
                      top: Radius.circular(500),
                      bottom: Radius.circular(100),
                    )
                  : const BorderRadius.horizontal(right: Radius.circular(500)),
            ),
            content: SingleChildScrollView(
              child: HueRingPicker(
                pickerColor: color ?? Colors.black,
                enableAlpha: true,
                onColorChanged: (value) {
                  onUpdateColor(value);
                },
              ),
            ),
          );
        },
      );
    },
    elevation: 2.0,
    fillColor: color ?? Colors.black,
    padding: const EdgeInsets.all(15.0),
    shape: const CircleBorder(),
    constraints: const BoxConstraints(
      minWidth: 45.0,
      minHeight: 45.0,
    ),
  );
}
