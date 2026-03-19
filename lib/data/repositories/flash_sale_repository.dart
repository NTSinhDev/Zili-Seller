import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

class FlashSaleRepository extends BaseRepository {
  final BehaviorSubject<List<Product>> productStreamData = BehaviorSubject();

  @override
  Future<void> clean() async {
    productStreamData.sink.add([]);
  }
}
