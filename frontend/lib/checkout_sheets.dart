import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkout_provider.dart';
import 'cart_provider.dart';
import 'payment_options_page.dart';
import 'appointment_provider.dart';


class CheckoutFlow {
  static void start(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PatientSelectionSheet(),
    );
  }
}

// ─── HELPER COMPONENTS ──────────────────────────────────────────

class _SheetWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? footer;
  final VoidCallback? onBack;

  const _SheetWrapper({
    required this.title,
    required this.child,
    this.footer,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.black54),
        ),
        Positioned(
          top: 60,
          right: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.black, size: 24),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(child: child),
                if (footer != null) footer!,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF2F4F7))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1D2939)),
          ),
        ],
      ),
    );
  }
}

// ─── STEP 1: PATIENT SELECTION ──────────────────────────────────

class PatientSelectionSheet extends StatelessWidget {
  const PatientSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = Provider.of<CheckoutProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return _SheetWrapper(
      title: 'Select patient',
      footer: _buildFooter(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Test Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEAECF0)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.items.isNotEmpty ? cart.items.values.first.name : 'Lab Test Pack',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${checkout.selectedPatientIds.length} patients(s) selected', style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle, size: 14, color: Color(0xFF039855)),
                    ],
                  ),
                  const Divider(height: 24),
                  ...checkout.availablePatients.map((p) => _buildPatientItem(context, p, checkout)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    child: const Center(
                      child: Text('+ Add new patient', style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientItem(BuildContext context, Patient p, CheckoutProvider checkout) {
    bool isSelected = checkout.selectedPatientIds.contains(p.id);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(p.imagePath), radius: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${p.gender}, ${p.age} | Edit', style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
              ],
            ),
          ),
          Checkbox(
            value: isSelected,
            activeColor: const Color(0xFFFF5247),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (_) => checkout.togglePatientSelection(p.id),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF2F4F7)))),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const SlotSelectionSheet(),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5247), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
          child: const Text('Proceed to slot selection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
        ),
      ),
    );
  }
}

// ─── STEP 2: SLOT SELECTION ─────────────────────────────────────

class SlotSelectionSheet extends StatefulWidget {
  const SlotSelectionSheet({super.key});

  @override
  State<SlotSelectionSheet> createState() => _SlotSelectionSheetState();
}

class _SlotSelectionSheetState extends State<SlotSelectionSheet> {
  final List<DateTime> _dates = List.generate(5, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSlotsForSelectedDate();
    });
  }

  void _fetchSlotsForSelectedDate() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final checkout = Provider.of<CheckoutProvider>(context, listen: false);
    if (cart.appointments.isNotEmpty) {
      final doctorId = cart.appointments.first.id.replaceFirst('apt_', '');
      Provider.of<AppointmentProvider>(context, listen: false).fetchSlotsForDoctor(doctorId, checkout.selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkout = Provider.of<CheckoutProvider>(context);

    return _SheetWrapper(
      title: 'Select slot',
      onBack: () {
        Navigator.pop(context);
        showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => const PatientSelectionSheet());
      },
      footer: _buildFooter(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Section
            _buildSummaryRow('Sample collection address', 'Home (M 02 DD Nagar G...', Icons.home_outlined, context),
            const SizedBox(height: 12),
            // Patient Section
            _buildSummaryRow('Patient(s)', checkout.selectedPatients.map((p) => p.name).join(', '), Icons.person_outline, context),
            const SizedBox(height: 24),
            
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 24, color: Color(0xFF9333EA)),
                const SizedBox(width: 12),
                const Text('Sample collection slot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Date Selector
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (context, i) {
                  final d = _dates[i];
                  bool isSelected = checkout.selectedDate.day == d.day;
                  String label = i == 0 ? 'Today' : (i == 1 ? 'Tomorrow' : '${d.day} Apr');
                  return GestureDetector(
                    onTap: () {
                      checkout.setSelectedDate(d);
                      _fetchSlotsForSelectedDate();
                    },
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: isSelected ? const Color(0xFFEAECF0) : const Color(0xFFF2F4F7)),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? Colors.transparent : const Color(0xFFF9FAFB),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Select', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.wb_sunny_outlined, size: 18, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text('Available Slots', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)), child: Text('Live', style: TextStyle(fontSize: 10, color: Colors.green.shade900))),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<CartProvider>(
              builder: (context, cart, _) {
                if (cart.appointments.isNotEmpty) {
                  return Consumer<AppointmentProvider>(
                    builder: (context, aptProv, _) {
                      if (aptProv.isSlotsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final availableSlots = aptProv.availableSlots.where((s) => !s.isBooked).toList();
                      if (availableSlots.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No slots available for this date.', style: TextStyle(color: Colors.red)),
                        );
                      }
                      return Column(
                        children: availableSlots.map((slot) => _slotItem(slot.time, 0, checkout)).toList(),
                      );
                    },
                  );
                } else {
                  // Fallback for Lab tests
                  return Column(
                    children: [
                      _slotItem('6:00 am - 7:00 am', 79, checkout),
                      _slotItem('7:00 am - 8:00 am', 79, checkout),
                      _slotItem('8:00 am - 9:00 am', 79, checkout),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String val, IconData icon, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFEAECF0)), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.pink.shade50, shape: BoxShape.circle), child: Icon(icon, color: Colors.pink, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)), Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)]),
          ),
          const SizedBox(width: 8),
          const Text('Change', style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold, fontSize: 14)),
          const Icon(Icons.chevron_right, color: Color(0xFFFF5247), size: 18),
        ],
      ),
    );
  }

  Widget _slotItem(String time, double fee, CheckoutProvider checkout) {
    bool isSelected = checkout.selectedTimeSlot == time;
    return GestureDetector(
      onTap: () => checkout.setSelectedSlot(time, fee),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF2F4F7)))),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? const Color(0xFFFF5247) : Colors.grey.shade400),
            const SizedBox(width: 12),
            Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text('+₹${fee.toInt()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF2F4F7)))),
      child: SizedBox(
        width: double.infinity, height: 54,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentOptionsPage()));
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5247), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('Confirm slot', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
        ),
      ),
    );
  }
}

// DELETE PaymentOptionsSheet class as it's now a standalone page

