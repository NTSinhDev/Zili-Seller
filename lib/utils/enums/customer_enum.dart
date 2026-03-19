enum CustomerStatus { active, inactive, suspend }

enum CustomerGroupType { fixed, automatic }

enum CustomerDetailsScreenTab { information, transaction, debt, address }

enum DebtAction {
  createReceipt,
  createPayment,
  cancelReceipt,
  cancelPayment,
  orderPayment,
  cancelDeliveryOrder,
  returnPurchaseOrder,
  returnOrder,
  orderDeliverySuccess,
  createPurchaseOrder,
}
