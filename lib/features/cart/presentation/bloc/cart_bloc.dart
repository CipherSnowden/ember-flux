import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/data/products_data.dart';
import '../../../../config/defaults.dart';
import '../../domain/models/coupon_data_model.dart';
import '../../domain/models/product_data_model.dart';

part 'cart_bloc_states.dart';

class CartCubit extends Cubit<CartState> {
  Map<String, int> _cartItemsQtyMapping = <String, int>{};
  String _deliveryAddress = defaultDeliveryAddress;
  CouponDataModel? _appliedCoupon;

  final double deliveryCharge = 0;
  final double cashHandlingCharge = 50;

  double calcTotalMaxRetailPrice = 0;
  double calcTotalDiscount = 0;
  double calcTotalFinalPrice = 0;

  CartCubit()
      : super(CartEmptyState(
          deliveryAddress: defaultDeliveryAddress,
          recommendedProducts: availableProducts,
        ));

  CouponDataModel? get appliedCoupon => _appliedCoupon;
  String get deliveryAddress => _deliveryAddress;

  List<ProductDataModel> get recommendedProducts {
    if (_cartItemsQtyMapping.isEmpty) {
      return availableProducts;
    }
    final recommendedProds = availableProducts.where((prod) => _cartItemsQtyMapping.keys.contains(prod.productId) == false).toList();
    return recommendedProds;
  }

  bool get isCartEmpty => _cartItemsQtyMapping.isEmpty;

  void populateCartItems() {
    _cartItemsQtyMapping = Map.from(defaultCartItemsQtyMapping);
    _appliedCoupon = null;

    _cartItemsQtyMapping.forEach((key, value) {
      final cartItem = availableProducts.singleWhere((prod) => key == prod.productId);

      calcTotalMaxRetailPrice += cartItem.maxRetailPrice;
      calcTotalDiscount += cartItem.maxRetailPrice - cartItem.discountedPrice;
    });

    _emitCartState();
  }

  void addCartItem(ProductDataModel cartItem) {
    _cartItemsQtyMapping.update(cartItem.productId, (value) => value + 1, ifAbsent: () => 1);

    calcTotalMaxRetailPrice += cartItem.maxRetailPrice;
    calcTotalDiscount += cartItem.maxRetailPrice - cartItem.discountedPrice;

    _emitCartState();
  }

  void removeCartItem(ProductDataModel cartItem) {
    bool isUno = _cartItemsQtyMapping[cartItem.productId] == 1;
    if (isUno) {
      _cartItemsQtyMapping.remove(cartItem.productId);
    } else {
      _cartItemsQtyMapping.update(cartItem.productId, (value) => value - 1);
    }

    calcTotalMaxRetailPrice -= cartItem.maxRetailPrice;
    calcTotalDiscount -= cartItem.maxRetailPrice - cartItem.discountedPrice;

    _emitCartState();
  }

  void selectCoupon(CouponDataModel coupon) {
    _appliedCoupon = coupon;
    _emitCartState();
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _emitCartState();
  }

  void changeAddress() {
    _deliveryAddress = changedDeliveryAddress;
    _emitCartState();
  }

  void resetCartState() {
    _cartItemsQtyMapping.removeWhere((key, value) => true);
    _appliedCoupon = null;
    _deliveryAddress = defaultDeliveryAddress;

    calcTotalMaxRetailPrice = 0;
    calcTotalDiscount = 0;
    calcTotalFinalPrice = 0;

    _emitCartState();
  }

  void _emitCartState() {
    calcTotalFinalPrice = calcTotalMaxRetailPrice - calcTotalDiscount - (_appliedCoupon?.discountPrice ?? 0) + deliveryCharge + cashHandlingCharge;

    bool isCartEmpty = _cartItemsQtyMapping.isEmpty;
    if (isCartEmpty) {
      emit(CartEmptyState(deliveryAddress: _deliveryAddress, recommendedProducts: recommendedProducts));
      return;
    }

    emit(CartModifiedState(
      totalMaxRetailPrice: calcTotalMaxRetailPrice,
      totalDiscountedPrice: calcTotalDiscount,
      totalFinalPrice: calcTotalFinalPrice,
      cartItemsQtyMapping: _cartItemsQtyMapping,
      deliveryAddress: _deliveryAddress,
      recommendedProducts: recommendedProducts,
      appliedCoupon: _appliedCoupon,
    ));
  }
}
