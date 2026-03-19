import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/dto/product_variant_form_dto.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/enums/user_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../company_products/create_service/create_service_screen.dart';
import '../../../company_products/select_products/select_products_screen.dart';
import 'item_view.dart';

class ProductVariantsSection extends StatefulWidget {
  final String? branchId;
  final DefaultPrice? initPriceType;
  final List<ProductVariantFormDto> productVariants;
  final Function(List<ProductVariant>) onAddProductVariants;
  final Function(ProductVariantFormDto, {int? index}) onRemoveProductVariant;
  final Function(ProductVariantFormDto, {int? index}) onUpdateProductVariant;
  final Function(DefaultPrice)? onChangePriceType;
  const ProductVariantsSection({
    super.key,
    required this.branchId,
    this.initPriceType,
    required this.productVariants,
    required this.onAddProductVariants,
    required this.onRemoveProductVariant,
    required this.onUpdateProductVariant,
    this.onChangePriceType,
  });

  @override
  State<ProductVariantsSection> createState() => _ProductVariantsSectionState();
}

class _ProductVariantsSectionState extends State<ProductVariantsSection> {
  late String _warehouseBranchId;
  final OrderRepository _orderRepository = di<OrderRepository>();
  DefaultPrice _priceType = DefaultPrice.retailPrice;

  @override
  void initState() {
    super.initState();
    _warehouseBranchId = widget.branchId ?? '';
    if (widget.initPriceType != null) {
      _priceType = widget.initPriceType!;
    }
  }

  @override
  void didUpdateWidget(covariant ProductVariantsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.branchId != oldWidget.branchId) {
      _warehouseBranchId = widget.branchId ?? '';
    }
  }

  void _selectProductVariants(BuildContext context) {
    context.navigator
        .push(
          MaterialPageRoute(
            builder: (context) =>
                SelectProductsScreen(branchId: _warehouseBranchId),
          ),
        )
        .then((result) {
          if (result != null && result is List<ProductVariant>) {
            widget.onAddProductVariants(result);
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    _orderRepository.selectedProductVariants.drain();
    _orderRepository.selectedProductVariants.sink.add([]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16.w),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 12.h,
        children: [
          RowWidget(
            mainAxisAlignment: .spaceBetween,
            children: [
              RowWidget(
                gap: 8.w,
                children: [
                  Text(
                    'Sản phẩm',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                  _priceTypeDropdown(),
                ],
              ),
              InkWell(
                onTap: () => _selectProductVariants(context),
                child: RowWidget(
                  gap: 4.w,
                  children: [
                    if (widget.productVariants.isEmpty)
                      Text(
                        'Chọn sản phẩm',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      )
                    else ...[
                      Icon(
                        Icons.add_circle_rounded,
                        color: AppColors.primary,
                        size: 16.sp,
                      ),
                      Text(
                        'Sản phẩm',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (widget.productVariants.isEmpty)
            _buildEmptyProductsView(context)
          else ...[
            Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
            ColumnWidget(
              children: List.generate(widget.productVariants.length, (index) {
                final item = widget.productVariants[index];
                final productVariant = item.productVariant;
                return Column(
                  children: [
                    if (index > 0)
                      Container(
                        padding: .symmetric(vertical: 12.h),
                        child: Divider(
                          color: AppColors.greyFx,
                          height: 1.4.h,
                          thickness: 1.4.sp,
                        ),
                      ),
                    if (productVariant != null)
                      ProductItem(
                        data: item,
                        manageByQuantity: false,
                        onUpdateProductVariant: (newData) {
                          widget.onUpdateProductVariant(
                            newData,
                            index: item.isService ? index : null,
                          );
                        },
                        onRemove: () {
                          if (item.isService) {
                            widget.onRemoveProductVariant(item, index: index);
                            return;
                          }
                          widget.onRemoveProductVariant(item);
                          final crList =
                              _orderRepository
                                  .selectedProductVariants
                                  .valueOrNull ??
                              [];
                          final newList = crList
                              .where(
                                (element) => element.id != productVariant.id,
                              )
                              .toList();
                          _orderRepository.selectedProductVariants.sink.add(
                            newList,
                          );
                        },
                        onUpdateQuantity: (newQuantity) {
                          item.qty = newQuantity;
                          widget.onUpdateProductVariant(
                            item,
                            index: item.isService ? index : null,
                          );
                        },
                      ),
                  ],
                );
              }),
            ),
          ],
          SizedBox.shrink(),
          Divider(color: AppColors.greyFx, height: 1.h, thickness: 1.sp),
          InkWell(
            onTap: () {
              context.navigator
                  .push(
                    MaterialPageRoute(
                      builder: (context) => CreateServiceScreen(),
                    ),
                  )
                  .then((result) {
                    if (result != null && result is ProductVariant) {
                      widget.onAddProductVariants([result]);
                    }
                  });
            },
            child: RowWidget(
              gap: 4.w,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                Text(
                  'Thêm sản phẩm dịch vụ',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProductsView(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: .circular(8.r),
        border: .all(color: AppColors.greyC0),
      ),
      child: ColumnWidget(
        gap: 12.h,
        children: [
          InkWell(
            onTap: () => _selectProductVariants(context),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 48.sp,
                  color: AppColors.grey84,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Chưa có sản phẩm',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.grey84,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Nhấn để chọn sản phẩm',
                  style: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.grey97,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceTypeDropdown() {
    return PopupMenuButton<DefaultPrice>(
      initialValue: _priceType,
      padding: .zero,
      constraints: BoxConstraints(maxWidth: 150.w, minHeight: 0),
      shadowColor: AppColors.primary.withValues(alpha: 0.25),
      onSelected: (value) {
        if (value != _priceType) {
          setState(() {
            _priceType = value;
          });
          widget.onChangePriceType?.call(value);
        }
      },
      surfaceTintColor: AppColors.grey84,
      menuPadding: .zero,
      clipBehavior: .hardEdge,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          height: 36.h,
          child: Align(
            alignment: .centerLeft,
            child: Text(
              '≔ Loại giá bán',
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1, color: AppColors.grayEA),
        PopupMenuItem(
          value: DefaultPrice.retailPrice,
          child: Align(
            alignment: .centerLeft,
            child: Text(
              DefaultPrice.defaultPriceName(DefaultPrice.retailPrice),
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: DefaultPrice.wholesalePrice,
          child: Align(
            alignment: .centerLeft,
            child: Text(
              DefaultPrice.defaultPriceName(DefaultPrice.wholesalePrice),
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
          ),
        ),
      ],
      child: Container(
        padding: .symmetric(vertical: 6.h),
        child: RowWidget(
          mainAxisSize: .min,
          gap: 4.w,
          children: [
            Text(
              DefaultPrice.defaultPriceName(_priceType),
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.black3,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColors.grey84,
            ),
          ],
        ),
      ),
    );
  }
}
