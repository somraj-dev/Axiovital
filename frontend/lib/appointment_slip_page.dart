import 'package:flutter/material.dart';
import 'appointment_slip_detail.dart';
import 'widgets/axio_verified_badge.dart';
import 'invoice_page.dart';

class AppointmentSlipPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  const AppointmentSlipPage({super.key, required this.appointmentData});

  @override
  State<AppointmentSlipPage> createState() => _AppointmentSlipPageState();
}

class _AppointmentSlipPageState extends State<AppointmentSlipPage> {
  final List<bool> _prepList = [false, false, false];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = widget.appointmentData;
    final isDark = theme.brightness == Brightness.dark;
    
    // Defensive extraction
    final items = data['items'] is List ? data['items'] as List : [];
    final firstItem = items.isNotEmpty ? items[0] : {};
    
    final String appointmentName = firstItem['name'] ?? 'Doctor Consultation';
    final String speciality = firstItem['category'] ?? 'General';
    final String price = '₹${firstItem['price'] ?? 0}';
    final String date = data['date'] ?? 'Tomorrow, 10:30 AM';
    final String confirmationNumber = data['confirmationNumber'] ?? 'CONF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final String pin = data['pin'] ?? '0000';

    final Color cardColor = theme.colorScheme.surfaceVariant;
    final Color textColor = theme.colorScheme.onSurface;
    final Color iconColor = theme.colorScheme.onSurface.withOpacity(0.5);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.receipt_long_rounded, color: textColor, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoicePage(
                    invoiceData: {
                      'invoiceNumber': confirmationNumber,
                      'items': [{
                        'name': appointmentName,
                        'qty': 1,
                        'cost': items.isNotEmpty ? items[0]['price'] ?? 0.0 : 0.0,
                        'total': items.isNotEmpty ? items[0]['price'] ?? 0.0 : 0.0,
                      }],
                      'subtotal': items.isNotEmpty ? items[0]['price'] ?? 0.0 : 0.0,
                      'tax': (items.isNotEmpty ? items[0]['price'] ?? 0.0 : 0.0) * 0.1,
                    },
                  ),
                ),
              );
            },
            tooltip: 'View Invoice',
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: textColor, size: 24),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Success Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF039855).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: Color(0xFF15B79E), size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your booking is confirmed',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ve sent the details to your email.',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Confirmation & PIN Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirmation number',
                            style: TextStyle(
                              color: textColor.withOpacity(0.4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            confirmationNumber,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(color: textColor.withOpacity(0.1), thickness: 1),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PIN code',
                              style: TextStyle(
                                color: textColor.withOpacity(0.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pin,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Detail Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF323B45) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://cdn-icons-png.flaticon.com/512/3774/3774299.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  appointmentName,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const AxioVerifiedBadge(size: 14),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              price,
                              style: TextStyle(
                                color: textColor.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: textColor.withOpacity(0.1)),
                  const SizedBox(height: 20),
                  _buildDetailRow(Icons.calendar_today_outlined, date, textColor),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.medical_services_outlined, speciality, textColor),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View or update details',
                        style: TextStyle(
                          color: Color(0xFF2E90FA),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // "Prepare for your visit" Section
            Text(
              'Prepare for your visit',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCheckItem(0, 'Bring your medical reports', cardColor, textColor),
            _buildCheckItem(1, 'Wear comfortable clothing', cardColor, textColor),
            _buildCheckItem(2, 'Arrive 15 minutes early', cardColor, textColor),

            const SizedBox(height: 60),

            // Primary Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentSlipDetail(
                        appointmentData: data,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E90FA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Appointment Slip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color textColor) {
    return Row(
      children: [
        Icon(icon, color: textColor.withOpacity(0.4), size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(int index, String text, Color cardColor, Color textColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _prepList[index] = !_prepList[index];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              _prepList[index] ? Icons.check_box : Icons.check_box_outline_blank,
              color: _prepList[index] ? const Color(0xFF15B79E) : textColor.withOpacity(0.3),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: _prepList[index] ? textColor : textColor.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
