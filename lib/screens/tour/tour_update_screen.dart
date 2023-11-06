import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/models/tour.dart';
import 'package:museo_admin_application/services/tour_service.dart';

class TourUpdateScreen extends StatefulWidget {
  final Function onUpdate;
  final Tour tour;

  const TourUpdateScreen({
    super.key,
    required this.tour,
    required this.onUpdate,
  });

  @override
  State<TourUpdateScreen> createState() => TourUpdateScreenState();
}

class TourUpdateScreenState extends State<TourUpdateScreen> {
  final tourUpdateKey = GlobalKey<FormState>();
  late String? title, subtitle, image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(
          context.loc.update_tour_screen_title.toCapitalizeEveryInitialWord(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          child: Column(
            children: [
              fields(context),
              enterButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget fields(BuildContext context) {
    return Form(
      key: tourUpdateKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          titleInput(context),
          const SizedBox(height: 15),
          subtitleInput(context),
          const SizedBox(height: 15),
          imageInput(context),
        ],
      ),
    );
  }

  Widget titleInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.tour_title_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.tour.title,
          decoration: InputDecoration(
            hintText: context.loc.tour_title_hint,
            contentPadding: const EdgeInsets.only(left: 10),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value == '') {
              return context.loc.tour_title_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            title = newValue;
          }),
        ),
      ],
    );
  }

  Widget subtitleInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.tour_subtitle_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.tour.subtitle,
          decoration: InputDecoration(
            hintText: context.loc.tour_title_hint,
            contentPadding: const EdgeInsets.only(left: 10),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                // width: 2,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value == '') {
              return context.loc.tour_subtitle_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            subtitle = newValue;
          }),
        ),
      ],
    );
  }

  Widget imageInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.tour_image_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.tour.image,
          decoration: InputDecoration(
            hintText: context.loc.tour_image_hint,
            contentPadding: const EdgeInsets.only(left: 10),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                // width: 2,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value != null) {
              bool validURL = Uri.tryParse(value)?.hasAbsolutePath ?? false;
              if (!validURL) {
                return context.loc.tour_image_not_valid;
              }
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            image = newValue;
          }),
        ),
      ],
    );
  }

  Widget enterButton(BuildContext context) {
    return Column(
      children: [
        // Enter
        const SizedBox(height: 20),
        TextButton(
          child: Text(
            context.loc.update_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = tourUpdateKey.currentState!.validate();

            if (isValid) {
              tourUpdateKey.currentState!.save();
              final object = await TourService().update(
                context,
                widget.tour,
                title!,
                subtitle!,
                image!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: object == EnumTour.success
                      ? context.loc.update_tour_success_title
                      : context.loc.update_tour_error_title,
                  subtitle: object == EnumTour.success
                      ? context.loc.update_tour_success_content
                      : context.loc.update_tour_error_content,
                  context: context,
                );
                object == EnumTour.success ? navigator.pop() : null;
              }
            }
          },
        ),
      ],
    );
  }
}
