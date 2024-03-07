class ProductDataModel {
  final String productId;
  final String itemImage;
  final String brand;
  final String name;
  final String unit;
  final double discountedPrice;
  final double maxRetailPrice;

  const ProductDataModel({
    required this.productId,
    required this.itemImage,
    required this.brand,
    required this.name,
    required this.unit,
    required this.discountedPrice,
    required this.maxRetailPrice,
  });
}
