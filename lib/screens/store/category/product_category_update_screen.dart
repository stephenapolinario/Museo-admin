import 'package:flutter/material.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/models/store/product_category.dart';
import 'package:museo_admin_application/services/store/product_category_service.dart';

class ProductCategoryUpdateScreen extends StatefulWidget {
  final ProductCategory productCategory;
  final Function onUpdate;

  const ProductCategoryUpdateScreen({
    super.key,
    required this.productCategory,
    required this.onUpdate,
  });

  @override
  State<ProductCategoryUpdateScreen> createState() =>
      _ProductCategoryUpdateScreenState();
}

class _ProductCategoryUpdateScreenState
    extends State<ProductCategoryUpdateScreen> {
  final productCategoryCreateKey = GlobalKey<FormState>();
  late String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.update_product_category_screen_title),
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
          initialValue: widget.productCategory.name,
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
            context.loc.update_button,
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
              final object = await ProductCategoryService().update(
                context,
                widget.productCategory,
                name!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: object == EnumProductCategory.success
                      ? context.loc.update_product_category_success_title
                      : context.loc.update_product_category_error_title,
                  subtitle: object == EnumProductCategory.success
                      ? context.loc.update_product_category_success_content
                      : context.loc.update_product_category_error_content,
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
