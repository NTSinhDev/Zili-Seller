import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/customer/customer_cubit.dart';
import '../../../data/models/address/address.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../utils/enums/customer_enum.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/shimmer_view.dart';
import 'components/address_item.dart';

class AddressesView extends StatefulWidget {
  final CustomerDetailsScreenTab tabIndex;
  final String customerId;
  const AddressesView({
    super.key,
    required this.tabIndex,
    required this.customerId,
  });

  static CustomerDetailsScreenTab tab = .address;

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  final CustomerRepository _customerRepository = di<CustomerRepository>();

  @override
  void initState() {
    super.initState();
    _customerCubit.getCustomerAddresses(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.tabIndex != AddressesView.tab,
      child: StreamBuilder<List<Address>>(
        stream: _customerRepository.addressesOfCustomer.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const ShimmerView(type: .loadingIndicatorAtHead);
          }

          final List<Address> addresses = snapshot.data ?? [];
          return CommonLoadMoreRefreshWrapper.refresh(
            context,
            onRefresh: () async =>
                _customerCubit.getCustomerAddresses(widget.customerId),
            child: ListView.separated(
              padding: .only(top: 16.h),
              separatorBuilder: (context, index) => SizedBox(height: 4.h),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return AddressItem(address: address);
              },
            ),
          );
        },
      ),
    );
  }
}
