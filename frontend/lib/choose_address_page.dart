import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'search_locality_page.dart';

class ChooseAddressPage extends StatelessWidget {
  const ChooseAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final addresses = cartProvider.recentAddresses;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Choose address',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          if (addresses.isEmpty)
            Expanded(child: _buildEmptyState(context))
          else ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchLocalityPage()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEAECF0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Add new address',
                    style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Recent addresses', style: TextStyle(color: Color(0xFF667085), fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final addr = addresses[index];
                  bool isSelected = cartProvider.selectedAddressIndex == index;
                  return GestureDetector(
                    onTap: () => cartProvider.selectAddress(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: isSelected ? Colors.black : const Color(0xFFEAECF0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: isSelected ? const Color(0xFFFF5247) : Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                addr.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 36),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  addr.fullAddress,
                                  style: const TextStyle(color: Color(0xFF344054), fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${addr.recipientName}\n${addr.phone}',
                                  style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchLocalityPage(editAddress: addr)));
                                      },
                                      child: const Text('Edit', style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 16),
                                    TextButton(
                                      onPressed: () => cartProvider.removeAddress(addr.id),
                                      child: const Text('Remove', style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5247),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.location_off_outlined, size: 80, color: Color(0xFFFF5247)),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'No addresses saved yet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1D2939),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Save your home, office and other addresses to enjoy a faster checkout experience.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF667085),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 220,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchLocalityPage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5247),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              'Add new address',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
