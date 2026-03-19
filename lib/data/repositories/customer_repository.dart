import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../models/address/address.dart';
import '../models/user/customer.dart';
import '../models/user/customer_group.dart';
import '../models/user/staff.dart';
import '../models/user/debt.dart';
import '../models/order/order.dart';
import 'base_repository.dart';

class CustomerRepository extends BaseRepository {
  final BehaviorSubject<List<Customer>> customersFilter = BehaviorSubject();
  final BehaviorSubject<List<Staff>> activeStaffs = BehaviorSubject();
  final BehaviorSubject<List<Address>> addressesOfCustomer = BehaviorSubject();
  final BehaviorSubject<List<CustomerGroup>> customerGroups = BehaviorSubject();
  final BehaviorSubject<Customer?> selectedCustomer = BehaviorSubject();
  final BehaviorSubject<List<Order>> customerTransactions =
      BehaviorSubject<List<Order>>();
  final BehaviorSubject<List<Debt>> customerDebts =
      BehaviorSubject<List<Debt>>();
  final BehaviorSubject<CustomerGroup?> selectedGroup = BehaviorSubject();
  int totalCustomers = 0;
  int totalCustomerGroups = 0;
  int totalCustomerTransactions = 0;
  int totalCustomerDebts = 0;

  @override
  Future<void> clean() async {
    customersFilter.drain(null);
    customersFilter.sink.add([]);
    selectedCustomer.drain(null);
    selectedCustomer.sink.add(null);
    customerTransactions.drain(null);
    customerTransactions.sink.add([]);
    customerDebts.drain(null);
    customerDebts.sink.add([]);
  }
}
