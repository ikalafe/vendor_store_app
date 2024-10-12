import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vendor_store_app/views/screens/nav_screens/earnings_screen.dart';
import 'package:vendor_store_app/views/screens/nav_screens/edit_screen.dart';
import 'package:vendor_store_app/views/screens/nav_screens/orders_screen.dart';
import 'package:vendor_store_app/views/screens/nav_screens/upload_screen.dart';
import 'package:vendor_store_app/views/screens/nav_screens/vendor_profile_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  final Color selectedItemColor = const Color(0xff5796E4);
  final Color unselectedItemColor = const Color(0xff0E0E0E);
  int _pageIndex = 0;
  final List<Widget> _pages = const [
    EarningsScreen(),
    UploadScreen(),
    EditScreen(),
    OrderScreen(),
    VendorProfileScreen(),
  ];

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
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _pageIndex == 0
                    ? Iconsax.dollar_square
                    : Iconsax.dollar_square_copy,
              ),
              label: "درآمد",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _pageIndex == 1 ? Iconsax.cloud : Iconsax.cloud_copy,
              ),
              label: "بارگزاری",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _pageIndex == 2 ? Iconsax.edit : Iconsax.edit_copy,
              ),
              label: "ویرایش",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _pageIndex == 3
                    ? Iconsax.shopping_cart
                    : Iconsax.shopping_cart_copy,
              ),
              label: "سفارشات",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _pageIndex == 4 ? Iconsax.user : Iconsax.user_copy,
              ),
              label: "پروفایل",
            ),
          ],
        ),
      ),
      body: _pages[_pageIndex],
    );
  }
}
