// import 'package:flutter/material.dart';
//
// import '../../../../payment_gateway/easebuzz_backend.dart';
// import '../../../ApiService/api_service.dart';
// import '../../../category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
//
//
// /*
// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   bool saveInfo = false;
//   String selectedState = 'Select State';
//   List<String> states = ['Select State', 'Maharashtra', 'Gujarat', 'Delhi'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFA7DEAC), // light green
//         leading: const Icon(Icons.arrow_back),
//         title: const Text("Checkout"),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Header and Stepper
//             const Text(
//               "Show Order Summary",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 stepCircle(1, true),
//                 line(),
//                 stepCircle(2, false),
//                 line(),
//                 stepCircle(3, false),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: const [
//                 Text("Customer Details", style: TextStyle(fontSize: 10)),
//                 SizedBox(width: 20),
//                 Text("Shipping Method", style: TextStyle(fontSize: 10)),
//                 SizedBox(width: 20),
//                 Text("Payment Method", style: TextStyle(fontSize: 10)),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             /// Contact Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Contact", style: TextStyle(fontWeight: FontWeight.bold)),
//                 TextButton(onPressed: () {}, child: const Text("Log in")),
//               ],
//             ),
//             const SizedBox(height: 8),
//
//             /// Form Fields
//             buildTextField("Enter Mobile Number"),
//             buildTextField("First Name"),
//             buildTextField("Last Name"),
//             buildTextField("Address"),
//             buildTextField("Apartment , suite , colony"),
//             buildTextField("City"),
//             const SizedBox(height: 12),
//
//             /// State Dropdown
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//               ),
//               value: selectedState,
//               items: states.map((state) {
//                 return DropdownMenuItem(
//                   value: state,
//                   child: Text(state),
//                 );
//               }).toList(),
//               onChanged: (val) {
//                 setState(() => selectedState = val!);
//               },
//             ),
//             const SizedBox(height: 12),
//             buildTextField("Pin Code"),
//
//             /// Checkbox
//             Row(
//               children: [
//                 Checkbox(
//                   value: saveInfo,
//                   onChanged: (val) => setState(() => saveInfo = val!),
//                 ),
//                 const Text("Save this information for next time"),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             /// Continue Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFFC107), // amber
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   "Continue",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget stepCircle(int step, bool isActive) {
//     return CircleAvatar(
//       radius: 14,
//       backgroundColor: isActive ? Colors.black : Colors.grey.shade300,
//       child: Text(
//         "$step",
//         style: TextStyle(
//           color: isActive ? Colors.white : Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget line() {
//     return Container(
//       width: 30,
//       height: 2,
//       color: Colors.grey,
//     );
//   }
//
//   Widget buildTextField(String hint) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: hint,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         ),
//       ),
//     );
//   }
// }
// */
//
//
//
// import 'package:flutter/material.dart';
//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_gawali/features/ApiService/api_service.dart';
// import 'package:smart_gawali/features/category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
// import 'package:smart_gawali/payment_gateway/easebuzz_backend.dart';
// import 'package:smart_gawali/provider/calcium_mineral_product_provider.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   final List<CalciumMineralMixtureProductListModel> selectedProducts;
//   final Map<String, int> quantities;
//
//   const CheckoutScreen({
//     super.key,
//     required this.selectedProducts,
//     required this.quantities,
//   });
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController apartmentController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController pinCodeController = TextEditingController();
//
//   bool saveInfo = false;
//   String selectedState = 'Select State';
//   List<String> states = ['Select State', 'Maharashtra', 'Gujarat', 'Delhi'];
//   bool _isProcessing = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFA7DEAC),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text("Checkout"),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Show Order Summary", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [stepCircle(1, true), line(), stepCircle(2, false), line(), stepCircle(3, false)],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: const [
//                 Text("Customer Details", style: TextStyle(fontSize: 10)),
//                 SizedBox(width: 20),
//                 Text("Shipping Method", style: TextStyle(fontSize: 10)),
//                 SizedBox(width: 20),
//                 Text("Payment Method", style: TextStyle(fontSize: 10)),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             // Contact Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Contact", style: TextStyle(fontWeight: FontWeight.bold)),
//                 TextButton(onPressed: () {}, child: const Text("Log in")),
//               ],
//             ),
//             const SizedBox(height: 8),
//
//             // Form Fields
//             buildTextField("Enter Mobile Number", mobileController, TextInputType.phone),
//             buildTextField("First Name", firstNameController),
//             buildTextField("Last Name", lastNameController),
//             buildTextField("Address", addressController),
//             buildTextField("Apartment, suite, colony", apartmentController),
//             buildTextField("City", cityController),
//             const SizedBox(height: 12),
//
//             // State Dropdown
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//               ),
//               value: selectedState,
//               items: states.map((state) {
//                 return DropdownMenuItem(
//                   value: state,
//                   child: Text(state),
//                 );
//               }).toList(),
//               onChanged: (val) => setState(() => selectedState = val!),
//             ),
//             const SizedBox(height: 12),
//             buildTextField("Pin Code", pinCodeController, TextInputType.number),
//
//             Row(
//               children: [
//                 Checkbox(
//                   value: saveInfo,
//                   onChanged: (val) => setState(() => saveInfo = val!),
//                 ),
//                 const Text("Save this information for next time"),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             // Payment Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: _isProcessing
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFFC107),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30)),
//                 ),
//                 onPressed: _processPayment,
//                 child: const Text(
//                   "Proceed to Payment",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _processPayment() async {
//     if (_isProcessing) return;
//
//     setState(() => _isProcessing = true);
//
//     try {
//       // Validate all required fields
//       if (mobileController.text.isEmpty ||
//           firstNameController.text.isEmpty ||
//           addressController.text.isEmpty ||
//           cityController.text.isEmpty ||
//           pinCodeController.text.isEmpty ||
//           selectedState == 'Select State') {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Please fill all required fields")));
//         return;
//       }
//
//       // Process payment
//       String accessKey = await ApiService.getacceesskey(
//         "p1",
//         "${firstNameController.text} ${lastNameController.text}",
//         "customer@example.com",
//         mobileController.text,
//         widget.selectedProducts,
//         widget.quantities,
//       );
//
//       bool paymentSuccess = await EasebuzzPaymentHandler.startPayment(
//         context,
//         accessKey,
//         "test", // Change to "production" for live
//         widget.selectedProducts,
//         widget.quantities,
//       );
//
//       if (paymentSuccess) {
//         // Clear the cart
//         final cartProvider = Provider.of<CalciumMineralProductProvider>(
//             context, listen: false);
//         cartProvider.removeAll();
//
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Payment successful! Order placed.")),
//         );
//
//         // Navigate back to cart screen (which will now be empty)
//         Navigator.of(context).popUntil((route) => route.isFirst);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Payment failed: ${e.toString()}")),
//       );
//     } finally {
//       setState(() => _isProcessing = false);
//     }
//   }
//
//   Widget buildTextField(String hint, TextEditingController controller,
//       [TextInputType inputType = TextInputType.text]) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         keyboardType: inputType,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         ),
//       ),
//     );
//   }
//
//   Widget stepCircle(int step, bool isActive) {
//     return CircleAvatar(
//       radius: 14,
//       backgroundColor: isActive ? Colors.black : Colors.grey.shade300,
//       child: Text(
//         "$step",
//         style: TextStyle(
//             color: isActive ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   Widget line() {
//     return Container(width: 30, height: 2, color: Colors.grey);
//   }
// }
// /*
// class CheckoutScreen extends StatelessWidget {
//   final List<CalciumMineralMixtureProductListModel> selectedProducts;
//   final Map<CalciumMineralMixtureProductListModel, int> quantities;
//
//   const CheckoutScreen({
//     super.key,
//     required this.selectedProducts,
//     required this.quantities,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController mobileController = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: mobileController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Mobile Number',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final mobile = mobileController.text;
//
//                 // ✅ Convert model-to-quantity map into id-to-quantity map
//                 final Map<String, int> productQuantityMap = quantities.map(
//                       (product, quantity) => MapEntry(product.id, quantity),
//                 );
//
//                 String accessKey = await ApiService.getacceesskey(
//                   "p1",
//                   "gauravshinde",
//                   "gaurav@gmail.com",
//                   mobile,
//                   selectedProducts,
//                   productQuantityMap,
//                 );
//
//                 String payMode = "test"; // or "production"
//
//                 bool paymentResult = await EasebuzzPaymentHandler.startPayment(
//                   context,
//                   accessKey,
//                   payMode,
//                   selectedProducts,
//                   productQuantityMap,
//                 );
//
//                 if (paymentResult) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Payment successful!")),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Payment failed.")),
//                   );
//                 }
//               },
//               child: const Text("Proceed to Payment"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// */
