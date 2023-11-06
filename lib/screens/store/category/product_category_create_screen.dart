import 'package:flutter/material.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/services/store/product_category_service.dart';

class ProductCategoryCreateScreen extends StatefulWidget {
  final Function onUpdate;

  const ProductCategoryCreateScreen({
    super.key,
    required this.onUpdate,
  });

  @override
  State<ProductCategoryCreateScreen> createState() =>
      _ProductCategoryCreateScreenState();
}

class _ProductCategoryCreateScreenState
    extends State<ProductCategoryCreateScreen> {
  final productCategoryCreateKey = GlobalKey<FormState>();
  late String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.create_product_category_screen_title),
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
      key: productCategoryCreateKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          nameInput(context),
        ],
      ),
    );
  }

  Widget nameInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.product_category_screen_name_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.product_category_screen_name_hint,
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
              return context.loc.product_category_screen_name_valid_error;
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

  Widget enterButton(BuildContext context) {
    return Column(
      children: [
        // Enter
        const SizedBox(height: 20),
        TextButton(
          child: Text(
            context.loc.create_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = productCategoryCreateKey.currentState!.validate();

            if (isValid) {
              productCategoryCreateKey.currentState!.save();
              final object = await ProductCategoryService().create(
                context,
                name!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: object == EnumProductCategory.success
                      ? context.loc.create_product_category_success_title
                      : context.loc.create_product_category_error_title,
                  subtitle: object == EnumProductCategory.success
                      ? context.loc.create_product_category_success_content
                      : context.loc.create_product_category_error_content,
                  context: context,
                );
                object == EnumProductCategory.success ? navigator.pop() : null;
              }
            }
          },
        ),
      ],
    );
  }
}
