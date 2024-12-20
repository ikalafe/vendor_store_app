import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vendor_store_app/common/utils.dart';
import 'package:vendor_store_app/controllers/order_controller.dart';
import 'package:vendor_store_app/models/vendor_order_model.dart';
import 'package:vendor_store_app/provider/order_provider.dart';
import 'package:vendor_store_app/provider/vendor_provider.dart';
import 'package:vendor_store_app/views/screens/detail/screens/order_detail_screen.dart';
import 'package:vendor_store_app/views/screens/nav_screens/widgets/image.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  Future<void> _fetchOrders() async {
    final user = ref.read(vendorProvider);
    if (user != null) {
      final OrderController orderController = OrderController();
      try {
        final orders = await orderController.loadOrders(vendorId: user.id);
        ref.read(orderProvider.notifier).setOrders(orders);
      } catch (e) {}
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    final OrderController orderController = OrderController();
    try {
      await orderController.deleteOrder(id: orderId, context: context);
      _fetchOrders(); // Refresh the list after deletion
    } catch (e) {
      debugPrint('**** خطا در جذف سفارش: $e *****');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'سفارشات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Dana',
          ),
        ),
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('سفارشی یافت نشد.'),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final OrderModel order = orders[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                    child: Container(
                      width: deviceWidth,
                      height: 154,
                      margin: const EdgeInsets.only(
                        top: 16,
                        right: 16,
                        left: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 130,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, right: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        child: Text(
                                          order.productName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        convertToPersian(order.productPrice),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'در دسته: ${order.category}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      order.delivered == true
                                          ? InkWell(
                                              child: const Icon(
                                                  Iconsax.trash_copy),
                                              onTap: () {
                                                _deleteOrder(order.id);
                                              },
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Stack(
                                  children: [
                                    ImageLoadingService(
                                      imageUrl: order.image,
                                      widthImage: 120,
                                      heithImage: 120,
                                      imageBorderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    Positioned(
                                      left: 25,
                                      right: 25,
                                      bottom: 0,
                                      child: Container(
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: order.delivered == true
                                              ? Colors.green.shade500
                                              : order.processing == true
                                                  ? Colors.blue.shade300
                                                  : Colors.red.shade400,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            order.delivered == true
                                                ? 'تحویل'
                                                : order.processing == true
                                                    ? 'پردازش'
                                                    : 'لغو شده',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
