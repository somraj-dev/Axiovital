import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class InvoicePage extends StatelessWidget {
  final Map<String, dynamic> invoiceData;

  const InvoicePage({super.key, required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    
    // Extract Data
    final String invoiceNumber = invoiceData['invoiceNumber'] ?? 'INV-0231';
    final String billedByName = invoiceData['billedByName'] ?? 'AxioVital Health';
    final String billedByEmail = invoiceData['billedByEmail'] ?? 'billing@axiovital.com';
    final String billedByAddress = invoiceData['billedByAddress'] ?? '123 Health Ave, Wellness City';
    
    final String billedToName = invoiceData['billedToName'] ?? userProvider.name;
    final String billedToEmail = invoiceData['billedToEmail'] ?? userProvider.email;
    final String billedToAddress = invoiceData['billedToAddress'] ?? 'Patient Registered Address';
    
    final DateTime issuedDate = invoiceData['issuedDate'] ?? DateTime.now();
    final DateTime dueDate = invoiceData['dueDate'] ?? issuedDate.add(const Duration(days: 3));
    
    final List<Map<String, dynamic>> items = invoiceData['items'] ?? [];
    
    final double subtotal = invoiceData['subtotal'] ?? items.fold(0.0, (sum, item) => sum + (item['total'] ?? 0.0));
    final double tax = invoiceData['tax'] ?? (subtotal * 0.1); // 10% default
    final double discount = invoiceData['discount'] ?? 0.0;
    final double total = subtotal + tax - discount;

    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invoice downloading...'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print_rounded, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invoice',
                  style: GoogleFonts.inter(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1D2939),
                    letterSpacing: -1.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2939),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Invoice Number
            Row(
              children: [
                Text(
                  'Invoice Number',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF98A2B3), fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 48),
                Text(
                  invoiceNumber,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF1D2939)),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Billed Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Billed By
                Expanded(
                  child: _buildBilledColumn(
                    'Billed by:',
                    billedByName,
                    billedByEmail,
                    billedByAddress,
                  ),
                ),
                // Billed To
                Expanded(
                  child: _buildBilledColumn(
                    'Billed to:',
                    billedToName,
                    billedToEmail,
                    billedToAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Dates Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Issued Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Issued:',
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF98A2B3), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dateFormat.format(issuedDate),
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF1D2939)),
                      ),
                    ],
                  ),
                ),
                // Due Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date:',
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF98A2B3), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dateFormat.format(dueDate),
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF1D2939)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            
            // Table Header
            Row(
              children: [
                Expanded(flex: 4, child: Text('Item', style: _tableHeaderStyle())),
                Expanded(flex: 1, child: Center(child: Text('QTY', style: _tableHeaderStyle()))),
                Expanded(flex: 2, child: Center(child: Text('Cost', style: _tableHeaderStyle()))),
                Expanded(flex: 2, child: TextAlign.right == TextAlign.right 
                  ? Align(alignment: Alignment.centerRight, child: Text('Total', style: _tableHeaderStyle()))
                  : Text('Total', style: _tableHeaderStyle())),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
            ),
            
            // Table Body
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4, 
                    child: Text(
                      item['name'] ?? 'Item Name', 
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1D2939)),
                    ),
                  ),
                  Expanded(
                    flex: 1, 
                    child: Center(
                      child: Text(
                        '${item['qty'] ?? 1}', 
                        style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF475467)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2, 
                    child: Center(
                      child: Text(
                        '₹${item['cost']?.toStringAsFixed(2) ?? '0.00'}', 
                        style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF475467)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2, 
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '₹${item['total']?.toStringAsFixed(2) ?? '0.00'}', 
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1D2939)),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
            
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 24),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
            ),
            
            // Totals Section
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 250,
                child: Column(
                  children: [
                    _buildTotalRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}', isBold: false),
                    const SizedBox(height: 12),
                    _buildTotalRow('Tax', '10%(₹${tax.toStringAsFixed(2)})', isBold: false),
                    const SizedBox(height: 12),
                    _buildTotalRow('Discount', '₹${discount.toStringAsFixed(2)}', isBold: false),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: Color(0xFFF2F4F7)),
                    ),
                    _buildTotalRow('TOTAL', '₹${total.toStringAsFixed(2)}', isBold: true, fontSize: 18),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 80),
            
            // Footer
            Text(
              'Thank you for your purchase! We appreciate your business and look forward to serving you again.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBilledColumn(String label, String name, String email, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF98A2B3), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF1D2939)),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF475467)),
        ),
        const SizedBox(height: 2),
        Text(
          address,
          style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF475467)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
            color: isBold ? const Color(0xFF1D2939) : const Color(0xFF98A2B3),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
            color: const Color(0xFF1D2939),
          ),
        ),
      ],
    );
  }

  TextStyle _tableHeaderStyle() {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF98A2B3),
      letterSpacing: 0.5,
    );
  }
}
