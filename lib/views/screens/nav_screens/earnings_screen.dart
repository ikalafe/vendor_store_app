import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vendor_store_app/provider/vendor_provider.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(boxShadow: [
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
      ),
    );
  }
}
