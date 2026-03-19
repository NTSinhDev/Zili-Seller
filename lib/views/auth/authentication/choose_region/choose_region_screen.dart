import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/address/address_cubit.dart';
import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/data/repositories/address_repository.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:easy_debounce/easy_debounce.dart';

class ChooseRegionScreen extends StatefulWidget {
  const ChooseRegionScreen({super.key});
  static String keyName = '/choose-region';

  @override
  State<ChooseRegionScreen> createState() => _ChooseRegionScreenState();
}

class _ChooseRegionScreenState extends State<ChooseRegionScreen> {
  final AddressRepository addressRepo = di<AddressRepository>();
  final AuthRepository authRepository = di<AuthRepository>();
  final AddressCubit cubit = di<AddressCubit>();
  int currentStep = 1;
  late Stream<List<Location>> stream;

  @override
  void initState() {
    super.initState();
    if (!addressRepo.provincesHasValue()) {
      cubit.getProvinces();
    }

    stream = addressRepo.provincesStream;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        height(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            width(width: 20.w),
            InkWell(
              onTap: () {
                final AuthRepository authRepository = di<AuthRepository>();
                authRepository.jumpToPageView(pageIndex: 2);
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: const Icon(Icons.arrow_back, color: AppColors.primary),
              ),
            ),
            width(width: 16.w),
            Text(
              currentStep == 1
                  ? "Chọn tỉnh/thành phố của bạn"
                  : currentStep == 2
                      ? "Chọn quận/huyện của bạn"
                      : "Chọn xã/phường của bạn",
              style: AppStyles.text.semiBold(
                fSize: 16.sp,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        height(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: Spaces.screenWidth(context) - 48.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.search, color: AppColors.primary),
              width(width: 12),
              Expanded(
                child: TextField(
                  cursorColor: AppColors.primary,
                  onChanged: (keySearch) {
                    EasyDebounce.cancel('addSearchingEvent');
                    EasyDebounce.debounce(
                      'addSearchingEvent',
                      const Duration(milliseconds: 400),
                      () {
                        cubit.searchAddress(keySearch: keySearch);
                      },
                    );
                  },
                  onSubmitted: (keySearch) {
                    EasyDebounce.cancel('addSearchingEvent');
                    EasyDebounce.debounce(
                      'addSearchingEvent',
                      const Duration(milliseconds: 400),
                      () async {
                        await cubit.searchAddress(keySearch: keySearch);
                      },
                    );
                  },
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.search,
                  scrollPadding: const EdgeInsets.all(0),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(0),
                    hintText: currentStep == 1
                        ? "Bạn ở tỉnh/thành phố nào?"
                        : currentStep == 2
                            ? "Bạn ở quận/huyện phố nào?"
                            : "Bạn ở xã/phường phố nào?",
                    hintStyle: AppStyles.text.medium(
                      fSize: 15.sp,
                      color: AppColors.black24.withOpacity(0.6),
                    ),
                  ),
                  style: AppStyles.text.medium(fSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
        height(height: 20),
        Expanded(
          child: StreamBuilder<List<Location>>(
            stream: stream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 80.w,
                  height: 80.w,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }

              if (snapshot.data == null) {
                return const Center(
                  child: Text("Không có dữ liệu!"),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                itemBuilder: (_, index) {
                  final Location location = snapshot.data![index];
                  return InkWell(
                    onTap: () async {
                      switch (currentStep) {
                        case 1:
                          authRepository.storeProvinceStream.sink.add(location);
                          await cubit.getDistricts(location);
                          setState(() {
                            stream = addressRepo.districtsStream;
                            currentStep = 2;
                          });
                          break;
                        case 2:
                          authRepository.storeDistrictStream.sink.add(location);
                          await cubit.getWards(location);
                          setState(() {
                            stream = addressRepo.wardsStream;
                            currentStep = 3;
                          });
                          break;
                        default:
                          authRepository.storeTownStream.sink.add(location);
                          authRepository.jumpToPageView(pageIndex: 2);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 44.w),
                      child: Row(
                        children: [
                          Icon(
                            location.level.toLowerCase() == "thành phố"
                                ? Icons.location_city_outlined
                                : CupertinoIcons.location_solid,
                            color: location.level.toLowerCase() == "thành phố"
                                ? AppColors.primary
                                : AppColors.scarlet,
                          ),
                          width(width: 20),
                          Text(
                            "${location.level} ${location.name}",
                            style: AppStyles.text.medium(fSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Divider(
                      height: 1.h,
                      thickness: 1,
                      color: AppColors.lightGrey,
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
