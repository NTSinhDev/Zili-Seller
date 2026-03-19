import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../../bloc/product/product_cubit.dart';
import '../../../data/models/product/product_warehouse_inventory.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/shimmer_view.dart';

class InventoryView extends StatefulWidget {
  final int tabIndex;
  final String? productId;
  const InventoryView({
    super.key,
    required this.tabIndex,
    required this.productId,
  });

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final ProductCubit _productCubit = di<ProductCubit>();
  final ProductRepository _productRepository = di<ProductRepository>();

  @override
  void didUpdateWidget(InventoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabIndex == 2 && widget.productId != null) {
      if (_productRepository
          .productWarehouseInventorySubject
          .valueOrNull
          .isNull) {
        _productCubit.getProductWarehouseInventory(
          productId: widget.productId!,
        );
      }
    }
  }

  @override
  void dispose() {
    _productRepository.clearProductWarehouseInventory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.tabIndex != 2,
      child: StreamBuilder<ProductWarehouseInventoryResult?>(
        stream: _productRepository.productWarehouseInventorySubject.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const ShimmerView(type: .normal);
          }

          final ProductWarehouseInventoryResult? data = snapshot.data;

          return CommonLoadMoreRefreshWrapper.refresh(
            context,
            onRefresh: () async => await _productCubit
                .getProductWarehouseInventory(productId: widget.productId!),
            child: SingleChildScrollView(
              child: ColumnWidget(
                margin: .symmetric(vertical: 16.h),
                gap: 12.h,
                children:
                    data?.items
                        .map((e) => InventoryItemView(data: e))
                        .toList() ??
                    [],
              ),
            ),
          );
        },
      ),
    );
  }
}

typedef InventoryItemData = (String, String);

class InventoryItemView extends StatelessWidget {
  final ProductWarehouseInventory data;
  const InventoryItemView({super.key, required this.data});

  List<InventoryItemData> get dataMap => [
    ("Tồn kho", data.slotBuy.toUSD),
    ("Góp vốn", data.quantityPurchased.toUSD),
    ("Có thể bán", data.quantityInStock.toUSD),
    ("Đang giao dịch", data.quantityInStock.toUSD),
    ("Hàng đang về", data.quantityInStock.toUSD),
    ("Đang giao hàng", data.quantityInStock.toUSD),
    ("Tồn tối thiểu", data.quantityInStock.toUSD),
    ("Tồn tối đa", data.quantityInStock.toUSD),
    ("Điểm lưu kho", data.quantityInStock.toUSD),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .all(16.w),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 10.h,
        children: [
          CustomRichTextWidget(
            defaultStyle: AppStyles.text.semiBold(
              fSize: 14.sp,
              color: AppColors.primary,
            ),
            texts: [
              TextSpan(
                text: "Chi nhánh:\t\t",
                style: AppStyles.text.medium(
                  fSize: 13.sp,
                  color: AppColors.black5,
                ),
              ),
              data.warehouse?.name ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
            ],
          ),
          Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
          ...dataMap.map((e) => _row(e.$1, e.$2)),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return RowWidget(
      mainAxisAlignment: .spaceBetween,
      padding: .symmetric(vertical: 4.h),
      children: [
        Text(
          label,
          style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.black5),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: .end,
            style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.black3),
          ),
        ),
      ],
    );
  }
}
