import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vendor_store_app/common/utils.dart';
import 'package:vendor_store_app/controllers/order_controller.dart';
import 'package:vendor_store_app/provider/order_provider.dart';
import 'package:vendor_store_app/provider/total_earnings_provider.dart';
import 'package:vendor_store_app/provider/vendor_provider.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final user = ref.read(vendorProvider);
    if (user != null) {
      final OrderController orderController = OrderController();
      try {
        final orders = await orderController.loadOrders(vendorId: user.id);
        ref.read(orderProvider.notifier).setOrders(orders);
        ref.read(totalEarningsProvider.notifier).calculateEarnings(orders);
      } catch (e) {
        debugPrint('Error fetching orders: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(totalEarningsProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    color: Colors.white60,
                    blurRadius: 10,
                    offset: Offset(2, 1),
                  )
                ], borderRadius: BorderRadius.circular(50)),
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade400,
                  child: Text(
                    vendor!.fullName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Text(
                'خوش آمدی ${vendor.fullName}',
                style: TextStyle(
                  color: Colors.black87.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Icon(Iconsax.notification_copy)
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'تعداد سفارشات:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    convertToNumberPersian(totalEarnings['totalOrders']),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text(
                    'کل درآمد:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    convertToPersian(totalEarnings['totalEarnings'].toInt()),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
