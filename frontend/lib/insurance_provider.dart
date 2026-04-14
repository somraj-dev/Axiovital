import 'package:flutter/material.dart';
import 'insurance_policy_model.dart';
import 'insurance_service.dart';

class InsuranceProvider extends ChangeNotifier {
  final InsuranceService _service = InsuranceService();

  List<InsurancePolicy> _policies = [];
  List<InsurancePolicy> get policies => _policies;

  List<InsurancePolicy> _selectedForCompare = [];
  List<InsurancePolicy> get selectedForCompare => _selectedForCompare;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _currentPage = 1;

  Map<String, dynamic> _filters = {};
  Map<String, dynamic> get filters => _filters;

  InsuranceProvider() {
    fetchPolicies();
  }

  Future<void> fetchPolicies({bool refresh = false}) async {
    if (_isLoading) return;
    if (!refresh && !_hasMore) return;

    if (refresh) {
      _currentPage = 1;
      _policies = [];
      _hasMore = true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newPolicies = await _service.getPolicies(page: _currentPage, limit: 10);
      if (newPolicies.isEmpty) {
        _hasMore = false;
      } else {
        _policies.addAll(newPolicies);
        _currentPage++;
      }
    } catch (e) {
      debugPrint('Error fetching policies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleCompare(InsurancePolicy policy) {
    if (_selectedForCompare.any((p) => p.id == policy.id)) {
      _selectedForCompare.removeWhere((p) => p.id == policy.id);
    } else {
      if (_selectedForCompare.length < 2) {
        _selectedForCompare.add(policy);
      } else {
        // Replace the last one if we try to add a 3rd
        _selectedForCompare.removeLast();
        _selectedForCompare.add(policy);
      }
    }
    notifyListeners();
  }

  void removeSelectedCompare(String id) {
    _selectedForCompare.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void clearCompare() {
    _selectedForCompare = [];
    notifyListeners();
  }

  bool isSelectedForCompare(String id) {
    return _selectedForCompare.any((p) => p.id == id);
  }

  void applyFilters(Map<String, dynamic> newFilters) {
    _filters = newFilters;
    fetchPolicies(refresh: true);
  }

  void resetFilters() {
    _filters = {};
    fetchPolicies(refresh: true);
  }
}
