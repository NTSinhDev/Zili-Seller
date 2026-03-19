enum PositionType { employee, businessOwner }

enum DefaultPrice {
  purchasePrice,
  costPrice,
  retailPrice,
  wholesalePrice;

  static String defaultPriceName(DefaultPrice price) {
    switch (price) {
      case DefaultPrice.costPrice:
        return 'Giá nhập';
      case DefaultPrice.retailPrice:
        return 'Giá bán lẻ';
      case DefaultPrice.wholesalePrice:
        return 'Giá bán buôn';
      case DefaultPrice.purchasePrice:
        return 'Giá mua';
    }
  }
}

enum AuthFailedType { notFoundUser, incorrectPassword }
