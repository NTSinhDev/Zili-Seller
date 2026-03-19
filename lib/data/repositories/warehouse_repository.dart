import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';
import 'package:zili_coffee/data/models/warehouse/roasting_slip.dart';
import 'package:zili_coffee/data/models/warehouse/packing_slip.dart';

import '../../utils/enums/warehouse_enum.dart';
import '../models/warehouse/packing_slip_item.dart';
import '../models/warehouse/warehouse.dart';

class WarehouseRepository extends BaseRepository {
  //* Warehouses - Branches
  final BehaviorSubject<List<Warehouse>> warehouseSubject = BehaviorSubject();
  List<Warehouse> get warehouses => warehouseSubject.valueOrNull ?? [];
  bool get warehousesHasValue => warehouseSubject.hasValue;

  //* Warehouse variants -------------------------------------------------------------------------
  final BehaviorSubject<List<ProductVariant>> _greenBeans =
      BehaviorSubject<List<ProductVariant>>();
  final BehaviorSubject<List<ProductVariant>> _roastedBeans =
      BehaviorSubject<List<ProductVariant>>();
  final BehaviorSubject<List<ProductVariant>> _variantSpecials =
      BehaviorSubject<List<ProductVariant>>();
  Stream<List<ProductVariant>> get greenBeansStream => _greenBeans.stream;
  Stream<List<ProductVariant>> get roastedBeansStream => _roastedBeans.stream;
  Stream<List<ProductVariant>> get variantSpecialsStream =>
      _variantSpecials.stream;
  List<ProductVariant> get greenBeans => _greenBeans.valueOrNull ?? [];
  List<ProductVariant> get roastedBeans => _roastedBeans.valueOrNull ?? [];
  List<ProductVariant> get variantSpecials =>
      _variantSpecials.valueOrNull ?? [];
  int totalGreenBeans = 0;
  int totalRoastedBeans = 0;
  int totalVariantSpecials = 0;

  void setGreenBeans(List<ProductVariant> data, int totalCount) {
    totalGreenBeans = totalCount;
    _greenBeans.add(data);
  }

  void appendGreenBeans(List<ProductVariant> data, int totalCount) {
    totalGreenBeans = totalCount;
    final current = _greenBeans.valueOrNull ?? [];
    _greenBeans.add([...current, ...data]);
  }

  void setRoastedBeans(List<ProductVariant> data, int totalCount) {
    totalRoastedBeans = totalCount;
    _roastedBeans.add(data);
  }

  void appendRoastedBeans(List<ProductVariant> data, int totalCount) {
    totalRoastedBeans = totalCount;
    final current = _roastedBeans.valueOrNull ?? [];
    _roastedBeans.add([...current, ...data]);
  }

  void setVariantSpecials(List<ProductVariant> data, int totalCount) {
    totalVariantSpecials = totalCount;
    _variantSpecials.add(data);
  }

  void appendVariantSpecials(List<ProductVariant> data, int totalCount) {
    totalVariantSpecials = totalCount;
    final current = _variantSpecials.valueOrNull ?? [];
    _variantSpecials.add([...current, ...data]);
  }

  void clearVariantSpecials() {
    totalVariantSpecials = 0;
    _variantSpecials.sink.add([]);
  }

  final BehaviorSubject<List<RoastingSlip>> roastingSlipSubject =
      BehaviorSubject<List<RoastingSlip>>();
  int totalRSRecord = 0;

  final BehaviorSubject<List<PackingSlip>> packingSlipSubject =
      BehaviorSubject<List<PackingSlip>>();
  int totalPSRecord = 0;

  //* Roasting slips -------------------------------------------------------------------------
  final BehaviorSubject<int> newRoastingSlipsCounter = BehaviorSubject<int>();

  // New
  final BehaviorSubject<List<RoastingSlip>> _newRoastingSlips =
      BehaviorSubject<List<RoastingSlip>>();
  // Roasting
  final BehaviorSubject<List<RoastingSlip>> _roastingSlips =
      BehaviorSubject<List<RoastingSlip>>();
  // Completed
  final BehaviorSubject<List<RoastingSlip>> _completeRoastingSlips =
      BehaviorSubject<List<RoastingSlip>>();
  final BehaviorSubject<List<RoastingSlip>> _roastingSlipsOfRoastedBean =
      BehaviorSubject<List<RoastingSlip>>();
  Stream<List<RoastingSlip>> get newRoastingSlipsStream =>
      _newRoastingSlips.stream;
  Stream<List<RoastingSlip>> get roastingSlipsStream => _roastingSlips.stream;
  Stream<List<RoastingSlip>> get completeRoastingSlipsStream =>
      _completeRoastingSlips.stream;
  Stream<List<RoastingSlip>> get roastingSlipsOfRoastedBeanStream =>
      _roastingSlipsOfRoastedBean.stream;
  List<RoastingSlip> get newRoastingSlips =>
      _newRoastingSlips.valueOrNull ?? [];
  List<RoastingSlip> get roastingSlips => _roastingSlips.valueOrNull ?? [];
  List<RoastingSlip> get completeRoastingSlips =>
      _completeRoastingSlips.valueOrNull ?? [];
  List<RoastingSlip> get roastingSlipsOfRoastedBean =>
      _roastingSlipsOfRoastedBean.valueOrNull ?? [];
  int totalNewRoastingSlips = 0;
  int totalRoastingSlips = 0;
  int totalCompeteRoastingSlips = 0;
  int totalRoastingSlipsOfRoastedBean = 0;

  void setRoastingSlips(
    RoastingSlipStatus status,
    List<RoastingSlip> data,
    int totalCount,
  ) {
    if (status == .newRequest) {
      totalNewRoastingSlips = totalCount;
      _newRoastingSlips.sink.add(data);
    } else if (status == .roasting) {
      totalRoastingSlips = totalCount;
      _roastingSlips.sink.add(data);
    } else if (status == .completed) {
      totalCompeteRoastingSlips = totalCount;
      _completeRoastingSlips.sink.add(data);
    }
  }

  void appendRoastingSlips(
    RoastingSlipStatus status,
    List<RoastingSlip> data,
    int totalCount,
  ) {
    if (status == .newRequest) {
      totalNewRoastingSlips = totalCount;
      final current = _newRoastingSlips.valueOrNull ?? [];
      _newRoastingSlips.sink.add([...current, ...data]);
    } else if (status == .roasting) {
      totalRoastingSlips = totalCount;
      final current = _roastingSlips.valueOrNull ?? [];
      _roastingSlips.sink.add([...current, ...data]);
    } else if (status == .completed) {
      totalCompeteRoastingSlips = totalCount;
      final current = _completeRoastingSlips.valueOrNull ?? [];
      _completeRoastingSlips.sink.add([...current, ...data]);
    }
  }

  void setRoastingSlipsOfRoastedBean(List<RoastingSlip> data, int totalCount) {
    totalRoastingSlipsOfRoastedBean = totalCount;
    _roastingSlipsOfRoastedBean.sink.add(data);
  }

  void appendRoastingSlipsOfRoastedBean(
    List<RoastingSlip> data,
    int totalCount,
  ) {
    totalRoastingSlipsOfRoastedBean = totalCount;
    final current = _roastingSlipsOfRoastedBean.valueOrNull ?? [];
    _roastingSlipsOfRoastedBean.sink.add([...current, ...data]);
  }

  void clearRoastingSlipsOfRoastedBean() {
    totalRoastingSlipsOfRoastedBean = 0;
    _roastingSlipsOfRoastedBean.drain(null).then((_) {
      _roastingSlipsOfRoastedBean.sink.add([]);
    });
  }

  //* Packing slips -------------------------------------------------------------------------
  final BehaviorSubject<int> newPackingSlipsCounter = BehaviorSubject<int>();

  BehaviorSubject<List<PackingSlipDetailItem>> packingSlipsOfSpecialVariant =
      BehaviorSubject<List<PackingSlipDetailItem>>();
  final BehaviorSubject<List<PackingSlip>> _packingSlips =
      BehaviorSubject<List<PackingSlip>>();
  final BehaviorSubject<List<PackingSlip>> _newPackingSlips =
      BehaviorSubject<List<PackingSlip>>();
  final BehaviorSubject<List<PackingSlip>> _processingPackingSlips =
      BehaviorSubject<List<PackingSlip>>();
  final BehaviorSubject<List<PackingSlip>> _completedPackingSlips =
      BehaviorSubject<List<PackingSlip>>();

  Stream<List<PackingSlip>> get packingSlipsStream => _packingSlips.stream;
  Stream<List<PackingSlip>> get newPackingsStream => _newPackingSlips.stream;
  Stream<List<PackingSlip>> get processingPackingsStream =>
      _processingPackingSlips.stream;
  Stream<List<PackingSlip>> get completedPackingsStream =>
      _completedPackingSlips.stream;

  List<PackingSlip> get packingSlips => _packingSlips.valueOrNull ?? [];
  List<PackingSlip> get newPackings => _newPackingSlips.valueOrNull ?? [];
  List<PackingSlip> get processingPackings =>
      _processingPackingSlips.valueOrNull ?? [];
  List<PackingSlip> get completedPackings =>
      _completedPackingSlips.valueOrNull ?? [];

  int totalPackings = 0;
  int totalNewPackings = 0;
  int totalProcessingPackings = 0;
  int totalCompletedPackings = 0;

  void setPackings(
    List<PackingSlip> data,
    int totalCount,
    PackingSlipStatus status,
  ) {
    switch (status) {
      case PackingSlipStatus.newRequest:
        totalNewPackings = totalCount;
        _newPackingSlips.sink.add(data);
        break;
      case PackingSlipStatus.processing:
        totalProcessingPackings = totalCount;
        _processingPackingSlips.sink.add(data);
        break;
      case PackingSlipStatus.completed:
        totalCompletedPackings = totalCount;
        _completedPackingSlips.sink.add(data);
        break;
      default:
        totalPackings = totalCount;
        _packingSlips.sink.add(data);
        break;
    }
  }

  void appendPackings(
    List<PackingSlip> data,
    int totalCount,
    PackingSlipStatus status,
  ) {
    switch (status) {
      case PackingSlipStatus.newRequest:
        totalNewPackings = totalCount;
        final current = _newPackingSlips.valueOrNull ?? [];
        _newPackingSlips.sink.add([...current, ...data]);
        break;
      case PackingSlipStatus.processing:
        totalProcessingPackings = totalCount;
        final current = _processingPackingSlips.valueOrNull ?? [];
        _processingPackingSlips.sink.add([...current, ...data]);
        break;
      case PackingSlipStatus.completed:
        totalCompletedPackings = totalCount;
        final current = _completedPackingSlips.valueOrNull ?? [];
        _completedPackingSlips.sink.add([...current, ...data]);
        break;
      default:
        totalPackings = totalCount;
        final current = _packingSlips.valueOrNull ?? [];
        _packingSlips.sink.add([...current, ...data]);
        break;
    }
  }

  void clearPackings() {
    totalPackings = 0;
    totalNewPackings = 0;
    totalProcessingPackings = 0;
    totalCompletedPackings = 0;
    _packingSlips.sink.add([]);
    _newPackingSlips.sink.add([]);
    _processingPackingSlips.sink.add([]);
    _completedPackingSlips.sink.add([]);
  }

  final BehaviorSubject<List<int>> technicalRoleStatistic = BehaviorSubject();
  final BehaviorSubject<List<RoastingSlip>> newestRoastingSlip = BehaviorSubject();
  final BehaviorSubject<List<RoastingSlip>> processingRoastingSlip = BehaviorSubject();
  final BehaviorSubject<List<PackingSlipDetailItem>> awaitPackingSlip = BehaviorSubject();
  final BehaviorSubject<List<PackingSlipDetailItem>> exportedPackingSlip = BehaviorSubject();
  final BehaviorSubject<List<PackingSlipDetailItem>> waitCompletePackingSlip = BehaviorSubject();

  @override
  Future<void> clean() async {}
}
