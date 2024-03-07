import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/data/coupons_data.dart';
import '../../../../config/data/products_data.dart';
import '../../domain/models/coupon_data_model.dart';
import '../../domain/models/product_data_model.dart';
import '../bloc/cart_bloc.dart';

class ReviewCartScreen extends StatefulWidget {
  const ReviewCartScreen({super.key});

  @override
  State<ReviewCartScreen> createState() => _ReviewCartScreenState();
}

class _ReviewCartScreenState extends State<ReviewCartScreen> {
  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () async {
          Navigator.of(context).maybePop();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      centerTitle: true,
      title: const Text('Review Cart'),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(36),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE7E3FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'PAWsome, ₹200 saved! Free delivery on this order',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: Color(0xFF493AA3),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomSheet: const ReviewCartBottomsheet(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CartItemList(),
              SizedBox(height: 4),
              CouponAppliedSection(),
              SizedBox(height: 4),
              BillDetailsSection(),
              SizedBox(height: 4),
              CheckoutRecommendations(),
              SizedBox(height: 152),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewCartBottomsheet extends StatelessWidget {
  const ReviewCartBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                return Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Color(0xFF808DA0),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Delivering to Home by ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFF79540),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            state.deliveryAddress,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF808DA0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 36),
                    SizedBox(
                      height: 24,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              width: 1.5,
                              color: const Color(0xFF808DA0).withOpacity(0.2),
                            ),
                          ),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          final cartCubit = context.read<CartCubit>();
                          cartCubit.changeAddress();
                        },
                        child: const Text('Change'),
                      ),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    debugPrint('Payment change (Pay via) :: Tapped.');
                  },
                  child: const SizedBox(
                    width: 120,
                    height: 42,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Pay via',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF808DA0),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_up,
                            ),
                          ],
                        ),
                        Text(
                          'Cash on Delivery',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state is CartEmptyState ? Colors.grey : const Color(0xFF239A3D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fixedSize: const Size(196, 42),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: state is CartEmptyState
                          ? null
                          : () {
                              final cartCubit = context.read<CartCubit>();
                              cartCubit.resetCartState();

                              if (cartCubit.isCartEmpty) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed')));
                            },
                      child: Row(
                        children: [
                          const Spacer(),
                          Opacity(
                            opacity: state is CartEmptyState ? 0 : 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '₹${state.totalFinalPrice}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '₹${state.totalMaxRetailPrice}',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 2),
                          const Text('Place Order'),
                          const SizedBox(width: 2),
                          const Icon(Icons.keyboard_arrow_right),
                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutRecommendations extends StatelessWidget {
  const CheckoutRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 312,
      child: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text(
                'Before you checkout',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state.recommendedProducts.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: double.infinity,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_checkout,
                            size: 36,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'No more recommendations',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You can checkout.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.recommendedProducts.length,
                    itemBuilder: (context, index) {
                      final ProductDataModel recommendedProduct = state.recommendedProducts[index];
                      return RecommendationItemCard(recommendedProduct: recommendedProduct);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 14);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendationItemCard extends StatelessWidget {
  final ProductDataModel recommendedProduct;

  const RecommendationItemCard({super.key, required this.recommendedProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF808DA0).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(recommendedProduct.itemImage),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendedProduct.brand,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF808DA0),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 28,
                  child: Text(
                    recommendedProduct.name,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendedProduct.unit,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF808DA0),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '₹${recommendedProduct.maxRetailPrice}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 8,
                            decoration: TextDecoration.lineThrough,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: Color(0xFF808DA0),
                            color: Color(0xFF808DA0),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${recommendedProduct.discountedPrice}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 28,
                      width: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF193A6A),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          fixedSize: const Size(56, 28),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          final cartCubit = context.read<CartCubit>();
                          cartCubit.addCartItem(recommendedProduct);
                        },
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BillDetailsSection extends StatelessWidget {
  const BillDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bill Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MRP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '₹${state.totalMaxRetailPrice}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discount',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '-₹${state.totalDiscountedPrice}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Coupon Discount',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '-₹${context.read<CartCubit>().appliedCoupon?.discountPrice ?? 0}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery charge',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '₹${50}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: Color(0xFF808DA0),
                          color: Color(0xFF808DA0),
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Free',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF239A3D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cash Handling Charge',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '₹${context.read<CartCubit>().cashHandlingCharge}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '₹${state.totalFinalPrice}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class CouponAppliedSection extends StatelessWidget {
  const CouponAppliedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      height: 56,
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          bool isCouponApplied = state.appliedCoupon == null;
          return Row(
            children: [
              Icon(
                isCouponApplied ? Icons.discount_outlined : Icons.discount,
                color: isCouponApplied ? Colors.grey : const Color(0xFF239A3D),
              ),
              const SizedBox(width: 8),
              const Text(
                'Coupon Applied',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                state.appliedCoupon == null ? (' ' * 8) : state.appliedCoupon!.couponCode,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF239A3D),
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                height: 24,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        width: 1.5,
                        color: const Color(0xFF193A6A).withOpacity(0.2),
                      ),
                    ),
                    foregroundColor: state.appliedCoupon == null ? const Color(0xFF239A3D) : const Color(0xFF193A6A),
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: state.appliedCoupon == null
                      ? () async {
                          final coupon = await showDialog<CouponDataModel>(
                            context: context,
                            builder: (context) => const AvailableCouponsDialogBox(),
                          );
                          if (coupon == null) {
                            return;
                          }
                          final cartCubit = context.read<CartCubit>();
                          cartCubit.selectCoupon(coupon);
                        }
                      : () {
                          final cartCubit = context.read<CartCubit>();
                          cartCubit.removeCoupon();
                        },
                  child: Text(state.appliedCoupon == null ? 'Apply' : 'Remove'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AvailableCouponsDialogBox extends StatefulWidget {
  const AvailableCouponsDialogBox({super.key});

  @override
  State<AvailableCouponsDialogBox> createState() => _AvailableCouponsDialogBoxState();
}

class _AvailableCouponsDialogBoxState extends State<AvailableCouponsDialogBox> {
  late int couponIdx;

  @override
  void initState() {
    fetchCouponSelectionStatus();
    super.initState();
  }

  void fetchCouponSelectionStatus() {
    final cartCubit = context.read<CartCubit>();
    if (cartCubit.appliedCoupon == null) {
      couponIdx = -1;
      return;
    }
    couponIdx = availableCoupons.indexOf(cartCubit.appliedCoupon!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      surfaceTintColor: const Color(0xFFF4F4F4),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  'Available Coupons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 18,
                  child: IconButton(
                    iconSize: 14,
                    style: IconButton.styleFrom(
                      fixedSize: const Size.square(16),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    ),
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              itemCount: availableCoupons.length,
              itemBuilder: (context, index) {
                final CouponDataModel coupon = availableCoupons[index];
                return ListTile(
                  selectedColor: const Color(0xFF493AA3),
                  textColor: Colors.black,
                  selectedTileColor: const Color(0xFFE7E3FF),
                  selected: couponIdx == index,
                  title: Text(coupon.couponCode),
                  onTap: () {
                    couponIdx = index;
                    setState(() {});
                  },
                  trailing: Text('₹${coupon.discountPrice}'),
                  leadingAndTrailingTextStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF239A3D),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 4);
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF493AA3),
                foregroundColor: const Color(0xFFE7E3FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                if (couponIdx.isNegative) {
                  Navigator.of(context).pop();
                  return;
                } else {
                  Navigator.of(context).pop(availableCoupons[couponIdx]);
                }
              },
              child: const Text('Apply Coupon'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartEmptyState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.remove_shopping_cart,
                    size: 36,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Your cart is Empty',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 24,
                    width: 120,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF239A3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            width: 1.5,
                            color: const Color(0xFF193A6A).withOpacity(0.2),
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        final cartCubit = context.read<CartCubit>();
                        cartCubit.populateCartItems();
                      },
                      child: const Text('Keep shopping'),
                    ),
                  ),
                ],
              ),
            );
          }

          state as CartModifiedState;

          final Map<String, int> cartItemsQtyMapping = state.cartItemsQtyMapping;
          final List<String> cartItemIds = cartItemsQtyMapping.entries.map((e) => e.key).toList();

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cartItemIds.length,
            itemBuilder: (context, index) {
              int prodIdx = availableProducts.indexWhere((element) => element.productId == cartItemIds[index]);
              if (prodIdx.isNegative) {
                return Container(
                  alignment: Alignment.center,
                  child: const Text('Unexpected error'),
                );
              }
              return CartItemCard(cartItem: availableProducts[prodIdx]);
            },
          );
        },
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final ProductDataModel cartItem;

  const CartItemCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 75,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF808DA0).withOpacity(0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                // backgroundBlendMode: BlendMode.color,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(cartItem.itemImage),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.unit,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF808DA0),
                              // fontfam: DM Sans
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '₹${cartItem.discountedPrice}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${cartItem.maxRetailPrice}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: Color(0xFF808DA0),
                                  color: Color(0xFF808DA0),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF193A6A),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 14,
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: const Color(0xFF193A6A),
                            ),
                            onPressed: () {
                              final cartCubit = context.read<CartCubit>();
                              cartCubit.removeCartItem(cartItem);
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          BlocBuilder<CartCubit, CartState>(
                            // buildWhen: (previous, current) {
                            //   if (current is CartEmptyState) {
                            //     return false;
                            //   }
                            //   return true;
                            // },
                            builder: (context, state) {
                              state = state as CartModifiedState;
                              return Text(
                                '${state.cartItemsQtyMapping[cartItem.productId]!}',
                                style: const TextStyle(
                                  color: Color(0xFF193A6A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            iconSize: 14,
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: const Color(0xFF193A6A),
                            ),
                            onPressed: () {
                              final cartCubit = context.read<CartCubit>();
                              cartCubit.addCartItem(cartItem);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
