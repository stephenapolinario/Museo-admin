import 'package:flutter/material.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/models/store/product_category.dart';
import 'package:museo_admin_application/services/store/product_category_service.dart';
import 'package:museo_admin_application/services/store/product_service.dart';
import 'package:museo_admin_application/utilities/check_regex_color.dart';
import 'package:museo_admin_application/utilities/check_url.dart';

class ProductCreateScreen extends StatefulWidget {
  final Function onUpdate;

  const ProductCreateScreen({
    super.key,
    required this.onUpdate,
  });

  @override
  State<ProductCreateScreen> createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final productCreateKey = GlobalKey<FormState>();
  late String? name, description, image, size, color;
  late double? price;
  late List<ProductCategory> productCategories;

  // To prevent reload
  late Future<void> fetchDataFuture;

  late List<DropdownMenuItem<ProductCategory>> productCategoryItems;
  late ProductCategory? selectedProductCategory;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    productCategories = await ProductCategoryService().readAll(context);
    if (context.mounted) {
      productCategoryItems = productCategories
          .map<DropdownMenuItem<ProductCategory>>((ProductCategory value) {
        return DropdownMenuItem<ProductCategory>(
          value: value,
          child: Text(value.name),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.create_product_screen_title),
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
      key: productCreateKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          nameInput(context),
          const SizedBox(height: 15),
          descriptionInput(context),
          const SizedBox(height: 15),
          imageInput(context),
          const SizedBox(height: 15),
          priceInput(context),
          const SizedBox(height: 15),
          sizeInput(context),
          const SizedBox(height: 15),
          colorInput(context),
          const SizedBox(height: 15),
          productCategoryInput(context),
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
            context.loc.product_screen_name_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.product_screen_name_hint,
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
              return context.loc.product_screen_name_valid_error;
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

  Widget descriptionInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.product_screen_description_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.product_screen_description_hint,
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
              return context.loc.product_screen_description_valid_error;
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
            context.loc.product_screen_image_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.product_screen_image_hint,
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
            if (value == null || value == '' || !isUrl(value)) {
              return context.loc.product_screen_image_valid_error;
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

  Widget priceInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.product_screen_price_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.product_screen_price_hint,
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
              try {
                double.parse(value!);
              } catch (e) {
                return context.loc.product_screen_price_valid_error;
              }
              return context.loc.product_screen_price_valid_error;
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

  Widget sizeInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.product_screen_size_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.product_screen_size_hint,
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
              return context.loc.product_screen_size_valid_error;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            size = newValue;
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
            context.loc.product_screen_color_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.product_screen_color_hint,
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
            if (value == null || value == '' || !isHexColor(value)) {
              return context.loc.product_screen_color_valid_error;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            color = newValue;
          }),
        ),
      ],
    );
  }

  Widget productCategoryInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.product_screen_category_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButtonFormField<ProductCategory?>(
          // value: selectedQuiz,
          onChanged: (ProductCategory? newValue) {
            setState(() {
              selectedProductCategory = newValue;
            });
          },
          items: productCategoryItems,
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
        )
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
            final isValid = productCreateKey.currentState!.validate();

            if (isValid) {
              productCreateKey.currentState!.save();
              final object = await ProductService().create(
                context,
                name!,
                description!,
                image!,
                size!,
                price!,
                color!,
                selectedProductCategory!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: object == EnumProduct.success
                      ? context.loc.create_product_success_title
                      : context.loc.create_product_error_title,
                  subtitle: object == EnumProduct.success
                      ? context.loc.create_product_success_content
                      : context.loc.create_product_error_content,
                  context: context,
                );
                object == EnumProduct.success ? navigator.pop() : null;
              }
            }
          },
        ),
      ],
    );
  }
}
