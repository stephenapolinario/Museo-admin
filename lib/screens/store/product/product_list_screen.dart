import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/models/store/product.dart';
import 'package:museo_admin_application/screens/store/product/product_create_screen.dart';
import 'package:museo_admin_application/screens/store/product/product_update_screen.dart';
import 'package:museo_admin_application/services/store/product_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

// TODO: 1. Create a search by product category

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  late StreamController<List<Product>> _productStreamController;
  Stream<List<Product>> get onListProductChanged =>
      _productStreamController.stream;

  @override
  void initState() {
    super.initState();
    _productStreamController = StreamController<List<Product>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _productStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<Product> data = await ProductService().readAll(context);
    _productStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.product_screen_list),
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
                  builder: (BuildContext context) => ProductCreateScreen(
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
        child: StreamBuilder<List<Product>?>(
          stream: onListProductChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> productList = snapshot.data!;
              return productListWidget(productList);
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

  Widget productListWidget(List<Product> productList) {
    return SingleChildScrollView(
      child: Column(
        children: productList.map((currentProduct) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentProduct.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.store_mall_directory_outlined,
                color: Colors.black,
              ),
              title: Text(
                currentProduct.name,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentProduct.category.name,
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
                              ProductUpdateScreen(
                            product: currentProduct,
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
                        title: context.loc.product_sure_want_delete_title,
                        content: context.loc.product_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await ProductService().delete(context, currentProduct);
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
