part of 'cart_bloc.dart';

sealed class CartState {
  final CouponDataModel? appliedCoupon;
  final String deliveryAddress;
  final List<ProductDataModel> recommendedProducts;

  final double totalMaxRetailPrice;
  final double totalDiscountedPrice;
  final double totalFinalPrice;

  CartState({
    required this.totalMaxRetailPrice,
    required this.totalDiscountedPrice,
    required this.totalFinalPrice,
    required this.deliveryAddress,
    required this.recommendedProducts,
    this.appliedCoupon,
  });
}

class CartEmptyState extends CartState {
  CartEmptyState({required super.deliveryAddress, required super.recommendedProducts})
      : super(
          totalMaxRetailPrice: 0,
          totalDiscountedPrice: 0,
          totalFinalPrice: 0,
        );
}

class CartModifiedState extends CartState {
  final Map<String, int> cartItemsQtyMapping;

  CartModifiedState({
    required super.totalMaxRetailPrice,
    required super.totalDiscountedPrice,
    required super.totalFinalPrice,
    required this.cartItemsQtyMapping,
    required super.deliveryAddress,
    required super.recommendedProducts,
    super.appliedCoupon,
  });
}
