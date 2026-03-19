import 'package:zili_coffee/data/models/order/order.dart';
import 'package:zili_coffee/data/models/order/order_delivery.dart';
import 'package:zili_coffee/data/models/order/order_info.dart';
import 'package:zili_coffee/data/models/order/order_invoice.dart';
import 'package:zili_coffee/data/models/payment/collaborator.dart';
import 'package:zili_coffee/data/models/user/company.dart';
import 'package:zili_coffee/data/models/user/customer.dart';
import 'package:zili_coffee/data/models/user/staff.dart';
import 'package:zili_coffee/data/models/warehouse/warehouse.dart';

import '../user/base_person.dart';

class OrderDetailData<T extends Order> {
  final T order;
  final OrderDelivery? orderDelivery;
  final Map<String, dynamic>? deliveryOrderRaw;
  final Customer? customer;
  final OrderInvoice? orderInvoice;
  final OrderInfo? orderInfo;
  final Warehouse? warehouse;
  final Staff? staff;
  final BasePerson? personCreated;
  final Company? company;
  final Collaborator? collaborator;

  OrderDetailData({
    required this.order,
    this.orderDelivery,
    this.deliveryOrderRaw,
    this.customer,
    this.orderInvoice,
    this.orderInfo,
    this.warehouse,
    this.staff,
    this.company,
    this.personCreated,
    this.collaborator,
  });

  OrderDetailData<T> copyWith({
    T? order,
    OrderDelivery? orderDelivery,
    Map<String, dynamic>? deliveryOrderRaw,
    Customer? customer,
    OrderInvoice? orderInvoice,
    OrderInfo? orderInfo,
    Warehouse? warehouse,
    Staff? staff,
    Company? company,
    BasePerson? personCreated,
    Collaborator? collaborator,
  }) {
    return OrderDetailData<T>(
      order: order ?? this.order,
      orderDelivery: orderDelivery ?? this.orderDelivery,
      deliveryOrderRaw: deliveryOrderRaw ?? this.deliveryOrderRaw,
      customer: customer ?? this.customer,
      orderInvoice: orderInvoice ?? this.orderInvoice,
      orderInfo: orderInfo ?? this.orderInfo,
      warehouse: warehouse ?? this.warehouse,
      staff: staff ?? this.staff,
      company: company ?? this.company,
      personCreated: personCreated ?? this.personCreated,
      collaborator: collaborator ?? this.collaborator,
    );
  }
}
