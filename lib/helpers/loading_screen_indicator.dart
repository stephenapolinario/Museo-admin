import 'dart:async';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/gen/assets.gen.dart';

class LoadingScreenIndicator {
  factory LoadingScreenIndicator() => _shared;
  static final LoadingScreenIndicator _shared =
      LoadingScreenIndicator._sharedInstance();
  LoadingScreenIndicator._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String title,
  }) {
    if (controller?.update(title) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        title: title,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String title,
  }) {
    final text0 = StreamController<String>();
    text0.add(title);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: size.height * 0.3,
                minWidth: double.infinity,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.logos.moviBigPng.path,
                      height: size.height * 0.12,
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: mainBlue,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });

    state.insert(overlay);

    return LoadingScreenController(close: () {
      text0.close();
      overlay.remove();
      return true;
    }, update: (text) {
      text0.add(text);
      return true;
    });
  }
}

class LoadingScreenController {
  final Function close;
  final Function update;

  LoadingScreenController({required this.close, required this.update});
}
