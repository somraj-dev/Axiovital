import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class AddressDetailsSheet extends StatefulWidget {
  final String? preFilledAddress;
  final String? city;
  final Address? editAddress;

  const AddressDetailsSheet({
    super.key,
    this.preFilledAddress,
    this.city,
    this.editAddress,
  });

  @override
  State<AddressDetailsSheet> createState() => _AddressDetailsSheetState();
}

class _AddressDetailsSheetState extends State<AddressDetailsSheet> {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedType = 'Home';

  @override
  void initState() {
    super.initState();
    if (widget.editAddress != null) {
      _detailController.text = widget.editAddress!.fullAddress;
      _nameController.text = widget.editAddress!.recipientName;
      _phoneController.text = widget.editAddress!.phone;
      _selectedType = widget.editAddress!.type;
    } else if (widget.preFilledAddress != null) {
      _detailController.text = widget.preFilledAddress!;
    }
    // Mock pincode for now
    _pincodeController.text = '474005';
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle/Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add address details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.close, size: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Summary
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.black87, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.city ?? 'Deen Dayal Nagar',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black),
                            ),
                            const Text(
                              'Gwalior',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Pincode Field
                  _buildOutlinedField(
                    controller: _pincodeController,
                    label: 'Pincode*',
                    suffixText: 'Gwalior, Madhya Pradesh',
                  ),
                  const SizedBox(height: 20),

                  // Address Detail Field
                  _buildOutlinedField(
                    controller: _detailController,
                    label: 'House number, floor, building name, locality*',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  // Recipient's name
                  _buildOutlinedField(
                    controller: _nameController,
                    label: 'Recipient\'s name*',
                  ),
                  const SizedBox(height: 20),

                  // Phone number
                  _buildOutlinedField(
                    controller: _phoneController,
                    label: 'Phone number*',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Address type*',
                    style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTypeChip('Home'),
                      const SizedBox(width: 12),
                      _buildTypeChip('Office'),
                      const SizedBox(width: 12),
                      _buildTypeChip('Other'),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Save Button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty && _detailController.text.isNotEmpty) {
                    final newAddr = Address(
                      id: widget.editAddress?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _selectedType,
                      fullAddress: _detailController.text,
                      type: _selectedType,
                      recipientName: _nameController.text,
                      phone: _phoneController.text,
                    );
                    
                    if (widget.editAddress != null) {
                      cartProvider.updateAddress(widget.editAddress!.id, newAddr);
                    } else {
                      cartProvider.addAddress(newAddr);
                    }
                    
                    // Close the sheet and navigate back to the appropriate page
                    Navigator.pop(context); // Close sheet
                    Navigator.pop(context); // Pop ConfirmLocation
                    Navigator.pop(context); // Pop SearchLocality
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all mandatory fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5247),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Save address',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedField({
    required TextEditingController controller,
    required String label,
    String? suffixText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF5247), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label) {
    bool isSelected = _selectedType == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D2939) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? const Color(0xFF1D2939) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
