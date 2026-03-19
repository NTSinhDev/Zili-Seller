import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/client_models/transaction_status.dart';
import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/data/models/order/order_detail_data.dart';
import 'package:zili_coffee/data/models/warehouse/warehouse.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

import '../models/order/delivery_group.dart';
import '../models/product/product_variant.dart';
import '../models/quotation/quotation.dart';
import '../models/template_mail_data.dart';

class OrderRepository extends BaseRepository {
  final BehaviorSubject<List<DeliveryGroup>> deliveryMethods =
      BehaviorSubject();
  final BehaviorSubject<List<Order>> behaviorOrders = BehaviorSubject();
  final BehaviorSubject<TransactionStatus> transactionStatusStream =
      BehaviorSubject<TransactionStatus>();

  int productVariantsTotal = 0;
  final BehaviorSubject<List<ProductVariant>> productVariants =
      BehaviorSubject();
  Stream<List<ProductVariant>> get productVariantsStream =>
      productVariants.stream;
  final BehaviorSubject<List<ProductVariant>> selectedProductVariants =
      BehaviorSubject();

  // Warehouses (chi nhánh)
  final BehaviorSubject<List<Warehouse>> _warehouses = BehaviorSubject();
  Stream<List<Warehouse>> get warehousesStream => _warehouses.stream;
  List<Warehouse> get warehouses => _warehouses.valueOrNull ?? [];
  bool get warehousesHasValue => warehouses.isNotEmpty;

  Warehouse? _selectedWarehouse;
  Warehouse? get selectedWarehouse => _selectedWarehouse;

  void setWarehouses(List<Warehouse> warehouses) {
    _warehouses.sink.add(warehouses);
    // Set default warehouse if available
    if (_selectedWarehouse == null && warehouses.isNotEmpty) {
      final defaultWarehouse = warehouses.firstWhere(
        (w) => w.isDefault == true,
        orElse: () => warehouses.first,
      );
      _selectedWarehouse = defaultWarehouse;
    }
  }

  void setSelectedWarehouse(Warehouse? warehouse) {
    _selectedWarehouse = warehouse;
  }

  List<Order> orders = [];
  Order? currentOrder;
  int totalOrders = 0;

  int toolbarIndex = -1;

  // Sales quotations
  final BehaviorSubject<List<Quotation>> quotations =
      BehaviorSubject<List<Quotation>>();
  Stream<List<Quotation>> get quotationsStream => quotations.stream;
  int totalQuotations = 0;

  // Seller orders (for order list screen)
  final BehaviorSubject<List<Order>> sellerOrders =
      BehaviorSubject<List<Order>>();
  Stream<List<Order>> get sellerOrdersStream => sellerOrders.stream;

  // Order Detail
  final BehaviorSubject<OrderDetailData?> orderDetailData =
      BehaviorSubject<OrderDetailData?>();
  OrderDetailData? get currentOrderDetail => orderDetailData.valueOrNull;

  int totalSellerOrders = 0;
  int totalOrderPending = 0;
  int totalOrderProcessing = 0;
  int totalOrdersReadyToPick = 0;
  int totalOrdersDelivering = 0;
  int totalOrdersCompleted = 0;
  int totalOrdersCancelled = 0;

  // ** Quotations store's data
  final BehaviorSubject<List<TemplateMailData>> templateMails =
      BehaviorSubject<List<TemplateMailData>>();

  @override
  Future<void> clean() async {
    orders = [];
    currentOrder = null;
    toolbarIndex = -1;
    _selectedWarehouse = null;
    behaviorOrders.drain(null);
    behaviorOrders.sink.add([]);
    _warehouses.drain(null);
    _warehouses.sink.add([]);
    productVariants.drain(null);
    productVariants.sink.add([]);
  }
}
