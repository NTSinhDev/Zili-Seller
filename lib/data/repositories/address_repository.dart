import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

import '../models/address/region.dart';

class AddressRepository extends BaseRepository {
  final BehaviorSubject<List<CustomerAddress>> addresses = BehaviorSubject();
  Stream<List<CustomerAddress>> get addressesStream => addresses.stream;

  final BehaviorSubject<CustomerAddress> addressPayment = BehaviorSubject();
  final BehaviorSubject<List<Region>> preMergerProvinceDistrictList =
      BehaviorSubject<List<Region>>();
  final BehaviorSubject<List<Region>> postMergerProvinceDistrictList =
      BehaviorSubject<List<Region>>();
  final BehaviorSubject<List<Region>> wardsList =
      BehaviorSubject<List<Region>>();
  Stream<CustomerAddress> get addressPaymentStream => addressPayment.stream;

  @override
  Future<void> clean() async {
    addresses.drain(null);
    addressPayment.drain(null);
  }

  final BehaviorSubject<List<Location>> _provinces = BehaviorSubject();
  Stream<List<Location>> get provincesStream => _provinces.stream;
  List<Location> provincesOrigin = [];
  bool provincesHasValue() => _provinces.hasValue;
  void setDataProvincesStream(List<Location> provinces) {
    _provinces.sink.add(provinces);
  }

  final BehaviorSubject<List<Location>> _districts = BehaviorSubject();
  Stream<List<Location>> get districtsStream => _districts.stream;
  void setDataDistrictsStream(List<Location> districts) {
    _districts.sink.add(districts);
  }

  final BehaviorSubject<List<Location>> _wards = BehaviorSubject();
  Stream<List<Location>> get wardsStream => _wards.stream;
  void setDataWardsStream(List<Location> wards) {
    _wards.sink.add(wards);
  }
}
