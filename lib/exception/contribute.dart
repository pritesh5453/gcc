// import 'package:flutter/material.dart';

// class ContributeScreen extends StatefulWidget {
//   const ContributeScreen({super.key});

//   @override
//   State<ContributeScreen> createState() => _ContributeScreenState();
// }

// class _ContributeScreenState extends State<ContributeScreen> {
//   // Toggle between Units and Amount
//   bool isByUnits = true;
//   final TextEditingController _unitsController = TextEditingController(text: '100');
//   final TextEditingController _amountController = TextEditingController(text: '1170');

//   // Constants
//   static const double pricePerUnit = 11.70;
//   static const double platformFeePercent = 0.02; // 2%
//   static const double gstPercent = 0.18; // 18% on fee

//   double get enteredUnits {
//     if (isByUnits) {
//       double? units = double.tryParse(_unitsController.text);
//       return units ?? 0;
//     } else {
//       double? amount = double.tryParse(_amountController.text);
//       return amount != null ? amount / pricePerUnit : 0;
//     }
//   }

//   double get contributionAmount => enteredUnits * pricePerUnit;

//   double get platformFee => contributionAmount * platformFeePercent;

//   double get gst => platformFee * gstPercent;

//   double get totalPayable => contributionAmount + platformFee + gst;

//   void _onToggleChanged(bool byUnits) {
//     setState(() {
//       isByUnits = byUnits;
//       if (isByUnits) {
//         // Sync units controller from amount
//         double units = enteredUnits;
//         _unitsController.text = units.toStringAsFixed(0);
//       } else {
//         // Sync amount controller from units
//         _amountController.text = contributionAmount.toStringAsFixed(2);
//       }
//     });
//   }

//   void _updateFromUnits(String value) {
//     if (!isByUnits) return;
//     setState(() {});
//     // Keep amount controller in sync (optional)
//     if (isByUnits) {
//       _amountController.text = contributionAmount.toStringAsFixed(2);
//     }
//   }

//   void _updateFromAmount(String value) {
//     if (isByUnits) return;
//     setState(() {});
//     if (!isByUnits) {
//       _unitsController.text = enteredUnits.toStringAsFixed(0);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9F5),
//       appBar: AppBar(
//         title: const Text(
//           'Contribute GCC Units',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B3B1F)),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Current GCC Price Card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Current GCC Price',
//                       style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         const Text(
//                           '₹11.70',
//                           style: TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2C5E2E),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           '(1 GCC Unit)',
//                           style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Toggle: By Units / By Amount
//               Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8F0E8),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => _onToggleChanged(true),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                             color: isByUnits ? const Color(0xFF2E7D32) : Colors.transparent,
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'By Units',
//                               style: TextStyle(
//                                 color: isByUnits ? Colors.white : const Color(0xFF2E7D32),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => _onToggleChanged(false),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                             color: !isByUnits ? const Color(0xFF2E7D32) : Colors.transparent,
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'By Amount',
//                               style: TextStyle(
//                                 color: !isByUnits ? Colors.white : const Color(0xFF2E7D32),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Input Field (Units or Amount)
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.03),
//                       blurRadius: 6,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: isByUnits ? _unitsController : _amountController,
//                   keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                   decoration: InputDecoration(
//                     labelText: isByUnits ? 'Enter Units' : 'Enter Amount (₹)',
//                     labelStyle: const TextStyle(color: Color(0xFF6B6B6B)),
//                     prefixIcon: isByUnits
//                         ? const Icon(Icons.token, color: Color(0xFF2E7D32))
//                         : const Icon(Icons.currency_rupee, color: Color(0xFF2E7D32)),
//                     hintText: isByUnits ? 'e.g., 100' : 'e.g., 1170',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//                   ),
//                   onChanged: (value) {
//                     if (isByUnits) {
//                       _updateFromUnits(value);
//                     } else {
//                       _updateFromAmount(value);
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   isByUnits
//                       ? 'You are contributing ₹${contributionAmount.toStringAsFixed(2)}'
//                       : 'You will receive ${enteredUnits.toInt()} Units',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey.shade700,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Breakup Card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Breakup',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3B1F)),
//                     ),
//                     const SizedBox(height: 16),
//                     _breakupRow(
//                       'Amount (${enteredUnits.toInt()} × ₹$pricePerUnit)',
//                       '₹${contributionAmount.toStringAsFixed(2)}',
//                     ),
//                     const SizedBox(height: 12),
//                     _breakupRow('Platform Fee (2%)', '₹${platformFee.toStringAsFixed(2)}'),
//                     const SizedBox(height: 12),
//                     _breakupRow('GST (18% on fee)', '₹${gst.toStringAsFixed(2)}'),
//                     const Divider(height: 24, thickness: 1),
//                     _breakupRow(
//                       'Total Payable',
//                       '₹${totalPayable.toStringAsFixed(2)}',
//                       isTotal: true,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // You will receive info
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8F5E9),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: const Color(0xFFA5D6A7)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.verified, color: Color(0xFF2E7D32), size: 20),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'You will receive ${enteredUnits.toInt()} GCC Units',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1B5E20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Secure Payment
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.lock_outline, color: Color(0xFF2E7D32), size: 20),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'Secure Payment',
//                       style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Your payment is safe and encrypted',
//                       style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // Proceed to Pay Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Handle payment action
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2E7D32),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: const Text(
//                     'Proceed to Pay',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _breakupRow(String label, String amount, {bool isTotal = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: isTotal ? 16 : 14,
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             color: isTotal ? const Color(0xFF1B3B1F) : Colors.grey.shade700,
//           ),
//         ),
//         Text(
//           amount,
//           style: TextStyle(
//             fontSize: isTotal ? 18 : 14,
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
//             color: isTotal ? const Color(0xFFD32F2F) : const Color(0xFF2C5E2E),
//           ),
//         ),
//       ],
//     );
//   }
// }