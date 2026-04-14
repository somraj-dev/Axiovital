import 'package:flutter/material.dart';

class PolicyHighlight {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const PolicyHighlight({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class PolicyFeature {
  final String label;
  final String value;
  final String? description;
  final bool isCovered;
  final bool isOptional;

  const PolicyFeature({
    required this.label,
    required this.value,
    this.description,
    this.isCovered = true,
    this.isOptional = false,
  });
}

class PolicyRider {
  final String id;
  final String name;
  final String description;
  final double premium;
  final bool isMustHave;

  PolicyRider({
    required this.id,
    required this.name,
    required this.description,
    required this.premium,
    this.isMustHave = false,
  });
}

class PolicyAddOn {
  final String id;
  final String name;
  final String insurerName;
  final String insurerLogo;
  final List<String> bulletPoints;
  final double cover;
  final double premium;
  final double deductible;

  PolicyAddOn({
    required this.id,
    required this.name,
    required this.insurerName,
    required this.insurerLogo,
    required this.bulletPoints,
    required this.cover,
    required this.premium,
    this.deductible = 0,
  });
}

class PolicyDocument {
  final String name;
  final String type; // e.g., 'PDF'
  final String url;

  const PolicyDocument({
    required this.name,
    required this.type,
    required this.url,
  });
}


class InsurancePolicy {
  final String id;
  final String insurerName;
  final String insurerLogo;
  final String planName;
  final List<String> tagBadges;
  final int cashlessHospitalsCount;
  final String roomRentPolicy;
  final double noClaimBonus;
  final String restorationBenefit;
  final String coPayDetails;
  final List<double> coverAmountOptions;
  final double monthlyPremium;
  final double? oldPremium;
  final double? discountPercent;
  final List<String> features;
  final bool isNew;
  final bool isPopular;
  final String detailContent;
  final String? coverageSummary;
  final String? waitingPeriod;

  // High-fidelity real-world details
  final List<PolicyHighlight> highlights;
  final List<PolicyDocument> documents;
  final Map<String, List<PolicyFeature>> groupedFeatures;
  final String? premiumBenefitInfo; // e.g. "Get up to ₹1,938 in benefits"

  // Comparison specific fields
  final String? ambulanceCharges;
  final String? icuCharges;
  final String? organDonorCover;
  final String? maternityBenefit;
  final String? preHospitalization;
  final String? postHospitalization;

  final List<PolicyRider> availableRiders;
  final List<PolicyAddOn> recommendedAddOns;


  InsurancePolicy({
    required this.id,
    required this.insurerName,
    required this.insurerLogo,
    required this.planName,
    this.tagBadges = const [],
    required this.cashlessHospitalsCount,
    required this.roomRentPolicy,
    required this.noClaimBonus,
    required this.restorationBenefit,
    this.coPayDetails = 'No co-payment',
    required this.coverAmountOptions,
    required this.monthlyPremium,
    this.oldPremium,
    this.discountPercent,
    required this.features,
    this.isNew = false,
    this.isPopular = false,
    this.detailContent = '',
    this.coverageSummary,
    this.waitingPeriod,
    this.highlights = const [],
    this.documents = const [],
    this.groupedFeatures = const {},
    this.premiumBenefitInfo,
    this.ambulanceCharges,
    this.icuCharges,
    this.organDonorCover,
    this.maternityBenefit,
    this.preHospitalization,
    this.postHospitalization,
    this.availableRiders = const [],
    this.recommendedAddOns = const [],
  });

  // Helper to get formatted premium
  String get formattedPremium => '₹${monthlyPremium.toInt()}';
}
