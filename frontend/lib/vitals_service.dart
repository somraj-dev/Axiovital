import 'package:dio/dio.dart';

class VitalsService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:7860'));
  
  // Singleton pattern
  static final VitalsService _instance = VitalsService._internal();
  factory VitalsService() => _instance;
  VitalsService._internal();

  Future<Map<String, dynamic>?> getLatestVitals(String userId) async {
    try {
      final response = await _dio.get('/api_v1/vitals/$userId', queryParameters: {'limit': 1});
      if (response.statusCode == 200 && (response.data as List).isNotEmpty) {
        return response.data[0];
      }
      return null;
    } catch (e) {
      print('Error fetching vitals: $e');
      return null;
    }
  }

  Future<List<dynamic>> getVitalsHistory(String userId, {int limit = 10}) async {
    try {
      final response = await _dio.get('/api_v1/vitals/$userId', queryParameters: {'limit': limit});
      if (response.statusCode == 200) {
        return response.data;
      }
      return [];
    } catch (e) {
      print('Error fetching vitals history: $e');
      return [];
    }
  }
}
