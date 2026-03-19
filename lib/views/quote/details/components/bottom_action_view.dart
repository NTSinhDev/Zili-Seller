import 'package:flutter/material.dart';
import 'package:zili_coffee/app/app_wireframe.dart';
import 'package:zili_coffee/data/dto/quotation/review_quotation.dart';
import 'package:zili_coffee/data/repositories/setting_repository.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/helpers/permission_helper.dart';

import '../../../../bloc/order/order_cubit.dart';
import '../../../../data/dto/order/create_order.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/models/quotation/quotation.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../utils/enums/order_enum.dart';
import '../../../../utils/enums/user_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/bottom_scaffold_button.dart';
import '../../../order/create_order/create_order_screen.dart';

enum _ActionType { review, cancel, createOrder, edit }

class BottomActionView extends StatelessWidget {
  final Quotation? quotation;
  final bool isQuoteOwner;
  final bool isAccountant;
  final OrderCubit cubit;
  const BottomActionView({
    super.key,
    required this.isAccountant,
    required this.quotation,
    required this.isQuoteOwner,
    required this.cubit,
  });

  List<BottomScaffoldButtonModel> buttons(
    List<_ActionType> actions,
    BuildContext context,
  ) {
    return [
      if (actions.contains(_ActionType.review)) ...[
        BottomScaffoldButtonModel(
          label: 'Từ chối báo giá',
          color: .danger,
          style: .outline,
          onTap: () {
            if (quotation?.code == null) return;
            final reasons = di<SettingRepository>().reasonsValue;
            showRejectDialog(
              context: context,
              title: 'Từ chối báo giá',
              message:
                  'Bạn có chắc chắn muốn từ chối báo giá này không? Thao tác này không thể khôi phục.',
              reasons: reasons
                  .map(
                    (e) => RejectReason(
                      id: e.id,
                      content: e.valueVi ?? e.valueEn ?? "",
                    ),
                  )
                  .toList(),
              hasOtherReason: true,
              variant: .warning,
              secondaryAction: NoticeDialogAction(
                label: 'Thoát',
                onPressed: context.navigator.maybePop,
              ),
              primaryAction: RejectDialogAction(
                label: 'Từ chối',
                isDestructive: true,
                onReject: (int? reasonId, String? note) {
                  context.navigator.maybePop();
                  cubit.reviewQuotation(
                    ReviewQuotationInput(
                      code: quotation!.code!,
                      status: QuoteStatus.rejected,
                      reasonNote: note,
                      reasonId: reasonId,
                    ),
                  );
                },
              ),
            );
          },
        ),
        BottomScaffoldButtonModel(
          label: 'Duyệt báo giá',
          color: .primary,
          style: .filled,
          onTap: () {
            if (quotation?.code == null) return;

            showNoticeDialog(
              context: context,
              title: 'Duyệt báo giá',
              message:
                  'Bạn có chắc chắn muốn duyệt báo giá này không? Thao tác này không thể khôi phục.',
              variant: .info,
              secondaryAction: NoticeDialogAction(
                label: 'Thoát',
                onPressed: context.navigator.maybePop,
              ),
              primaryAction: NoticeDialogAction(
                label: 'Duyệt',
                onPressed: () {
                  context.navigator.maybePop();
                  cubit.reviewQuotation(
                    ReviewQuotationInput(
                      code: quotation!.code!,
                      status: QuoteStatus.approved,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ] else
      // ** Cancel quotation by quote owner (sales) **
      if (actions.contains(_ActionType.cancel))
        BottomScaffoldButtonModel(
          label: 'Hủy báo giá',
          color: .danger,
          style: .outline,
          onTap: () {
            if (quotation?.code == null) return;
            showNoticeDialog(
              context: context,
              title: 'Hủy báo giá',
              message:
                  'Bạn có chắc chắn muốn hủy báo giá này không? Thao tác này không thể khôi phục.',
              variant: .warning,
              secondaryAction: NoticeDialogAction(
                label: 'Thoát',
                onPressed: context.navigator.maybePop,
              ),
              primaryAction: NoticeDialogAction(
                label: 'Hủy phiếu',
                isOutline: true,
                isDestructive: true,
                onPressed: () {
                  context.navigator.maybePop();
                  cubit.cancelQuotation(quotation!.code!);
                },
              ),
            );
          },
        ),
      // ** Edit quotation **
      if (actions.contains(_ActionType.edit))
        BottomScaffoldButtonModel(
          label: 'Chỉnh sửa',
          color: .info,
          style: .outline,
          onTap: () {
            if (quotation != null) {
              AppWireFrame.navToQuotationEdition(quotation!);
            }
          },
        ),
      if (actions.contains(_ActionType.createOrder))
        BottomScaffoldButtonModel(
          label: 'Tạo đơn hàng',
          color: .primary,
          style: .filled,
          onTap: () {
            if (quotation == null) return;

            final createOrderDTO = CreateOrderDTO("")
              ..customer = quotation!.customer
              ..order.quotationCode = quotation!.code
              ..setProducts(
                quotation!.orderLineItems.map((e) {
                  num? discountPercent = num.tryParse(
                    e.discountPercent.toString(),
                  );
                  if (discountPercent == 0) discountPercent = null;
                  return CreateOrderInfoProd(
                    note: e.note,
                    price: num.tryParse(e.price.toString()) ?? 0,
                    qty: num.tryParse(e.quantity.toString()) ?? 0,
                    discount: num.tryParse(e.discount.toString()) ?? 0,
                    discountPercent: discountPercent,
                    discountUnit: (discountPercent ?? 0) != 0 ? "%" : "đ",
                    productVariant: e.productVariant.copyWith(
                      id: e.isService ? "" : e.productVariant.id,
                      product: e.isService
                          ? ProductInfo(
                              id: "",
                              titleVi: e.productVariant.product?.titleVi,
                              price: e.productVariant.product?.price ?? 0,
                              originalPrice:
                                  e.productVariant.product?.originalPrice ?? 0,
                              costPrice: 0.0,
                              wholesalePrice: 0.0,
                              slotBuy: 0.0,
                              availableQuantity: 0.0,
                            )
                          : e.productVariant.product,
                    ),
                  );
                }).toList(),
              );
            if (quotation!.discount.isNotNull) {
              createOrderDTO.setDiscount(
                quotation!.discount!,
                quotation!.discountPercent == 0
                    ? null
                    : quotation!.discountPercent,
                (quotation!.discountPercent ?? 0) != 0 ? "%" : "đ",
                quotation!.discountReason,
              );
            }
            if (quotation!.vat.isNotNull) {
              createOrderDTO.setVat(
                quotation!.vat!,
                quotation!.vatPercent == 0 ? null : quotation!.vatPercent,
                (quotation!.vatPercent ?? 0) != 0 ? "%" : "đ",
              );
            }
            if (quotation!.deliveryFee.isNotNull) {
              createOrderDTO.order.deliveryFee = quotation!.deliveryFee!;
            }
            if (quotation!.saleChannel.isNotNull) {
              createOrderDTO.setSaleChannel(quotation!.saleChannel!);
            }
            if ((quotation?.orderInfo?.infoAdditional?.salesType).isNotNull) {
              createOrderDTO.setSalesType(
                DefaultPrice.values.valueBy(
                      (e) =>
                          e.toConstant ==
                          quotation?.orderInfo?.infoAdditional?.salesType,
                    ) ??
                    DefaultPrice.retailPrice,
              );
            }
            if (quotation!.warehouse.isNotNull) {
              createOrderDTO.infoAdditional.branch = quotation!.warehouse;
            }

            context.navigator.push(
              MaterialPageRoute(
                builder: (context) => CreateOrderScreen(input: createOrderDTO),
                settings: RouteSettings(name: CreateOrderScreen.keyName),
              ),
            );
          },
        ),
    ];
  }

  List<_ActionType> get _actions {
    final actions = <_ActionType>[];
    if (isAccountant &&
        quotation?.quotationStatus == QuoteStatus.pending.toConstant &&
        PermissionHelper.edit(AbilitySubject.quotationManagement)) {
      actions.add(_ActionType.review);
    }
    if (isQuoteOwner &&
        quotation?.quotationStatus == QuoteStatus.pending.toConstant &&
        PermissionHelper.edit(AbilitySubject.quotationManagement)) {
      actions.add(_ActionType.cancel);
    }
    if ((isQuoteOwner && !isAccountant) &&
        quotation?.quotationStatus == QuoteStatus.pending.toConstant &&
        PermissionHelper.edit(AbilitySubject.quotationManagement)) {
      actions.add(_ActionType.edit);
    }
    if (isQuoteOwner &&
        quotation?.quotationStatus == QuoteStatus.approved.toConstant &&
        PermissionHelper.edit(AbilitySubject.orderManagement) &&
        PermissionHelper.edit(AbilitySubject.quotationManagement)) {
      actions.add(_ActionType.createOrder);
    }

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    if (_actions.isEmpty) return const SizedBox.shrink();
    return BottomScaffoldRowButtons(buttons: buttons(_actions, context));
  }
}
