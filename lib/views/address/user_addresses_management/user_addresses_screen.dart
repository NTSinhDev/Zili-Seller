import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/bloc/address/address_cubit.dart';
import 'package:zili_coffee/bloc/cart/cart_cubit.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/repositories/address_repository.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/address/add_address/add_address_screen.dart';
part 'components/card_address.dart';
part 'components/add_address.dart';

class UserAddressesScreen extends StatelessWidget {
  const UserAddressesScreen({super.key});
  static String keyName = '/user-addresses';

  @override
  Widget build(BuildContext context) {
    di<AddressCubit>().getAllAddress();
    final AddressRepository addressRepo = di<AddressRepository>();
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Địa chỉ nhận hàng',
      ),
      backgroundColor: AppColors.white,
      body: di<AuthRepository>().currentAuth == null
          ? Center(
              child: Text(
                "Vui lòng đăng nhập để sử dụng tính năng!",
                style: AppStyles.text.mediumItalic(
                  fSize: 16.sp,
                  color: AppColors.black5,
                ),
              ),
            )
          : Stack(
              children: [
                Positioned(
                  top: 45,
                  left: 0,
                  child: SvgPicture.asset(AppConstant.svgs.bgScreen),
                ),
                SizedBox(
                  width: Spaces.screenWidth(context),
                  height: Spaces.screenHeight(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: StreamBuilder<List<CustomerAddress>>(
                        stream: addressRepo.addressesStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              children: [
                                const _AddAddress(),
                                ...List.generate(
                                  4,
                                  (index) => const _CardAddress(),
                                ),
                              ],
                            );
                          }
                          final addresses = _sortAddress(snapshot.data!);
                          return RefreshIndicator(
                            onRefresh: () async {
                              await di<AddressCubit>().getAllAddress();
                            },
                            color: AppColors.primary,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (addresses.length < 5) const _AddAddress(),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(bottom: 35.h),
                                    itemCount: addresses.length,
                                    itemBuilder: (context, index) {
                                      return _CardAddress(
                                        address: addresses[index],
                                        onSelect: _isFromPaymentRoute(context)
                                            ? () => _onSelectAddress(
                                                  context,
                                                  address: addresses[index],
                                                  addressRepo: addressRepo,
                                                )
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
    );
  }

  void _onSelectAddress(
    BuildContext context, {
    required CustomerAddress address,
    required AddressRepository addressRepo,
  }) {
    di<CartCubit>()
        .getDeliverPrice(address.province!.id, address.district!.id)
        .then((value) {
      addressRepo.addressPayment.sink.add(address);
      context.navigator.pop();
    });
  }

  List<CustomerAddress> _sortAddress(List<CustomerAddress> inputList) {
    inputList.sort((a, b) {
      if (a.isDefaultAddress == b.isDefaultAddress) {
        return 0;
      } else if (a.isDefaultAddress && !b.isDefaultAddress) {
        return -1;
      } else {
        return 1;
      }
    });
    return inputList;
  }

  bool _isFromPaymentRoute(BuildContext context) {
    final dynamic arguments = context.route!.settings.arguments;
    if (arguments == null || arguments is! String) return false;
    if (arguments == NavArgsKey.fromPayment) return true;
    return false;
  }
}
