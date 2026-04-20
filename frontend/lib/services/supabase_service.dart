import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://ymbcgogohfgztrqucseb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InltYmNnb2dvaGZnenRycXVjc2ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY2MDE1NjEsImV4cCI6MjA5MjE3NzU2MX0.SODwN6dM_9vI6j_MaOQq_Gdf9a5ASLDDMw4kDFCfVsw';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
