enum RoastingSlipStatus { newRequest, roasting, completed, cancelled }

enum PackingSlipStatus {
  newRequest,
  processing,
  completed,
  packing,
  confirmed,
  cancelled,
}

enum WarehouseNotifications {
  newRoastingSlip,
  completedRoastingSlip,
  cancelledRoastingSlip,
  newPackingSlip,
  exportedMaterialPackingSlip,
  completedPackingSlip,
  cancelledPackingSlip,
}