import 'package:supabase_flutter/supabase_flutter.dart';

class VitalsService {
  final _supabase = Supabase.instance.client;

  // Fetch the latest summarized vitals
  Future<Map<String, dynamic>> getLatestVitals(String userId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('vitals')
          .select()
          .eq('user_id', userId)
          .order('recorded_at', ascending: false)
          .limit(10);
      
      final Map<String, dynamic> latest = {};
      for (var row in data) {
        final type = row['type']?.toString().toLowerCase();
        if (type != null && !latest.containsKey(type)) {
          latest[type] = row['value'];
          // For BP, we often store heart_rate, systolic_bp, diastolic_bp
        }
      }
      return latest;
    } catch (e) {
      print('Error fetching latest vitals: $e');
      return {};
    }
  }

  // Add a new vital reading
  Future<void> addVital(String type, String value, String unit) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('vitals').insert({
        'user_id': user.id,
        'type': type,
        'value': value,
        'unit': unit,
        'recorded_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding vital to Supabase: $e');
    }
  }

  // Fetch history for a vital type
  Future<List<Map<String, dynamic>>> getVitalHistory(String type) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final List<dynamic> data = await _supabase
          .from('vitals')
          .select()
          .eq('user_id', user.id)
          .eq('type', type)
          .order('recorded_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching vitals from Supabase: $e');
      return [];
    }
  }
}
