import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/status_bar.dart';
import '../../../core/widget/unfocus.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      brightness: Brightness.dark,
      child: Unfocus(
        child: Scaffold(
          body: Column(
            children: [
              _searchBar(),
              SizedBox(
                height: 10.h,
              ),
              GetBuilder<SearchController>(
                builder: (_) {
                  if (controller.text.isEmpty) {
                    return Text(
                      'Nhập để tìm kiếm',
                      style: body2.copyWith(color: AppColors.description),
                    );
                  } else if (controller.searchItems.isEmpty) {
                    return Text(
                      'Không tìm thấy kết quả',
                      style: body2.copyWith(color: AppColors.description),
                    );
                  } else {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: controller.searchItems,
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _searchBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      padding:
          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w, bottom: 10.h),
      child: Wrap(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: AppColors.surface,
                  ),
                  child: TextFormField(
                    onChanged: controller.onSearchChanged,
                    decoration: mapSearchOutlined(
                      prefixIcon: InkWell(
                        onTap: () {
                          controller.clearSearchItems();
                          Get.back();
                        },
                        child: SizedBox(
                          height: 22.w,
                          width: 22.w,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18.r,
                            color: AppColors.lightBlack,
                          ),
                        ),
                      ),
                      hintText: 'Tìm kiếm trạm',
                    ),
                    autofocus: true,
                    // onSaved: (value) => controller.password = value,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration mapSearchOutlined({
    Widget? prefixIcon,
    String labelText = "",
    String hintText = "",
    bool state = false,
    Function()? suffixAction,
  }) {
    return InputDecoration(
      errorStyle: caption,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
      ),
      labelText: labelText,
      hintText: hintText,
      labelStyle: subtitle1.copyWith(
        color: AppColors.description,
      ),
      hintStyle: subtitle1.copyWith(
        color: AppColors.description,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: prefixIcon,
            )
          : null,
      suffixIcon: state
          ? TextButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.all(0),
                minimumSize: Size(40.r, 40.r),
              ),
              onPressed: suffixAction,
              child: const Icon(
                Icons.cancel_outlined,
                color: AppColors.softBlack,
              ),
            )
          : null,
    );
  }
}
