import 'package:flutter/material.dart';

class RescheduleAppointmentPage extends StatefulWidget {
  final Map<String, dynamic>? appointmentData;
  const RescheduleAppointmentPage({super.key, this.appointmentData});

  @override
  State<RescheduleAppointmentPage> createState() => _RescheduleAppointmentPageState();
}

class _RescheduleAppointmentPageState extends State<RescheduleAppointmentPage> {
  bool isInPerson = true;
  DateTime selectedDate = DateTime(2024, 12, 11);
  String? selectedTime;

  final List<String> morningSlots = ['08:00 am', '09:00 am', '10:00 am', '11:00 am', '12:00 pm'];
  final List<String> afternoonSlots = ['01:00 pm', '02:00 pm', '03:00 pm', '04:00 pm', '05:00 pm'];
  final List<String> eveningSlots = ['06:00 pm', '07:00 pm', '08:00 pm', '09:00 pm'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book appointment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle Switch
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9ECEF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isInPerson = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isInPerson ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: isInPerson ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
                          ),
                          child: Center(
                            child: Text(
                              'In Person',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isInPerson ? Colors.black : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isInPerson = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isInPerson ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: !isInPerson ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
                          ),
                          child: Center(
                            child: Text(
                              'Video Visit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !isInPerson ? Colors.black : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Location Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.black87),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.appointmentData?['clinic_address'] ?? widget.appointmentData?['location'] ?? '123 Maple Street, Sunnyvale, CA...',
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Calendar UI
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Month Selector
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back_ios, size: 16), onPressed: () {}),
                          const Text('December 2024', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), onPressed: () {}),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Days Row
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          final dates = ['10', '11', '12', '13', '14', '15', '16'];
                          bool isSelected = index == 1; // Tuesday 11
                          return Container(
                            width: 65,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.transparent : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isSelected ? const Color(0xFF2D3282) : Colors.grey.shade200),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(days[index], style: TextStyle(color: Colors.black54, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(dates[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time Slots Sections
                    _buildTimeSection('Morning', morningSlots),
                    _buildTimeSection('Afternoon', afternoonSlots),
                    _buildTimeSection('Evening', eveningSlots),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // View more availability
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text('View more availability', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection(String title, List<String> slots) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: slots.map((time) {
              bool isSelected = selectedTime == time;
              bool isBooked = time == '03:00 pm' || time == '04:00 pm' || time == '07:00 pm'; // Just for visual demo
              return GestureDetector(
                onTap: isBooked ? null : () => setState(() => selectedTime = time),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 80) / 3,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2D3282) : (isBooked ? const Color(0xFFF1F3F5) : Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? const Color(0xFF2D3282) : Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected ? Colors.white : (isBooked ? Colors.black26 : Colors.black87),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
