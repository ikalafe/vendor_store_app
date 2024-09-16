import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store_app/models/vendor_model.dart';

/*
StateNotifier: StateNotifier is a class provided Riverpod package that helps in
managing the state, it is also designed to notify listeners abut the state changes 
*/
class VendorProvider extends StateNotifier<VendorModel?> {
  VendorProvider()
      : super(VendorModel(
          id: '',
          fullName: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          role: '',
          password: '',
        ));

  // Getter Method to extract value from an object
  VendorModel? get vendor => state;

  // Method to set the vendor user state from json
  // Purpose: updates the user state base on json String representation of the VendorModel object
  void setVendor(String vendorJson) {
    state = VendorModel.fromJson(vendorJson);
  }

  // Method to clear the vendor user state
  void signOut() {
    state = null;
  }
}
// Make the data accisible within the application
final vendorProvider = StateNotifierProvider<VendorProvider, VendorModel?>(
  (ref) {
    return VendorProvider();
  },
);
