import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/cart/cart.dart';
import 'package:zili_coffee/data/models/cart/deliver_price.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';
import 'package:zili_coffee/data/models/order/order_export.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

class CartRepository extends BaseRepository {
  final BehaviorSubject<Cart> _behaviorProductCart = BehaviorSubject<Cart>();
  Stream<Cart> get cartStream => _behaviorProductCart.stream;
  Cart? _cart;
  Cart? get cart => _cart;
  set cart(Cart? cart) {
    _cart = cart;
    storage.cart = cart;
  }

  CartRepository() {
    _cart ??= storage.cart;
    if (_cart != null) {
      _behaviorProductCart.sink.add(_cart!);
    }
  }

  // Payment
  final behaviorDeliverPrice = BehaviorSubject<DeliverPrice>();
  Stream<DeliverPrice> get deliverPriceStream => behaviorDeliverPrice.stream;
  List<PaymentMethod> paymenMethods = [];

  void updateQty(ProductCart prodCart) {
    List<ProductCart> products = _behaviorProductCart.value.products;
    int index = _findProduct(prodCart);
    if (index != -1) {
      products[index] = prodCart;
      final newCart = Cart(
        products: products,
        totalPrice: updateTotalPrice(products),
      );
      _behaviorProductCart.sink.add(newCart);
      cart = newCart;
    }
  }

  void deleteCartItem(ProductCart prodCart) {
    List<ProductCart> data = _behaviorProductCart.value.products;
    int index = _findProduct(prodCart);
    if (index != -1) {
      data.removeAt(index);
      final newCart = Cart(
        products: data,
        totalPrice: updateTotalPrice(data),
      );
      _behaviorProductCart.sink.add(newCart);
      cart = newCart;
    }
  }

  void updateInfoProductCart(ProductCart prodCart) {
    List<ProductCart> data = _behaviorProductCart.value.products;
    int index = _findProduct(prodCart);
    if (index == -1) return;
    data[index] = prodCart;
    _cart = _cart!.copyWith(
      products: data,
      totalPrice: updateTotalPrice(data),
    );
    _behaviorProductCart.sink.add(_cart!);
  }

  void addToCart(ProductCart prodCart) {
    if (!_behaviorProductCart.hasValue) {
      _cart ??= Cart(
        products: [prodCart],
        totalPrice: prodCart.pricePromotion ?? prodCart.price ?? 0,
      );
      _behaviorProductCart.sink.add(_cart!);
      storage.cart = _cart;
    } else {
      List<ProductCart> products = _behaviorProductCart.value.products;

      // Check duplicate value
      int index = _findProduct(prodCart);
      if (index != -1) {
        products[index] =
            products[index].copyWith(qty: products[index].qty + prodCart.qty);
      } else {
        products.add(prodCart);
      }
      final newCart = Cart(
        products: products,
        totalPrice: updateTotalPrice(products),
      );
      _behaviorProductCart.sink.add(newCart);
      cart = newCart;
    }
  }

  int updateTotalPrice(List<ProductCart> data) {
    int totalPrice = 0;
    for (var i = 0; i < data.length; i++) {
      final price = data[i].pricePromotion ?? data[i].price ?? 0;
      totalPrice += data[i].qty * price;
    }
    return totalPrice;
  }

  int _findProduct(ProductCart prodCart) {
    List<ProductCart> data = _behaviorProductCart.value.products;
    int index = data.indexWhere((prod) =>
        prod.productID == prodCart.productID &&
        prod.option1 == prodCart.option1 &&
        prod.option2 == prodCart.option2 &&
        prod.option3 == prodCart.option3);
    return index;
  }

  @override
  Future<void> clean() async {
    final Cart emptyCart = Cart(products: [], totalPrice: 0);
    _behaviorProductCart.sink.add(emptyCart);
    cart = emptyCart;
  }
}
