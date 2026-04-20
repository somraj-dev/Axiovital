import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insurance_policy_model.dart';
import 'package:flutter/material.dart';

class InsuranceService {
  final _supabase = Supabase.instance.client;

  Future<List<InsurancePolicy>> getPolicies({int page = 1, int limit = 5}) async {
    try {
      final List<dynamic> data = await _supabase
          .from('insurance_plans')
          .select()
          .range((page - 1) * limit, page * limit - 1);

      return data.map((json) {
        // Parse JSONB highlights
        final highlightsJson = json['highlights'] as List<dynamic>? ?? [];
        final List<PolicyHighlight> highlights = highlightsJson.map((h) => PolicyHighlight(
          title: h['title'],
          subtitle: h['subtitle'],
          icon: _parseIcon(h['icon']),
          color: _parseColor(h['color']),
        )).toList();

        // Parse JSONB features
        final featuresMap = json['features'] as Map<String, dynamic>? ?? {};
        final Map<String, List<PolicyFeature>> groupedFeatures = {};
        featuresMap.forEach((key, value) {
          groupedFeatures[key] = (value as List).map((f) => PolicyFeature(
            label: f['label'],
            value: f['value'],
            description: f['description'],
            isCovered: f['isCovered'] ?? true,
            isOptional: f['isOptional'] ?? false,
          )).toList();
        });

        // Parse JSONB riders
        final ridersJson = json['riders'] as List<dynamic>? ?? [];
        final List<PolicyRider> riders = ridersJson.map((r) => PolicyRider(
          id: r['id'],
          name: r['name'],
          description: r['description'],
          premium: (r['premium'] as num).toDouble(),
          isMustHave: r['isMustHave'] ?? false,
        )).toList();

        return InsurancePolicy(
          id: json['id'].toString(),
          insurerName: json['insurer_name'],
          insurerLogo: json['insurer_logo'],
          planName: json['plan_name'],
          monthlyPremium: (json['monthly_premium'] as num).toDouble(),
          oldPremium: (json['old_premium'] as num).toDouble(),
          discountPercent: (json['discount_percent'] as num).toDouble(),
          tagBadges: List<String>.from(json['tags'] ?? []),
          highlights: highlights,
          groupedFeatures: groupedFeatures,
          availableRiders: riders,
          features: ['Cashless Treatment', 'No Room Rent Limit'], // Mock features
          coverAmountOptions: [500000, 1000000, 2000000], // Mock options
          cashlessHospitalsCount: json['cashless_hospitals_count'] ?? 0,
          roomRentPolicy: json['room_rent_policy'] ?? 'Single private ac room',
          noClaimBonus: (json['no_claim_bonus'] as num?)?.toDouble() ?? 500000,
          restorationBenefit: json['restoration_benefit'] ?? 'Unlimited Restoration',
          documents: [], // To be fetched from Storage if needed
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching insurance plans from Supabase: $e');
      return [];
    }
  }

  // Helpers for JSON parsing
  IconData _parseIcon(String? iconName) {
    switch (iconName) {
      case 'security': return Icons.security_outlined;
      case 'hotel': return Icons.hotel_outlined;
      case 'auto_awesome': return Icons.auto_awesome_outlined;
      default: return Icons.help_outline;
    }
  }

  Color _parseColor(String? colorHex) {
    if (colorHex == null) return Colors.grey.shade200;
    return Color(int.parse(colorHex.replaceFirst('#', 'ff'), radix: 16));
  }
}
