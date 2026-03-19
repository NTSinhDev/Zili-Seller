part 'middleware/order.dart';
part 'middleware/product.dart';
part 'middleware/address.dart';
part 'middleware/review.dart';
part 'middleware/app.dart';


class MiddlewareConstant {
  static final product = _Product();
  static final order = _Order();
  static final adress = _Address();
  static final review = _Review();
  static final app = _App();
}