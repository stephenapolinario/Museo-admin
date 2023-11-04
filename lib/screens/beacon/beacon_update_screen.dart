import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/services/beacon_service.dart';

class BeaconUpdateScreen extends StatefulWidget {
  final Beacon beacon;
  final Function onUpdate;

  const BeaconUpdateScreen({
    super.key,
    required this.beacon,
    required this.onUpdate,
  });

  @override
  State<BeaconUpdateScreen> createState() => _BeaconUpdateScreenState();
}

class _BeaconUpdateScreenState extends State<BeaconUpdateScreen> {
  final beaconCreateKey = GlobalKey<FormState>();
  late String? name, uuid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.loc.beacon_update_screen_title),
      ),
      body: Padding(
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
  }

  Widget fields(BuildContext context) {
    return Form(
      key: beaconCreateKey,
      // autovalidateMode: AutovalidateMode.always,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          nameInput(context),
          const SizedBox(height: 15),
          uuidInput(context),
        ],
      ),
    );
  }

  Widget nameInput(BuildContext context) {
    return Column(
      children: [
        // Input Name
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.beacon_screen_input_name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.beacon.name,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 10),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            errorStyle: TextStyle(
              color: Colors.red,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value == '') {
              return context.loc.create_beacon_screen_name_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            name = newValue;
          }),
        ),
      ],
    );
  }

  Widget uuidInput(BuildContext context) {
    return Column(
      children: [
        // Input Name
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.beacon_screen_input_uuid,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.beacon.uuid,
          decoration: InputDecoration(
            hintText: context.loc.beacon_screen_uuid_hint,
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
            RegExp regExp =
                RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');

            if (value != null) {
              if (!regExp.hasMatch(value)) {
                return context.loc.create_beacon_uuid_not_in_pattern;
              }
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            uuid = newValue;
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
            context.loc.beacon_update_screen_update_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = beaconCreateKey.currentState!.validate();

            if (isValid) {
              beaconCreateKey.currentState!.save();
              final createBeacon = await BeaconService().update(
                context,
                widget.beacon.id,
                name!,
                uuid!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: createBeacon == EnumBeaconStatus.success
                      ? context.loc.beacon_updated_successful_title
                      : context.loc.beacon_updated_error_title,
                  subtitle: createBeacon == EnumBeaconStatus.success
                      ? context.loc.beacon_updated_successful_subtitle
                      : context.loc.beacon_updated_error_subtitle,
                  context: context,
                );
                createBeacon == EnumBeaconStatus.success
                    ? navigator.pop()
                    : null;
              }
            }
          },
        ),
      ],
    );
  }
}
