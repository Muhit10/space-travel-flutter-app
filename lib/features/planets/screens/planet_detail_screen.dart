import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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

class PlanetDetailScreen extends StatefulWidget {
  final String planetId;
  
  const PlanetDetailScreen({Key? key, required this.planetId}) : super(key: key);

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
    
    // Load planet data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final planetsProvider = Provider.of<PlanetsProvider>(context, listen: false);
      final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
      
      if (planetsProvider.selectedPlanet?.id != widget.planetId) {
        planetsProvider.selectPlanet(widget.planetId);
      }
      
      // Load missions for this planet
      missionsProvider.setPlanetFilter(widget.planetId);
      
      // Play sound effect
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(SoundEffect.whoosh);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isExpanded = _scrollController.hasClients && 
        _scrollController.offset > (200 - kToolbarHeight);
    
    if (isExpanded != _isAppBarExpanded) {
      setState(() {
        _isAppBarExpanded = isExpanded;
      });
    }
  }

  void _navigateToBookMission() {
    final planet = Provider.of<PlanetsProvider>(context, listen: false).selectedPlanet;
    if (planet != null) {
      context.go('${AppRoutes.home}/planet/${planet.id}/book');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ParallaxStarField(
            starCount: 150,
            starColor: Colors.white,
            backgroundColor: Colors.black,
            parallaxFactor: 0.1,
          ),
          
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App bar with planet image
              _buildAppBar(planet),
              
              // Planet details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Planet name and description
                      _buildPlanetHeader(planet),
                      
                      const SizedBox(height: 24),
                      
                      // Planet stats cards
                      _buildPlanetStats(planet),
                      
                      const SizedBox(height: 24),
                      
                      // Tab bar
                      _buildTabBar(),
                      
                      const SizedBox(height: 16),
                      
                      // Tab content
                      SizedBox(
                        height: 300, // Fixed height for tab content
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Overview tab
                            _buildOverviewTab(planet),
                            
                            // Features tab
                            _buildFeaturesTab(planet),
                            
                            // Missions tab
                            _buildMissionsTab(planet),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 100), // Extra space at bottom for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Book mission button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: SpaceButton(
                text: 'BOOK A MISSION',
                icon: Icons.rocket_launch,
                onPressed: _navigateToBookMission,
                width: 220,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                glowOnPressed: true,
                soundEffect: SoundEffect.buttonClick,
                hapticFeedback: HapticFeedbackType.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Planet planet) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: SpaceIconButton(
        icon: Icons.arrow_back,
        onPressed: () => context.go(AppRoutes.home),
        soundEffect: SoundEffect.buttonClick,
        hapticFeedback: HapticFeedbackType.light,
      ),
      actions: [
        SpaceIconButton(
          icon: Icons.share,
          onPressed: () {
            // Play sound effect
            final audioProvider = Provider.of<AudioProvider>(context, listen: false);
            audioProvider.playSoundEffect(SoundEffect.buttonClick);
            
            // Trigger haptic feedback
            HapticService().feedback(HapticFeedbackType.light);
            
            // Show share dialog (not implemented)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Share functionality coming soon!')),
            );
          },
          soundEffect: SoundEffect.buttonClick,
          hapticFeedback: HapticFeedbackType.light,
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: _isAppBarExpanded
            ? Text(
                planet.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Planet image with hero animation
            Hero(
              tag: 'planet_image_${planet.id}',
              child: Stack(
                children: [
                  // Planet image
                  planet.imagePath.toLowerCase().endsWith('.svg')
                      ? SvgPicture.asset(
                          planet.imagePath,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Container(
                          child: Icon(
                            Icons.public,
                            size: 200,
                            color: Color.fromARGB(
                              255,
                              100 + (planet.imagePath.hashCode % 155),
                              150 + (planet.imagePath.hashCode % 105),
                              200 + (planet.imagePath.hashCode % 55),
                            ),
                          ),
                        ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Exploration status badge
            if (planet.isExplored)
              Positioned(
                top: 16,
                right: 16,
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  borderRadius: 16,
                  blur: 10,
                  opacity: 0.2,
                  border: Border.all(
                    color: Colors.green.withOpacity(0.7),
                    width: 1,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'EXPLORED',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
                Positioned(
                  top: 16,
                  right: 16,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    borderRadius: 16,
                    blur: 10,
                    opacity: 0.2,
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.7),
                      width: 1,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.explore,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'UNEXPLORED',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanetHeader(Planet planet) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Planet name
        Text(
          planet.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate()
          .fadeIn(duration: 500.ms)
          .slideX(begin: -0.1, end: 0, duration: 500.ms),
        
        const SizedBox(height: 8),
        
        // Galaxy location
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: theme.colorScheme.secondary,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              planet.galaxyLocation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ).animate()
          .fadeIn(delay: 200.ms, duration: 500.ms)
          .slideX(begin: -0.1, end: 0, delay: 200.ms, duration: 500.ms),
        
        const SizedBox(height: 16),
        
        // Planet description
        Text(
          planet.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ).animate()
          .fadeIn(delay: 400.ms, duration: 500.ms)
          .slideY(begin: 0.1, end: 0, delay: 400.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildPlanetStats(Planet planet) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'DISTANCE',
          value: planet.distanceFromEarth,
          icon: Icons.route,
          delay: 0,
        ),
        _buildStatCard(
          title: 'DIAMETER',
          value: planet.diameter,
          icon: Icons.circle_outlined,
          delay: 100,
        ),
        _buildStatCard(
          title: 'GRAVITY',
          value: planet.gravity,
          icon: Icons.fitness_center,
          delay: 200,
        ),
        _buildStatCard(
          title: 'TEMPERATURE',
          value: planet.temperature,
          icon: Icons.thermostat,
          delay: 300,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required dynamic value,
    required IconData icon,
    required int delay,
  }) {
    final theme = Theme.of(context);
    
    return GlassCard(
      borderRadius: 16,
      blur: 10,
      opacity: 0.15,
      border: Border.all(
        color: theme.colorScheme.primary.withOpacity(0.5),
        width: 1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value is String ? value : value.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: delay.ms, duration: 500.ms)
      .scale(delay: delay.ms, duration: 500.ms, begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);
    
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'OVERVIEW'),
        Tab(text: 'FEATURES'),
        Tab(text: 'MISSIONS'),
      ],
      indicatorColor: theme.colorScheme.secondary,
      indicatorWeight: 3,
      labelStyle: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      unselectedLabelStyle: theme.textTheme.titleSmall,
      labelColor: theme.colorScheme.secondary,
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      onTap: (index) {
        // Play sound effect
        final audioProvider = Provider.of<AudioProvider>(context, listen: false);
        audioProvider.playSoundEffect(SoundEffect.swipe);
        
        // Trigger haptic feedback
        HapticService().feedback(HapticFeedbackType.selection);
      },
    );
  }

  Widget _buildOverviewTab(Planet planet) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discovery information
          _buildInfoSection(
            title: 'DISCOVERY',
            content: 'Discovered in ${planet.discoveryYear}',
            icon: Icons.history,
          ),
          
          const SizedBox(height: 16),
          
          // Atmosphere composition
          _buildInfoSection(
            title: 'ATMOSPHERE',
            content: planet.atmosphereComposition,
            icon: Icons.cloud,
          ),
          
          const SizedBox(height: 16),
          
          // Exploration difficulty
          _buildInfoSection(
            title: 'EXPLORATION DIFFICULTY',
            content: 'Level ${planet.explorationDifficulty.toInt()} / 10',
            icon: Icons.warning,
            customContent: LinearProgressIndicator(
              value: planet.explorationDifficulty / 10,
              backgroundColor: Colors.white.withOpacity(0.2),
              color: _getDifficultyColor(planet.explorationDifficulty),
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

  Widget _buildFeaturesTab(Planet planet) {
    final theme = Theme.of(context);
    
    return ListView.builder(
      itemCount: planet.features.length,
      itemBuilder: (context, index) {
        final feature = planet.features[index];
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          borderRadius: 12,
          blur: 10,
          opacity: 0.15,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  feature,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ).animate()
          .fadeIn(delay: (50 * index).ms, duration: 300.ms)
          .slideX(begin: 0.05, end: 0, delay: (50 * index).ms, duration: 300.ms);
      },
    );
  }

  Widget _buildMissionsTab(Planet planet) {
    final theme = Theme.of(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final missions = missionsProvider.getMissionsByPlanetId(planet.id);
    
    if (missions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              size: 48,
              color: theme.colorScheme.secondary.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'No missions available',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for upcoming missions to this planet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final mission = missions[index];
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          borderRadius: 12,
          blur: 10,
          opacity: 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission name and type
              Row(
                children: [
                  Icon(
                    mission.getTypeIcon(),
                    color: theme.colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    mission.type.toString().split('.').last.toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: mission.getStatusColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mission.status.toString().split('.').last.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: mission.getStatusColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Mission name
              Text(
                mission.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Mission details
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Departure: ${mission.formattedDepartureDate}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.attach_money,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mission.formattedPrice,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate()
          .fadeIn(delay: (50 * index).ms, duration: 300.ms)
          .slideX(begin: 0.05, end: 0, delay: (50 * index).ms, duration: 300.ms);
      },
    );
  }

  String _formatAtmosphereComposition(Map composition) {
    return composition.entries
        .map((entry) => "${entry.key}: ${entry.value}")
        .join('\n');
  }

  Widget _buildInfoSection({
    required String title,
    required dynamic content,
    required IconData icon,
    Widget? customContent,
  }) {
    final theme = Theme.of(context);
    
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 12,
      blur: 10,
      opacity: 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          customContent ?? Text(
            content is Map ? _formatAtmosphereComposition(content) : 
            content is String ? content : content.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}