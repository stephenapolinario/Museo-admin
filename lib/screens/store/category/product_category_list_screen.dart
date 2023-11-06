import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/models/store/product_category.dart';
import 'package:museo_admin_application/screens/store/category/product_category_create_screen.dart';
import 'package:museo_admin_application/screens/store/category/product_category_update_screen.dart';
import 'package:museo_admin_application/services/store/product_category_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

class ProductCategoryListScreen extends StatefulWidget {
  const ProductCategoryListScreen({super.key});

  @override
  State<ProductCategoryListScreen> createState() =>
      ProductCategoryListScreenState();
}

class ProductCategoryListScreenState extends State<ProductCategoryListScreen> {
  late StreamController<List<ProductCategory>> _productCategoryStreamController;
  Stream<List<ProductCategory>> get onListproductCategoryChanged =>
      _productCategoryStreamController.stream;

  @override
  void initState() {
    super.initState();
    _productCategoryStreamController =
        StreamController<List<ProductCategory>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _productCategoryStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<ProductCategory> data =
        await ProductCategoryService().readAll(context);
    _productCategoryStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.product_category_screen_list),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      ProductCategoryCreateScreen(
                    onUpdate: () {
                      fetchData();
                    },
                  ),
                ),
              )
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: StreamBuilder<List<ProductCategory>?>(
          stream: onListproductCategoryChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductCategory> productCategoryList = snapshot.data!;
              return productCategoryListWidget(productCategoryList);
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget productCategoryListWidget(List<ProductCategory> productCategoryList) {
    return SingleChildScrollView(
      child: Column(
        children: productCategoryList.map((currentProductCategory) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentProductCategory.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.category,
                color: Colors.black,
              ),
              title: Text(
                context.loc.create_product_category_screen_list_title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentProductCategory.name,
                style: const TextStyle(
                  color: mainItemContentColor,
                ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              ProductCategoryUpdateScreen(
                            productCategory: currentProductCategory,
                            onUpdate: () {
                              fetchData();
                            },
                          ),
                        ),
                      );
                    },
                    child: Text(context.loc.pop_menu_button_update),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      final wantDelete = await showGenericDialog(
                        context: context,
                        title:
                            context.loc.product_category_sure_want_delete_title,
                        content: context
                            .loc.product_category_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await ProductCategoryService()
                            .delete(context, currentProductCategory);
                        fetchData();
                      }
                    },
                    child: Text(
                      context.loc.pop_menu_button_delete,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
