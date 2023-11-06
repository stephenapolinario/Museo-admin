import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/models/coupon/coupon_access.dart';
import 'package:museo_admin_application/models/coupon/coupon_type.dart';
import 'package:museo_admin_application/services/coupon/coupon_access_service.dart';
import 'package:museo_admin_application/services/coupon/coupon_service.dart';
import 'package:museo_admin_application/services/coupon/coupon_type_service.dart';

class CouponCreateScreen extends StatefulWidget {
  final Function onUpdate;

  const CouponCreateScreen({
    super.key,
    required this.onUpdate,
  });

  @override
  State<CouponCreateScreen> createState() => _CouponCreateScreenState();
}

class _CouponCreateScreenState extends State<CouponCreateScreen> {
  final couponCreateKey = GlobalKey<FormState>();
  // Because of coupon use couponTypes and couponAccess, we need to get this from the API...
  // 1. Coupon Access
  late List<CouponAccess> couponAccess;
  late List<MultiSelectItem<CouponAccess>> couponAccessItems;
  // 2. Coupon Type
  late List<CouponType> couponType;
  late List<MultiSelectItem<CouponType>> couponTypeItems;

  late String? code;
  late List<CouponAccess?> selectedCouponAccess = [];
  late List<CouponType?> selectedCouponType = [];
  late String value = '';
  late String percentage = '';

  // To prevent reload
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    couponAccess = await CouponAccessService().readAll(context);
    if (context.mounted) {
      couponType = await CouponTypeService().readAll(context);

      couponTypeItems = couponType
          .map(
            (couponType) => MultiSelectItem<CouponType>(
              couponType,
              couponType.type.toCapitalize(),
            ),
          )
          .toList();

      couponAccessItems = couponAccess
          .map(
            (couponAccess) => MultiSelectItem<CouponAccess>(
              couponAccess,
              couponAccess.access.toCapitalize(),
            ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.create_coupon_title),
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
      key: couponCreateKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          codeInput(context),
          const SizedBox(height: 15),
          typeInput(context),
          const SizedBox(height: 15),
          accessInput(context),
          const SizedBox(height: 15),
          valueInput(context),
          percentageInput(context),
        ],
      ),
    );
  }

  Widget percentageInput(BuildContext context) {
    return Visibility(
      visible: selectedCouponAccess
          .any((couponAccess) => couponAccess!.access == 'percentage'),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              context.loc.coupon_percentage_input_name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: context.loc.coupon_percentage_input_hint,
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
                return context.loc.create_coupon_screen_percentage_not_valid;
              }
              return null;
            },
            onSaved: (newValue) => setState(() {
              percentage = newValue!;
            }),
          ),
        ],
      ),
    );
  }

  Widget valueInput(BuildContext context) {
    return Visibility(
      visible: selectedCouponAccess
          .any((couponAccess) => couponAccess!.access == 'value'),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              context.loc.coupon_value_input_name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: context.loc.coupon_value_input_hint,
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
                return context.loc.create_coupon_screen_value_not_valid;
              }
              return null;
            },
            onSaved: (newValue) => setState(() {
              value = newValue!;
            }),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget accessInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.coupon_access_input_name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        MultiSelectBottomSheetField<CouponAccess?>(
          buttonText: Text(
            context.loc.coupon_select_input,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          buttonIcon: const Icon(Icons.search),
          items: couponAccessItems,
          listType: MultiSelectListType.LIST,
          validator: (values) {
            if (values == null || values.isEmpty) {
              return context.loc.create_coupon_screen_value_not_valid;
            }
            return null;
          },
          onConfirm: (values) {
            setState(() {
              selectedCouponAccess = values;
            });
          },
        ),
      ],
    );
  }

  Widget codeInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.coupon_code_input_name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.coupon_code_hint,
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
              return context.loc.create_coupon_screen_code_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            code = newValue;
          }),
        ),
      ],
    );
  }

  Widget typeInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.coupon_type_input_name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        MultiSelectBottomSheetField<CouponType?>(
          buttonText: Text(
            context.loc.coupon_select_input,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          buttonIcon: const Icon(Icons.search),
          items: couponTypeItems,
          listType: MultiSelectListType.LIST,
          validator: (values) {
            if (values == null || values.isEmpty) {
              return context.loc.create_coupon_coupon_type_fill;
            }
            return null;
          },
          onConfirm: (values) {
            setState(() {
              selectedCouponType = values;
            });
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
            context.loc.create_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = couponCreateKey.currentState!.validate();

            if (isValid) {
              couponCreateKey.currentState!.save();
              final variableFromService = await CouponService().create(
                context,
                code!,
                selectedCouponType,
                selectedCouponAccess,
                percentage != '' ? double.parse(percentage) : null,
                value != '' ? double.parse(value) : null,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: variableFromService == EnumCoupon.success
                      ? context.loc.create_coupon_success_title
                      : context.loc.create_coupon_error_title,
                  subtitle: variableFromService == EnumCoupon.success
                      ? context.loc.create_coupon_success_subtitle
                      : variableFromService == EnumCoupon.duplicatedCode
                          ? context
                              .loc.create_coupon_duplicated_code_error_content
                          : context.loc.create_coupon_error_content,
                  context: context,
                );
                variableFromService == EnumCoupon.success
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
