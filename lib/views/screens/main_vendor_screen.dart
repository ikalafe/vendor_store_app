import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  final Color selectedItemColor = const Color(0xff5796E4);
  final Color unselectedItemColor = const Color(0xff0E0E0E);
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          currentIndex: _pageIndex,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          backgroundColor: const Color(0xffEFF6FF),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Iconsax.dollar_square_copy), label: "درآمد"),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.import_1_copy), label: "بارگزاری"),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.edit_copy), label: "ویرایش"),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.shopping_cart_copy), label: "سفارشات"),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.logout_copy), label: "خروج"),
          ],
        ),
      ),
    );
  }
}
