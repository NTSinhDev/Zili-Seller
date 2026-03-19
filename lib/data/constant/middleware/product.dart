part of '../data_constant.dart';


class _Product {
  final String status = "trang-thai";
  final String activeStatus = "active";
  final String priceFrom = "giatu";
  final String priceTo = "giaden";
  final String from = "tu";
  final String to = "den";
  final String filter = "loc";
  final String style = "kieu";
  final String type = "loai";
  final String brand = "brand";
  final String ziliCoffee = "Zili Coffee";

  final _FilterValue filterValue = _FilterValue();
  final _StyleValue styleValue = _StyleValue();
  final _TypeValue typeValue = _TypeValue();
}

class _FilterValue {
  final String newest = "hàng mới";
  final String bestSeller = "bán chạy";
  final String cheap = "giá thấp";
  final String expensive = "giá cao";
  final String arrangement = "sắp xếp";
}

class _StyleValue {
  final String outlet = "outlet";
  final String shockingDeal = "deal-soc";
  final String topDiscount = "giam-gia-mua-nhieu";
  final String discount = "giam-gia";
  final String style = "kiểu";
}

class _TypeValue {
  final String experience = "Trải Nghiệm";
  final String traditional = "Truyền Thống";
  final String forStore = "Cho Quán";
  final String convenient = "Phin Nhanh";
  final String zili = "Sản Phẩm Zili";
}
