import '../../app/localization/app_strings.dart';

/// The three safety triage tiers defined in Section 6.
enum SafetyLevel {
  /// Level 0: Normal investigation. Ordinary stress, frustration, sadness.
  /// The app proceeds as usual.
  level0Normal,

  /// Level 1: Soft redirect (elevated distress).
  /// Acknowledges feelings first, shifts to supportive tone with fewer hypotheses,
  /// offers to continue later, keeps support option visible.
  level1SoftRedirect,

  /// Level 2: Gentle pause (possible crisis).
  /// Investigation stops (no analysis, no hypotheses, no findings).
  /// Responds with warmth, shows crisis resources with one-tap access.
  /// Never a dead end: the user can return to the case afterward.
  level2GentlePause,
}

/// Represents an emergency or crisis helpline resource.
class CrisisResource {
  const CrisisResource({
    required this.name,
    required this.description,
    required this.phone,
    this.sms,
    this.website,
    required this.countryCode,
    this.isTollFree = false,
  });

  final String name;
  final String description;
  final String phone;
  final String? sms;
  final String? website;
  final String countryCode;
  final bool isTollFree;

  String localizedName(AppStrings strings) {
    switch (phone) {
      case '190':
        if (strings.isArabic) return 'SAMU — الإسعاف الطبي الاستعجالي';
        if (strings.isFrench) return 'SAMU — Urgences Médicales';
        return 'SAMU — Medical Emergencies';
      case '198':
        if (strings.isArabic) return 'الحماية المدنية';
        if (strings.isFrench) return 'Protection Civile';
        return 'Civil Protection';
      case '80105050':
        if (strings.isArabic) return 'الخط الأخضر للإنصات والدعم (وزارة الصحة)';
        if (strings.isFrench) {
          return 'Ligne Verte d’Écoute (Ministère de la Santé)';
        }
        return 'Helpline — Ministry of Health (Ligne Verte)';
      case '1899':
        if (strings.isArabic) return 'الرقم الأخضر للإشعار والدعم الاجتماعي';
        if (strings.isFrench) return 'Ligne d’Écoute et d’Assistance Sociale';
        return 'Social Support Helpline';
      default:
        if (website != null) {
          if (strings.isArabic) return 'شبكة الدعم العاطفي الدولية (Befrienders)';
          if (strings.isFrench) return 'Befrienders Worldwide (Écoute)';
          return 'Befrienders Worldwide';
        }
        return name;
    }
  }

  String localizedDescription(AppStrings strings) {
    switch (phone) {
      case '190':
        if (strings.isArabic) {
          return 'خدمة المساعدة الطبية الاستعجالية الرسمية في تونس (24/7).';
        }
        if (strings.isFrench) {
          return 'Service officiel d’aide médicale urgente 24h/24 et 7j/7 en Tunisie.';
        }
        return 'Official 24/7 emergency medical assistance in Tunisia.';
      case '198':
        if (strings.isArabic) {
          return 'النجدة والإسعاف العاجل على مدار الساعة (24/7).';
        }
        if (strings.isFrench) {
          return 'Secours d’urgence et assistance immédiate 24h/24 et 7j/7.';
        }
        return '24/7 emergency rescue and immediate assistance.';
      case '80105050':
        if (strings.isArabic) {
          return 'رقم مجاني للإنصات والتوجيه النفسي تحت إشراف وزارة الصحة.';
        }
        if (strings.isFrench) {
          return 'Numéro vert d’orientation et d’écoute psychologique (Ministère de la Santé).';
        }
        return 'Toll-free psychological listening & guidance line (Ministry of Health).';
      case '1899':
        if (strings.isArabic) {
          return 'الرقم الأخضر الوطني للتوجيه والمساعدة الاجتماعية.';
        }
        if (strings.isFrench) {
          return 'Numéro vert national pour l’orientation et l’assistance sociale.';
        }
        return 'National toll-free social support and guidance line.';
      default:
        if (website != null) {
          if (strings.isArabic) {
            return 'دليل دولي لمراكز الإنصات والدعم النفسي التطوعي.';
          }
          if (strings.isFrench) {
            return 'Annuaire international de centres d’écoute bénévole et de soutien.';
          }
          return 'International directory of volunteer emotional support centers.';
        }
        return description;
    }
  }

  /// Official Tunisian and Regional Crisis Resources.
  ///
  /// Section 6: "Crisis resources depend on country, so a region-aware list is needed."
  static const List<CrisisResource> tunisianResources = [
    CrisisResource(
      name: 'SAMU - Urgences Médicales\nالإسعاف الطبي الاستعجالي',
      description:
          'Service officiel d’aide médicale urgente (Urgences médicales 24h/24 et 7j/7 en Tunisie).',
      phone: '190',
      countryCode: 'TN',
      isTollFree: false,
    ),
    CrisisResource(
      name: 'Protection Civile\nالحماية المدنية',
      description:
          'Secours d’urgence et assistance immédiate 24h/24 et 7j/7.',
      phone: '198',
      countryCode: 'TN',
      isTollFree: false,
    ),
    CrisisResource(
      name: 'Ligne Verte d’Écoute (Ministère de la Santé)\nالخط الأخضر للإنصات والدعم',
      description:
          'Numéro vert d’orientation et d’écoute psychologique sous tutelle du Ministère de la Santé.',
      phone: '80105050',
      countryCode: 'TN',
      isTollFree: true,
    ),
    CrisisResource(
      name: 'Ligne d’Écoute et d’Assistance Sociale\nالرقم الأخضر للإشعار والدعم',
      description:
          'Numéro vert national pour l’orientation et l’assistance sociale.',
      phone: '1899',
      countryCode: 'TN',
      isTollFree: true,
    ),
    CrisisResource(
      name: 'Befrienders Worldwide\nشبكة الدعم العاطفي الدولية',
      description:
          'Annuaire international de centres d’écoute bénévole et de soutien émotionnel.',
      phone: '',
      website: 'https://www.befrienders.org',
      countryCode: 'GLOBAL',
      isTollFree: false,
    ),
  ];
}
