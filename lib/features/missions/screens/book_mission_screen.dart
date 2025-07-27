import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/core/navigation/app_router.dart';
import 'package:random_01_space_travel/features/missions/models/mission_model.dart';
import 'package:random_01_space_travel/features/missions/providers/missions_provider.dart';
import 'package:random_01_space_travel/features/planets/models/planet_model.dart';
import 'package:random_01_space_travel/features/planets/providers/planets_provider.dart';
import 'package:random_01_space_travel/shared/providers/animations_provider.dart';
import 'package:random_01_space_travel/shared/providers/audio_provider.dart';
import 'package:random_01_space_travel/shared/services/haptic_service.dart';
import 'package:random_01_space_travel/shared/widgets/glass_card.dart';
import 'package:random_01_space_travel/shared/widgets/space_button.dart';
import 'package:random_01_space_travel/shared/widgets/star_field_background.dart';

class BookMissionScreen extends StatefulWidget {
  final String planetId;
  
  const BookMissionScreen({Key? key, required this.planetId}) : super(key: key);

  @override
  State<BookMissionScreen> createState() => _BookMissionScreenState();
}

class _BookMissionScreenState extends State<BookMissionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  MissionType _selectedMissionType = MissionType.surfaceExpedition;
  DateTime _departureDate = DateTime.now().add(const Duration(days: 30));
  int _passengerCount = 1;
  String _selectedSpaceship = '';
  bool _isBookingInProgress = false;
  bool _isBookingComplete = false;
  
  // Text controllers
  final TextEditingController _captainController = TextEditingController(text: 'Alex Nova');
  final TextEditingController _spaceshipController = TextEditingController();
  
  // Available spaceships
  final List<Map<String, dynamic>> _spaceships = [
    {
      'id': 'ss-001',
      'name': 'Stellar Voyager',
      'capacity': 8,
      'speed': 'Fast',
      'comfort': 'Luxury',
      'imagePath': 'assets/images/spaceships/stellar_voyager.png',
    },
    {
      'id': 'ss-002',
      'name': 'Cosmic Explorer',
      'capacity': 12,
      'speed': 'Medium',
      'comfort': 'Standard',
      'imagePath': 'assets/images/spaceships/cosmic_explorer.png',
    },
    {
      'id': 'ss-003',
      'name': 'Nebula Cruiser',
      'capacity': 20,
      'speed': 'Slow',
      'comfort': 'Economy',
      'imagePath': 'assets/images/spaceships/nebula_cruiser.png',
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    // Set default spaceship
    _selectedSpaceship = _spaceships[0]['id'];
    _spaceshipController.text = _spaceships[0]['name'];
    
    // Load planet data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final planetsProvider = Provider.of<PlanetsProvider>(context, listen: false);
      
      if (planetsProvider.selectedPlanet?.id != widget.planetId) {
        planetsProvider.selectPlanet(widget.planetId);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _captainController.dispose();
    _spaceshipController.dispose();
    super.dispose();
  }
  
  // Get the selected planet from the provider
  Planet get planet => Provider.of<PlanetsProvider>(context, listen: false).selectedPlanet!;
  
  // Helper methods for mission creation
  String _getMissionName() {
    String prefix = '';
    
    switch (_selectedMissionType) {
      case MissionType.surfaceExpedition:
        prefix = 'Expedition to';
        break;
      case MissionType.researchMission:
        prefix = 'Research Mission:';
        break;
      case MissionType.colonizationProject:
        prefix = 'Colonization Project:';
        break;
      case MissionType.luxuryCruise:
        prefix = 'Luxury Cruise to';
        break;
      case MissionType.orbitalTour:
        prefix = 'Orbital Tour of';
        break;
      case MissionType.miningOperation:
        prefix = 'Mining Operation:';
        break;
    }
    
    return '$prefix ${planet.name}';
  }
  
  String _getMissionDescription() {
    switch (_selectedMissionType) {
      case MissionType.surfaceExpedition:
        return 'An exciting expedition to explore the surface of ${planet.name}. Experience the thrill of setting foot on another world and discover its unique features.';
      case MissionType.researchMission:
        return 'A scientific mission to study the environment and composition of ${planet.name}. Contribute to our understanding of the solar system while conducting experiments.';
      case MissionType.colonizationProject:
        return 'Join the pioneering effort to establish a permanent human presence on ${planet.name}. Help build the foundation for future generations of space settlers.';
      case MissionType.luxuryCruise:
        return 'Indulge in the ultimate space vacation with our luxury cruise to ${planet.name}. Enjoy premium accommodations, gourmet meals, and breathtaking views.';
      case MissionType.orbitalTour:
        return 'Experience the beauty of ${planet.name} from orbit. Our tour provides spectacular views and photography opportunities without landing on the surface.';
      case MissionType.miningOperation:
        return "Participate in a resource extraction mission to ${planet.name}. Help harvest valuable minerals and contribute to Earth's growing need for rare materials.";
    }
  }
  
  List<String> _getIncludedActivities() {
    final List<String> baseActivities = [
      'Space travel to and from ${planet.name}',
      'Accommodation and meals during the journey',
      'Basic training and safety briefing',
    ];
    
    List<String> specificActivities = [];
    
    switch (_selectedMissionType) {
      case MissionType.surfaceExpedition:
        specificActivities = [
          'Surface exploration equipment',
          'Guided tours of key landmarks',
          'Sample collection opportunities',
        ];
        break;
      case MissionType.researchMission:
        specificActivities = [
          'Access to research facilities',
          'Scientific equipment usage',
          'Data analysis workshops',
        ];
        break;
      case MissionType.colonizationProject:
        specificActivities = [
          'Habitat construction training',
          'Agricultural system setup',
          'Community development planning',
        ];
        break;
      case MissionType.luxuryCruise:
        specificActivities = [
          'Premium suite accommodations',
          'Gourmet dining experience',
          'Entertainment and leisure activities',
        ];
        break;
      case MissionType.orbitalTour:
        specificActivities = [
          'Orbital photography sessions',
          'Guided viewing of landmarks from space',
          'Zero-gravity recreation',
        ];
        break;
      case MissionType.miningOperation:
        specificActivities = [
          'Resource extraction training',
          'Mining equipment operation',
          'Mineral identification workshops',
        ];
        break;
    }
    
    return [...baseActivities, ...specificActivities];
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _departureDate,
      firstDate: DateTime.now().add(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Colors.white,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[850],
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _departureDate) {
      setState(() {
        _departureDate = picked;
      });
      
      // Play sound effect
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(SoundEffect.buttonClick);
      
      // Trigger haptic feedback
      HapticService().feedback(HapticFeedbackType.selection);
    }
  }

  void _bookMission() async {
    if (_formKey.currentState!.validate()) {
      // Get providers
      final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      
      setState(() {
        _isBookingInProgress = true;
      });
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Generate unique ID
      final id = '${planet.id}-${DateTime.now().millisecondsSinceEpoch}';
      
      // Create new mission
      final newMission = Mission(
        id: id,
        name: _getMissionName(),
        planetId: planet.id,
        planetName: planet.name,
        type: _selectedMissionType,
        departureDate: _departureDate,
        estimatedReturnDate: _departureDate.add(Duration(days: _getMissionDuration(planet))),
        durationInDays: _getMissionDuration(planet),
        price: _calculatePrice(),
        maxPassengers: _passengerCount,
        currentPassengers: 0,
        status: MissionStatus.scheduled,
        completionPercentage: 0.0,
        description: _getMissionDescription(),
        includedActivities: _getIncludedActivities(),
        requirements: [
          'Basic space training',
          'Signed liability waiver',
        ],
        captainName: 'Capt. ${_captainController.text}',
        spaceshipModel: _spaceshipController.text,
        spaceshipImagePath: 'assets/images/ships/default_ship.png',
      );
      
      // Book mission using provider
      await missionsProvider.bookMission(newMission.id);
      
      // Play success sound
      audioProvider.playSoundEffect(SoundEffect.success);
      
      // Trigger success haptic feedback
      HapticService().feedback(HapticFeedbackType.success);
      
      // Start animation
      _animationController.forward();
      
      setState(() {
        _isBookingInProgress = false;
        _isBookingComplete = true;
      });
      
      // Navigate to mission progress after animation completes
      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.go('${AppRoutes.home}/mission/${newMission.id}');
        }
      });
    }
  }

  double _calculatePrice() {
    // Base price depends on mission type
    double basePrice = 0;
    switch (_selectedMissionType) {
      case MissionType.surfaceExpedition:
        basePrice = 5000000;
        break;
      case MissionType.researchMission:
        basePrice = 7500000;
        break;
      case MissionType.colonizationProject:
        basePrice = 10000000;
        break;
      case MissionType.luxuryCruise:
        basePrice = 2500000;
        break;
      case MissionType.orbitalTour:
        basePrice = 2000000;
        break;
      case MissionType.miningOperation:
        basePrice = 8000000;
        break;
    }
    
    // Adjust for planet difficulty
    final planet = Provider.of<PlanetsProvider>(context, listen: false).selectedPlanet!;
    final difficultyMultiplier = 1 + (planet.explorationDifficulty / 10);
    
    // Adjust for passenger count
    final passengerMultiplier = 1 + (_passengerCount - 1) * 0.5;
    
    // Adjust for spaceship
    final selectedShip = _spaceships.firstWhere(
      (ship) => ship['id'] == _selectedSpaceship,
    );
    double shipMultiplier = 1.0;
    if (selectedShip['comfort'] == 'Luxury') {
      shipMultiplier = 1.5;
    } else if (selectedShip['comfort'] == 'Economy') {
      shipMultiplier = 0.8;
    }
    
    return basePrice * difficultyMultiplier * passengerMultiplier * shipMultiplier;
  }

  int _getMissionDuration(Planet planet) {
    // Duration depends on planet distance and mission type
    int baseDays = 0;
    
    // Use the distance value directly since it's already a double
    final numericDistance = planet.distanceFromEarth;
    
    // For simplicity, we'll assume the distance is in AU (astronomical units)
    // and convert it to a reasonable scale for our mission duration
    double unitMultiplier = 10; // Scale factor to convert AU to travel days
    
    // Calculate base days based on distance
    baseDays = (numericDistance * unitMultiplier / 10).round();
    
    // Adjust for mission type
    switch (_selectedMissionType) {
      case MissionType.surfaceExpedition:
        baseDays = (baseDays * 1.2).round();
        break;
      case MissionType.researchMission:
        baseDays = (baseDays * 1.5).round();
        break;
      case MissionType.colonizationProject:
        baseDays = (baseDays * 2.0).round();
        break;
      case MissionType.luxuryCruise:
        baseDays = (baseDays * 0.8).round();
        break;
      case MissionType.orbitalTour:
        baseDays = (baseDays * 0.7).round();
        break;
      case MissionType.miningOperation:
        baseDays = (baseDays * 1.8).round();
        break;
    }
    
    // Ensure minimum duration
    baseDays = baseDays < 7 ? 7 : baseDays;
    
    return baseDays;
  }
  
  String _formatMissionDuration(int days) {
    // Format duration
    if (days > 365) {
      final years = (days / 365).floor();
      final remainingDays = days % 365;
      return '$years ${years == 1 ? 'year' : 'years'} ${remainingDays > 0 ? ', $remainingDays days' : ''}';
    } else if (days > 30) {
      final months = (days / 30).floor();
      final remainingDays = days % 30;
      return '$months ${months == 1 ? 'month' : 'months'} ${remainingDays > 0 ? ', $remainingDays days' : ''}';
    } else {
      return '$days days';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final planetsProvider = Provider.of<PlanetsProvider>(context);
    final planet = planetsProvider.selectedPlanet;
    
    if (planet == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          StarFieldBackground(
            starCount: 150,
            starColor: Colors.white,
            backgroundColor: Colors.black,
          ),
          
          // Main content
          SafeArea(
            child: _isBookingComplete
                ? _buildBookingComplete(planet)
                : _buildBookingForm(theme, planet),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm(ThemeData theme, Planet planet) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                SpaceIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => context.go('${AppRoutes.home}/${AppRoutes.planetDetail}/${planet.id}'),
                  soundEffect: SoundEffect.buttonClick,
                  hapticFeedback: HapticFeedbackType.light,
                ),
                const SizedBox(width: 16),
                Text(
                  'BOOK A MISSION',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Planet info
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              blur: 10,
              opacity: 0.15,
              child: Row(
                children: [
                  // Planet image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: theme.colorScheme.primary,
                      child: Center(
                        child: Icon(
                          Icons.public,
                          size: 50,
                          color: Color.fromARGB(
                            255,
                            100 + (planet.name.length * 20) % 155,
                            150 + (planet.name.length * 15) % 105,
                            200 + (planet.name.length * 10) % 55,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Planet details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planet.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Distance: ${planet.distanceFromEarth}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Difficulty: ${planet.explorationDifficulty}/10',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getDifficultyColor(planet.explorationDifficulty),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Mission type
            _buildSectionTitle('MISSION TYPE', Icons.category),
            const SizedBox(height: 8),
            _buildMissionTypeSelector(),
            
            const SizedBox(height: 24),
            
            // Departure date
            _buildSectionTitle('DEPARTURE DATE', Icons.calendar_today),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showDatePicker,
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                borderRadius: 12,
                blur: 10,
                opacity: 0.15,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(_departureDate),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Passenger count
            _buildSectionTitle('PASSENGERS', Icons.people),
            const SizedBox(height: 8),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 12,
              blur: 10,
              opacity: 0.15,
              child: Row(
                children: [
                  Text(
                    'Number of passengers',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  SpaceIconButton(
                    icon: Icons.remove,
                    onPressed: _passengerCount > 1
                        ? () {
                            setState(() {
                              _passengerCount--;
                            });
                            // Play sound effect
                            final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                            audioProvider.playSoundEffect(SoundEffect.buttonClick);
                            
                            // Trigger haptic feedback
                            HapticService().feedback(HapticFeedbackType.light);
                          }
                        : null,
                    size: 36.0, // Small size
                    soundEffect: SoundEffect.buttonClick,
                    hapticFeedback: HapticFeedbackType.light,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _passengerCount.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SpaceIconButton(
                    icon: Icons.add,
                    onPressed: _passengerCount < 10
                        ? () {
                            setState(() {
                              _passengerCount++;
                            });
                            // Play sound effect
                            final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                            audioProvider.playSoundEffect(SoundEffect.buttonClick);
                            
                            // Trigger haptic feedback
                            HapticService().feedback(HapticFeedbackType.light);
                          }
                        : null,
                    size: 36.0, // Small size
                    soundEffect: SoundEffect.buttonClick,
                    hapticFeedback: HapticFeedbackType.light,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Spaceship selection
            _buildSectionTitle('SELECT SPACESHIP', Icons.rocket_launch),
            const SizedBox(height: 8),
            _buildSpaceshipSelector(),
            
            const SizedBox(height: 24),
            
            // Price summary
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              blur: 10,
              opacity: 0.15,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.3),
                  theme.colorScheme.secondary.withOpacity(0.3),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MISSION SUMMARY',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Mission Type', _selectedMissionType.toString().split('.').last),
                  _buildSummaryRow('Departure', DateFormat('MMMM dd, yyyy').format(_departureDate)),
                  _buildSummaryRow('Duration', _formatMissionDuration(_getMissionDuration(planet))),
                  _buildSummaryRow('Passengers', _passengerCount.toString()),
                  _buildSummaryRow(
                    'Spaceship',
                    _spaceships.firstWhere((ship) => ship['id'] == _selectedSpaceship)['name'],
                  ),
                  const Divider(color: Colors.white24, height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL PRICE',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(symbol: '₡', decimalDigits: 0).format(_calculatePrice()),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Book button
            Center(
              child: SpaceButton(
                text: 'CONFIRM BOOKING',
                icon: Icons.rocket_launch,
                onPressed: _bookMission,
                isLoading: _isBookingInProgress,
                width: 220,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                glowOnPressed: true,
                soundEffect: SoundEffect.buttonClick,
                hapticFeedback: HapticFeedbackType.medium,
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionTypeSelector() {
    final theme = Theme.of(context);
    
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMissionTypeCard(
          type: MissionType.surfaceExpedition,
          title: 'Exploration',
          icon: Icons.explore,
          description: 'Discover new territories',
        ),
        _buildMissionTypeCard(
          type: MissionType.researchMission,
          title: 'Research',
          icon: Icons.science,
          description: 'Scientific investigation',
        ),
        _buildMissionTypeCard(
          type: MissionType.colonizationProject,
          title: 'Colonization',
          icon: Icons.home,
          description: 'Establish new settlements',
        ),
        _buildMissionTypeCard(
          type: MissionType.luxuryCruise,
          title: 'Tourism',
          icon: Icons.photo_camera,
          description: 'Sightseeing adventure',
        ),
      ],
    );
  }

  Widget _buildMissionTypeCard({
    required MissionType type,
    required String title,
    required IconData icon,
    required String description,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedMissionType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMissionType = type;
        });
        
        // Play sound effect
        final audioProvider = Provider.of<AudioProvider>(context, listen: false);
        audioProvider.playSoundEffect(SoundEffect.buttonClick);
        
        // Trigger haptic feedback
        HapticService().feedback(HapticFeedbackType.selection);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.secondary
                : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? theme.colorScheme.secondary.withOpacity(0.2)
              : Colors.black.withOpacity(0.3),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.secondary
                    : Colors.white.withOpacity(0.7),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isSelected ? theme.colorScheme.secondary : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpaceshipSelector() {
    return Column(
      children: _spaceships.map((ship) => _buildSpaceshipCard(ship)).toList(),
    );
  }

  Widget _buildSpaceshipCard(Map<String, dynamic> ship) {
    final theme = Theme.of(context);
    final isSelected = _selectedSpaceship == ship['id'];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpaceship = ship['id'];
        });
        
        // Play sound effect
        final audioProvider = Provider.of<AudioProvider>(context, listen: false);
        audioProvider.playSoundEffect(SoundEffect.buttonClick);
        
        // Trigger haptic feedback
        HapticService().feedback(HapticFeedbackType.selection);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.secondary
                : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? theme.colorScheme.secondary.withOpacity(0.2)
              : Colors.black.withOpacity(0.3),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Spaceship image placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.rocket,
                    color: isSelected
                        ? theme.colorScheme.secondary
                        : Colors.white.withOpacity(0.7),
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Spaceship details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ship['name'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isSelected ? theme.colorScheme.secondary : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildSpaceshipStat('Capacity', '${ship['capacity']} people', Icons.people),
                        const SizedBox(width: 16),
                        _buildSpaceshipStat('Speed', ship['speed'], Icons.speed),
                        const SizedBox(width: 16),
                        _buildSpaceshipStat('Comfort', ship['comfort'], Icons.star),
                      ],
                    ),
                  ],
                ),
              ),
              // Selection indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.secondary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpaceshipStat(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.7),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(double difficulty) {
    if (difficulty <= 3) return Colors.green;
    if (difficulty <= 6) return Colors.orange;
    return Colors.red;
  }

  Widget _buildBookingComplete(Planet planet) {
    final theme = Theme.of(context);
    final animationsProvider = Provider.of<AnimationsProvider>(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rocket launch animation
          SizedBox(
            height: 300,
            child: Lottie.asset(
              'assets/animations/rocket_launch.json',
              controller: _animationController,
              onLoaded: (composition) {
                _animationController.duration = composition.duration;
              },
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Success message
          Text(
            'MISSION BOOKED!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
          ).animate()
            .fadeIn(duration: 500.ms)
            .scale(duration: 500.ms),
          
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your mission to ${planet.name} has been successfully booked. Preparing for launch...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate()
            .fadeIn(delay: 300.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
