import 'dart:async';
import 'package:flutter/material.dart';
import 'insurance_policy_model.dart';

class InsuranceService {
  // Mock insurers data
  static const List<Map<String, String>> insurers = [
    {'name': 'Axio Shield', 'logo': 'https://cdn-icons-png.flaticon.com/512/9363/9363121.png'},
    {'name': 'Star Health', 'logo': 'https://cdn-icons-png.flaticon.com/512/2966/2966334.png'},
    {'name': 'Niva Bupa', 'logo': 'https://cdn-icons-png.flaticon.com/512/3063/3063102.png'},
    {'name': 'Care Health', 'logo': 'https://cdn-icons-png.flaticon.com/512/3063/3063080.png'},
    {'name': 'HDFC ERGO', 'logo': 'https://cdn-icons-png.flaticon.com/512/3063/3063067.png'},
  ];

  static const List<String> planNames = [
    'Super Star Value',
    'ReAssure 3.0 Elite',
    'Ultimate Care (Direct)',
    'ActivOne Smart',
    'Health Gain 3.0',
    'Family Optima',
  ];

  static const List<String> tags = ['New Launch', 'Popular', 'Best Value', 'High Claim Support'];

  Future<List<InsurancePolicy>> getPolicies({int page = 1, int limit = 5}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    List<InsurancePolicy> policies = [];
    int startIndex = (page - 1) * limit;

    for (int i = 0; i < limit; i++) {
      int id = startIndex + i;
      final isOptima = id % 2 == 0;
      final planName = id == 0 ? 'Ultimate Care (Direct)' : (isOptima ? 'Optima Select' : 'Super Star Value');
      final insurer = insurers[id % insurers.length];

      policies.add(
        InsurancePolicy(
          id: 'pol_$id',
          insurerName: insurer['name']!,
          insurerLogo: insurer['logo']!,
          planName: planName,
          monthlyPremium: 432.0 + (id * 50),
          oldPremium: 650.0 + (id * 100),
          discountPercent: 5.0,
          coverAmountOptions: [500000, 1000000, 1500000, 2000000],
          cashlessHospitalsCount: 320 + (id * 15),
          roomRentPolicy: 'Single private ac room',
          noClaimBonus: 500000,
          restorationBenefit: 'Unlimited Restoration',
          tagBadges: id == 0 ? ['BEST SELLER'] : [],
          coverageSummary: 'Comprehensive Coverage',
          waitingPeriod: '3 years for pre-existing diseases',
          premiumBenefitInfo: 'Get up to ₹2,500 in benefits on renewal.',
          highlights: [
            PolicyHighlight(
              title: isOptima ? 'ReAssure Forever' : 'Unlimited Restore',
              subtitle: isOptima 
                ? 'Get unique power to increase cover 5X at 4 renewals' 
                : 'Unlimited restoration of cover for related illness',
              icon: Icons.auto_awesome_outlined,
              color: const Color(0xFFFEF0C7),
            ),
            PolicyHighlight(
              title: isOptima ? 'Protect Benefit' : 'Global Cover',
              subtitle: isOptima 
                ? 'Fixed daily cash for every day of hospitalization' 
                : 'Emergency global coverage for planned treatments',
              icon: Icons.security_outlined,
              color: const Color(0xFFD1FADF),
            ),
            PolicyHighlight(
              title: 'No Room Rent Limit',
              subtitle: 'Choose any room in a hospital according to your choice',
              icon: Icons.hotel_outlined,
              color: const Color(0xFFEAECF0),
            ),
          ],
          groupedFeatures: {
            'Coverage': [
              PolicyFeature(label: 'Co-pay', value: '0% Co-payment', description: 'No co-payment required for any age group.', isCovered: true),
              PolicyFeature(label: 'Pre-hospitalization', value: 'Covered up to 60 days', description: 'Medicines and tests before admission are covered.', isCovered: true),
              PolicyFeature(label: 'Post-hospitalization', value: 'Covered up to 180 days', description: 'Medicines and tests after discharge are covered.', isCovered: true),
              PolicyFeature(label: 'Day care treatment', value: 'All treatments covered', description: 'Procedures requiring less than 24h stay are covered.', isCovered: true),
            ],
            'Value Added Services': [
              PolicyFeature(label: 'E-consultation', value: 'Unlimited Access', description: 'Access to top general physicians 24x7.', isOptional: true),
              PolicyFeature(label: 'Annual check-up', value: '1 Checkup free', description: 'Detailed health checkup once every year.', isCovered: true),
              PolicyFeature(label: 'Dietary counseling', value: 'Add-on', description: 'Personalized diet plans from certified nutritionists.', isOptional: true),
              PolicyFeature(label: 'Second Opinion', value: 'Not covered', description: 'Expert second medical opinion is not included.', isCovered: false),
            ],
          },
          documents: [
            const PolicyDocument(name: 'Policy Wording', type: 'PDF', url: '#'),
            const PolicyDocument(name: 'Policy Brochure', type: 'PDF', url: '#'),
            const PolicyDocument(name: 'Network Hospital List', type: 'PDF', url: '#'),
          ],
          features: [
            '320+ Cashless hospitals',
            'No room rent limit',
            'Unlimited restoration',
            'Full medical checkup',
          ],
          detailContent: 'This is a premium high-fidelity health plan offering comprehensive protection with zero-copay and unlimited restoration benefits.',
          ambulanceCharges: '₹10,000 per hospitalization',
          icuCharges: 'No limit',
          organDonorCover: 'Covered up to Sum Insured',
          maternityBenefit: id % 3 == 0 ? 'Wait 2yr | ₹50k' : 'Not Covered',
          preHospitalization: 'Covered up to 60 days',
          postHospitalization: 'Covered up to 180 days',
          availableRiders: [
            PolicyRider(
              id: 'r1',
              name: 'Protect Benefit',
              description: 'Zero deduction on non-medical expenses. Guaranteed payment of consumables...',
              premium: 511,
              isMustHave: true,
            ),
            PolicyRider(
              id: 'r2',
              name: 'Plus Benefit',
              description: 'Get 50% of base sum insured per year maximum up to 100% irrespective of claim',
              premium: 170,
              isMustHave: true,
            ),
            PolicyRider(
              id: 'r3',
              name: 'ABCD Chronic Care',
              description: 'Get coverage for Asthma, Blood pressure, Cholesterol and Diabetes from 31st day',
              premium: 450,
            ),
          ],
          recommendedAddOns: [
            PolicyAddOn(
              id: 'a1',
              name: 'Health Recharge',
              insurerName: 'Niva Bupa',
              insurerLogo: 'https://cdn-icons-png.flaticon.com/512/3063/3063102.png',
              bulletPoints: [
                'All day care treatments are covered.',
                'Upto Single private AC room is covered.',
                'Existing illness covered after 3 years covered.',
              ],
              cover: 4000000,
              premium: 627,
              deductible: 1000000,
            ),
          ],
        ),
      );
    }

    return policies;
  }
}
