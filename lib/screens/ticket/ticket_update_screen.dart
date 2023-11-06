import 'package:flutter/material.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/models/ticket.dart';
import 'package:museo_admin_application/services/ticket_service.dart';

class TicketUpdateScreen extends StatefulWidget {
  final Function onUpdate;
  final Ticket ticket;

  const TicketUpdateScreen({
    super.key,
    required this.ticket,
    required this.onUpdate,
  });

  @override
  State<TicketUpdateScreen> createState() => _TicketUpdateScreenState();
}

class _TicketUpdateScreenState extends State<TicketUpdateScreen> {
  final ticketCreateKey = GlobalKey<FormState>();
  late String? title, subtitle, description;
  late double? price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.update_ticket_screen_title),
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
      key: ticketCreateKey,
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
          priceInput(context),
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
            context.loc.ticket_screen_title_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.ticket.title,
          decoration: InputDecoration(
            hintText: context.loc.ticket_screen_title_hint,
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
              return context.loc.ticket_screen_title_valid_error;
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
            context.loc.ticket_screen_subtitle_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.ticket.subtitle,
          decoration: InputDecoration(
            hintText: context.loc.ticket_screen_subtitle_hint,
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
              return context.loc.ticket_screen_subtitle_valid_error;
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
            context.loc.ticket_screen_description_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.ticket.description,
          decoration: InputDecoration(
            hintText: context.loc.ticket_screen_description_hint,
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
              return context.loc.ticket_screen_description_valid_error;
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

  Widget priceInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.ticket_screen_price_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.ticket.price.toString(),
          decoration: InputDecoration(
            hintText: context.loc.ticket_screen_price_hint,
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
              final n = num.tryParse(value!);
              if (n == null || n < 0) {
                return context.loc.ticket_screen_price_valid_error;
              }
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            price = double.tryParse(newValue!);
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
            final isValid = ticketCreateKey.currentState!.validate();

            if (isValid) {
              ticketCreateKey.currentState!.save();
              final object = await TicketService().update(
                context,
                widget.ticket,
                title!,
                subtitle!,
                description!,
                price!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: object == EnumTicket.success
                      ? context.loc.update_ticket_success_title
                      : context.loc.update_ticket_error_title,
                  subtitle: object == EnumTicket.success
                      ? context.loc.update_ticket_success_content
                      : context.loc.update_ticket_error_content,
                  context: context,
                );
                object == EnumTicket.success ? navigator.pop() : null;
              }
            }
          },
        ),
      ],
    );
  }
}
