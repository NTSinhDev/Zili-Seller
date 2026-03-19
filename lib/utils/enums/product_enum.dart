enum ProductVariantCategoryCode { all, greenBean, roastedBean, brandProduct }

enum CoffeeVariantType { greenBean, commodity, packaging }

enum WeightUnitTypes {
  g('g'),
  kg('kg'),
  thing('cái'),
  bottle('chai'),
  jar('hũ');

  const WeightUnitTypes(this.valueVi);
  final String valueVi;
}
