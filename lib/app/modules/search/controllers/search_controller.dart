import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../widgets/search_item.dart';

class SearchController extends GetxController {
  List<Widget> searchItems = [];
  List<Item> items = [];

  @override
  void onInit() {
    items.add(
      Item(
        title: 'FPT University',
        address:
            'Lô E2a-7, Đường D1, Đ. D1, Long Thạnh Mỹ, Thành Phố Thủ Đức, Thành phố Hồ Chí Minh',
      ),
    );
    items.add(
      Item(
        title: 'Vinhomes Grand Park',
        address: 'Nguyễn Xiển, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh',
      ),
    );
    items.add(
      Item(
        title: '354 Nguyễn Văn Tăng',
        address: 'Long Thạnh Mỹ, District 9, Ho Chi Minh City, Vietnam',
      ),
    );
    items.add(
      Item(
        title: 'Trường ĐH Nguyễn Tất Thành',
        address: 'Long Thạnh Mỹ, District 9, Ho Chi Minh City, Vietnam',
      ),
    );
    items.add(
      Item(
        title: 'Công Ty Mekophar',
        address: 'Long Thạnh Mỹ, District 9, Ho Chi Minh City, Vietnam',
      ),
    );
    items.add(
      Item(
        title: 'Công Ty Filied Lê Văn Việt',
        address: 'Long Thạnh Mỹ, District 9, Ho Chi Minh City, Vietnam',
      ),
    );
    super.onInit();
  }

  var text = ''.obs;

  void onSearchChanged(String query) {
    text.value = query;
    if (query.isEmpty) {
      searchItems.clear();
      update();
      return;
    }

    searchItems.clear();
    for (Item item in items) {
      if (_contains(item.title, query) || _contains(item.address, query)) {
        var searchItem = SearchItem(
          title: item.title,
          description: item.address,
          onPressed: () {
            Get.back();
          },
        );
        searchItems.add(searchItem);
      }
    }

    for (int i = 0; i < 10; i++) {}
    update();
  }

  void clearSearchItems() {
    searchItems.clear();
  }

  bool _contains(String? text, String? keyword) {
    if (text == null || keyword == null) {
      return false;
    }
    var unSignText = TiengViet.parse(text.toLowerCase().trim());
    var unSignKeyword = TiengViet.parse(keyword.toLowerCase().trim());
    return unSignText.contains(unSignKeyword);
  }
}

class Item {
  String title;
  String address;

  Item({required this.title, required this.address});
}
