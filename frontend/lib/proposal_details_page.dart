import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'insurance_policy_model.dart';
import 'cart_page.dart';

class ProposalDetailsPage extends StatefulWidget {
  final InsurancePolicy policy;
  final double premium;

  const ProposalDetailsPage({super.key, required this.policy, required this.premium});

  @override
  State<ProposalDetailsPage> createState() => _ProposalDetailsPageState();
}

class _ProposalDetailsPageState extends State<ProposalDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Proposal Details',
          style: TextStyle(color: Color(0xFF1D2939), fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete your application',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please provide accurate details to ensure smooth claim processing.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle('Primary Member Details'),
              const SizedBox(height: 16),
              _buildTextField('Full Name', initialValue: 'Somraj Lodhi'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Age', initialValue: '19')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Gender', initialValue: 'Male')),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Email Address', initialValue: 'somraj.lodhi@axio.com'),
              
              const SizedBox(height: 32),
              _buildSectionTitle('KYC Information'),
              const SizedBox(height: 16),
              _buildTextField('PAN Card Number', placeholder: 'ABCDE1234F'),
              const SizedBox(height: 16),
              _buildTextField('Aadhaar Number', placeholder: 'XXXX XXXX XXXX'),
              
              const SizedBox(height: 32),
              _buildSectionTitle('Medical History'),
              const SizedBox(height: 8),
              _buildMedicalToggle('Do you have any pre-existing conditions?'),
              _buildMedicalToggle('Have you been hospitalized in the last 2 years?'),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add to cart before showing success or navigating
                    final cartProvider = Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addItem(
                      productId: widget.policy.id,
                      name: widget.policy.planName,
                      price: widget.premium,
                      imagePath: widget.policy.insurerLogo,
                      type: CartItemType.insurance,
                      subtitle: 'Customized Personal Health Cover',
                      fulfilledBy: 'Axio Team',
                    );

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text('Proposal Submitted'),
                        content: const Text('Your proposal has been sent to the insurer. The policy has been added to your cart for final checkout.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const CartPage()),
                              );
                            },
                            child: const Text('GO TO CART', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0052CC))),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Submit Proposal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D2939)),
    );
  }

  Widget _buildTextField(String label, {String? initialValue, String? placeholder}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildMedicalToggle(String question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(question, style: const TextStyle(fontSize: 14))),
          Switch(value: false, onChanged: (v) {}),
        ],
      ),
    );
  }
}
