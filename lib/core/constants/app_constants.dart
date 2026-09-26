/// App-wide static values: copy, option lists, and enums-as-strings
/// used by both the seeker and manager flows.
class AppConstants {
  AppConstants._();

  static const String appName = 'Hostel Buddy';
  static const String appTagline = 'Find your fit. Fill your rooms.';

  // Onboarding
  static const int profileSetupSteps = 2;

  // Room seater options — used in Hostel Setup (manager) and
  // Dashboard filters / bidding (seeker)
  static const List<String> seaterOptions = [
    '1 Seater',
    '2 Seater',
    '3 Seater',
    '4 Seater',
    '5+ Seater',
  ];

  // Facilities checklist — used in Hostel Setup and filters
  static const List<String> facilityOptions = [
    'WiFi',
    'AC',
    'Heater',
    'Ironing',
    'Laundry',
    'Geyser',
    'Parking',
    'CCTV',
    'Mess',
    'Generator',
    'Lift',
    'Furnished',
  ];

  // Bid status labels
  static const String bidStatusHighest = 'Highest bid';
  static const String bidStatusSecond = '2nd highest';
  static const String bidStatusOutbid = 'Outbid';
  static const String bidStatusWon = 'Won';
  static const String bidStatusLost = 'Lost';
  static const String bidStatusPending = 'Pending';

  // Roles
  static const String roleSeeker = 'seeker';
  static const String roleManager = 'manager';

  // Hostel Setup limits
  static const int maxHostelPhotos = 8;

  // Currency
  static const String currencySymbol = 'Rs';
}
