import 'package:get_it/get_it.dart';

import 'package:zili_coffee/bloc/address/address_cubit.dart';
import 'package:zili_coffee/bloc/branch/branch_cubit.dart';
import 'package:zili_coffee/bloc/app/app_cubit.dart';
import 'package:zili_coffee/bloc/auth/auth_cubit.dart';
// import 'package:zili_coffee/bloc/blog/blog_cubit.dart';
// import 'package:zili_coffee/bloc/cart/cart_cubit.dart';
import 'package:zili_coffee/bloc/category/category_cubit.dart';
import 'package:zili_coffee/bloc/company/company_cubit.dart';
import 'package:zili_coffee/bloc/customer/customer_cubit.dart';
import 'package:zili_coffee/bloc/collaborator/collaborator_cubit.dart';
// import 'package:zili_coffee/bloc/flash_sale/flash_sale_cubit.dart';
import 'package:zili_coffee/bloc/notification/notification_cubit.dart';
import 'package:zili_coffee/bloc/order/order_cubit.dart';
import 'package:zili_coffee/bloc/payment/payment_cubit.dart';
import 'package:zili_coffee/bloc/product/product_cubit.dart';
// import 'package:zili_coffee/bloc/review/review_cubit.dart';
// import 'package:zili_coffee/bloc/role/role_cubit.dart';
import 'package:zili_coffee/bloc/warehouse/warehouse_cubit.dart';
import 'package:zili_coffee/bloc/roasting_slip/roasting_slip_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/network/network_common.dart';
import 'package:zili_coffee/data/repositories/address_repository.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
// import 'package:zili_coffee/data/repositories/blog_repository.dart';
// import 'package:zili_coffee/data/repositories/cart_repository.dart';
import 'package:zili_coffee/data/repositories/category_repository.dart';
import 'package:zili_coffee/data/repositories/customer_repository.dart';
import 'package:zili_coffee/data/repositories/collaborator_repository.dart';
// import 'package:zili_coffee/data/repositories/flash_sale_repository.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/data/repositories/payment_repository.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/data/repositories/revenue_repository.dart';
// import 'package:zili_coffee/data/repositories/review_repository.dart';
// import 'package:zili_coffee/data/repositories/role_repository.dart';
import 'package:zili_coffee/data/repositories/warehouse_repository.dart';
import 'package:zili_coffee/data/repositories/setting_repository.dart';
// import 'package:zili_coffee/data/repositories/store_repository.dart';
// import 'package:zili_coffee/services/authentication_services.dart';
import 'package:zili_coffee/services/local_storage_service.dart';

import '../bloc/packing_slip/packing_slip_cubit.dart';
import '../bloc/setting/setting_cubit.dart';
import '../data/repositories/app_repository.dart';
import '../services/common_service.dart';

final di = GetIt.I;

void setupDependencyInjection() {
  di
    //* Register normal (middlewares/cubits) 
    // ..registerFactory<ReviewMiddleware>(ReviewMiddleware.new)
    ..registerFactory<ProductMiddleware>(ProductMiddleware.new)
    ..registerFactory<AuthMiddleware>(AuthMiddleware.new)
    ..registerFactory<CustomerMiddleware>(CustomerMiddleware.new)
    ..registerFactory<CompanyMiddleware>(CompanyMiddleware.new)
    ..registerFactory<CollaboratorMiddleware>(CollaboratorMiddleware.new)
    // ..registerFactory<CategoryMiddleware>(CategoryMiddleware.new)
    ..registerFactory<AddressMiddleware>(AddressMiddleware.new)
    ..registerFactory<OrderMiddleware>(OrderMiddleware.new)
    ..registerFactory<PaymentMiddleware>(PaymentMiddleware.new)
    // ..registerFactory<BlogMiddleware>(BlogMiddleware.new)
    ..registerFactory<UploadMiddleware>(UploadMiddleware.new)
    ..registerFactory<SettingMiddleware>(SettingMiddleware.new)
    ..registerFactory<AppMiddleware>(AppMiddleware.new)
    // ..registerFactory<RoleMiddleware>(RoleMiddleware.new)
    ..registerFactory<WarehouseMiddleware>(WarehouseMiddleware.new)
    ..registerFactory<ReasonMiddleware>(ReasonMiddleware.new)
    ..registerFactory<AuthCubit>(AuthCubit.new)
    ..registerFactory<ProductCubit>(ProductCubit.new)
    ..registerFactory<CategoryCubit>(CategoryCubit.new)
    ..registerFactory<CompanyCubit>(CompanyCubit.new)
    ..registerFactory<NotificationCubit>(NotificationCubit.new)
    ..registerFactory<CustomerCubit>(CustomerCubit.new)
    ..registerFactory<CollaboratorCubit>(CollaboratorCubit.new)
    // ..registerFactory<CartCubit>(CartCubit.new)
    ..registerFactory<AddressCubit>(AddressCubit.new)
    ..registerFactory<OrderCubit>(OrderCubit.new)
    ..registerFactory<PaymentCubit>(PaymentCubit.new)
    // ..registerFactory<FlashSaleCubit>(FlashSaleCubit.new)
    // ..registerFactory<BlogCubit>(BlogCubit.new)
    ..registerFactory<SettingCubit>(SettingCubit.new)
    // ..registerFactory<ReviewCubit>(ReviewCubit.new)
    // ..registerFactory<RoleCubit>(RoleCubit.new)
    ..registerFactory<WarehouseCubit>(WarehouseCubit.new)
    ..registerFactory<RoastingSlipCubit>(RoastingSlipCubit.new)
    ..registerFactory<PackingSlipCubit>(PackingSlipCubit.new)
    ..registerFactory<BranchCubit>(BranchCubit.new)

    //* Register singleton
    //! Tránh khởi tạo hoặc đặt tác vụ nặng trong constructor nếu đăng ký là singleton
    ..registerLazySingleton<AppCubit>(AppCubit.new)
    ..registerLazySingleton<NetworkCommon>(NetworkCommon.new)
    ..registerLazySingleton<LocalStoreService>(LocalStoreService.new)
    ..registerLazySingleton<CommonService>(CommonService.new)
    ..registerLazySingleton<AppRepository>(AppRepository.new)
    ..registerLazySingleton<AuthRepository>(AuthRepository.new)
    ..registerLazySingleton<CategoryRepository>(CategoryRepository.new)
    ..registerLazySingleton<ProductRepository>(ProductRepository.new)
    ..registerLazySingleton<AddressRepository>(AddressRepository.new)
    ..registerLazySingleton<OrderRepository>(OrderRepository.new)
    ..registerLazySingleton<PaymentRepository>(PaymentRepository.new)
    ..registerLazySingleton<RevenueRepository>(RevenueRepository.new)
    ..registerLazySingleton<CustomerRepository>(CustomerRepository.new)
    ..registerLazySingleton<CollaboratorRepository>(CollaboratorRepository.new)
    ..registerLazySingleton<SettingRepository>(SettingRepository.new)
    ..registerLazySingleton<WarehouseRepository>(WarehouseRepository.new);
    // ..registerLazySingleton<ReviewRepository>(ReviewRepository.new)
    // ..registerLazySingleton<BlogRepository>(BlogRepository.new)
    // ..registerLazySingleton<StoreRepository>(StoreRepository.new)
    // ..registerLazySingleton<FlashSaleRepository>(FlashSaleRepository.new)
    // ..registerLazySingleton<RoleRepository>(RoleRepository.new)
}
