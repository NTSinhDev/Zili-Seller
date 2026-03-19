import 'package:zili_coffee/data/repositories/base_repository.dart';

class StoreRepository extends BaseRepository {
  String storeNamed = '';
  String storeOwner = '';
  String storeRegion = '';

  @override
  Future<void> clean() async {}
}
