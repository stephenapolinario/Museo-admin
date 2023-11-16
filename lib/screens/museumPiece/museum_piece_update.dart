import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/color.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/helpers/color_pick.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/models/museum_piece.dart';
import 'package:museo_admin_application/models/tour.dart';
import 'package:museo_admin_application/services/beacon_service.dart';
import 'package:museo_admin_application/services/museum_piece_service.dart';
import 'package:museo_admin_application/services/tour_service.dart';

class MuseumPieceUpdateScreen extends StatefulWidget {
  final Function onUpdate;
  final MuseumPiece museumPiece;

  const MuseumPieceUpdateScreen({
    super.key,
    required this.museumPiece,
    required this.onUpdate,
  });

  @override
  State<MuseumPieceUpdateScreen> createState() =>
      _MuseumPieceUpdateScreenState();
}

class _MuseumPieceUpdateScreenState extends State<MuseumPieceUpdateScreen> {
  final museumPieceUpdateKey = GlobalKey<FormState>();
  late String? title, subtitle, description, image;
  late int? rssi;
  Beacon? selectedBeacon;
  Tour? selectedTour;
  Color? color;

  late List<Beacon> beaconList;
  late List<Tour> tourList;

  // To prevent reload
  late Future<void> fetchDataFuture;

  late List<DropdownMenuItem<Beacon>> beaconItems;
  late List<DropdownMenuItem<Tour>> tourItems;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    beaconList = await BeaconService().readAll(context);
    if (context.mounted) {
      tourList = await TourService().readAll(context);

      beaconItems = beaconList.map<DropdownMenuItem<Beacon>>((Beacon value) {
        return DropdownMenuItem<Beacon>(
          value: value,
          child: Text(value.name),
        );
      }).toList();

      tourItems = tourList.map<DropdownMenuItem<Tour>>((Tour value) {
        return DropdownMenuItem<Tour>(
          value: value,
          child: Text(value.title),
        );
      }).toList();

      selectedBeacon = beaconList.firstWhere(
        (beacon) => beacon.id == widget.museumPiece.beacon?.id,
      );

      selectedTour = tourList.firstWhere(
        (tour) => tour.id == widget.museumPiece.tour?.id,
      );
    }
  }

  void onUpdateColor(Color value) {
    setState(() {
      color = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.update_museum_piece_screen_title),
      ),
      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
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
              );
            default:
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
          }
        },
      ),
    );
  }

  Widget fields(BuildContext context) {
    return Form(
      key: museumPieceUpdateKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          titleInput(context),
          const SizedBox(height: 15),
          subtitleInput(context),
          const SizedBox(height: 15),
          descriptionInput(context),
          const SizedBox(height: 15),
          imageInput(context),
          const SizedBox(height: 15),
          rssiInput(context),
          const SizedBox(height: 15),
          colorInput(context),
          const SizedBox(height: 15),
          beaconInput(context),
          const SizedBox(height: 15),
          tourInput(context),
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
            context.loc.museum_peice_screen_title_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.museumPiece.title,
          decoration: InputDecoration(
            hintText: context.loc.museum_peice_screen_title_hint,
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
              return context.loc.museum_peice_screen_title_not_valid;
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
            context.loc.museum_peice_screen_subtitle_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.museumPiece.subtitle,
          decoration: InputDecoration(
            hintText: context.loc.museum_peice_screen_subtitle_hint,
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
              return context.loc.museum_peice_screen_subtitle_not_valid;
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

  Widget descriptionInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_peice_screen_description_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.museumPiece.description,
          decoration: InputDecoration(
            hintText: context.loc.museum_peice_screen_description_hint,
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
              return context.loc.museum_peice_screen_description_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            description = newValue;
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
            context.loc.museum_peice_screen_image_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.museumPiece.image,
          decoration: InputDecoration(
            hintText: context.loc.museum_peice_screen_image_hint,
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
                return context.loc.museum_peice_screen_image_not_valid;
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

  Widget rssiInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_peice_screen_rssi_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.museumPiece.rssi.toString(),
          decoration: InputDecoration(
            hintText: context.loc.museum_peice_screen_rssi_hint,
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
            if (value == null) {
              return context.loc.museum_peice_screen_rssi_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            rssi = int.tryParse(newValue!);
          }),
        ),
      ],
    );
  }

  Widget colorInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_peice_pick_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        colorPick(
          context,
          color ?? widget.museumPiece.color.fromHex(),
          onUpdateColor,
        ),
      ],
    );
  }

  Widget beaconInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_peice_screen_beacon_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButtonFormField<Beacon?>(
          value: selectedBeacon,
          onChanged: (Beacon? newValue) {
            setState(() {
              selectedBeacon = newValue;
            });
          },
          items: beaconItems,
          decoration: InputDecoration(
            hintText: context.loc.museum_peice_screen_beacon_hint,
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
            if (value == null) {
              return context.loc.museum_peice_screen_beacon_not_valid;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget tourInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_peice_screen_tour_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButtonFormField<Tour?>(
          value: selectedTour,
          onChanged: (Tour? newValue) {
            setState(() {
              selectedTour = newValue;
            });
          },
          items: tourItems,
          decoration: InputDecoration(
            hintText: context.loc.museum_peice_screen_tour_hint,
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
            if (value == null) {
              return context.loc.museum_peice_screen_tour_not_valid;
            }
            return null;
          },
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
            final isValid = museumPieceUpdateKey.currentState!.validate();

            if (isValid) {
              museumPieceUpdateKey.currentState!.save();
              final museumPiece = await MuseumPieceService().update(
                context,
                widget.museumPiece,
                title!,
                subtitle!,
                description!,
                image!,
                rssi!,
                color == null ? widget.museumPiece.color : color!.toHex(),
                selectedBeacon!,
                selectedTour!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: museumPiece == EnumMuseumPiece.success
                      ? context.loc.update_museum_piece_success_title
                      : context.loc.update_museum_piece_error_title,
                  subtitle: museumPiece == EnumMuseumPiece.success
                      ? context.loc.update_museum_piece_success_content
                      : context.loc.update_museum_piece_error_content,
                  context: context,
                );
                museumPiece == EnumMuseumPiece.success ? navigator.pop() : null;
              }
            }
          },
        ),
      ],
    );
  }
}
