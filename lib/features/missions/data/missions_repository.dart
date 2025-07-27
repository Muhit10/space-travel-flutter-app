import 'package:random_01_space_travel/features/missions/models/mission_model.dart';

class MissionsRepository {
  // Singleton pattern
  static final MissionsRepository _instance = MissionsRepository._internal();
  
  factory MissionsRepository() {
    return _instance;
  }
  
  MissionsRepository._internal();
  
  // Get all missions
  List<Mission> getAllMissions() {
    return _missions;
  }
  
  // Get mission by id
  Mission? getMissionById(String id) {
    try {
      return _missions.firstWhere((mission) => mission.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get missions by planet id
  List<Mission> getMissionsByPlanetId(String planetId) {
    return _missions.where((mission) => mission.planetId == planetId).toList();
  }
  
  // Get missions by status
  List<Mission> getMissionsByStatus(MissionStatus status) {
    return _missions.where((mission) => mission.status == status).toList();
  }
  
  // Get missions by type
  List<Mission> getMissionsByType(MissionType type) {
    return _missions.where((mission) => mission.type == type).toList();
  }
  
  // Get available missions (not fully booked)
  List<Mission> getAvailableMissions() {
    return _missions
        .where((mission) =>
            mission.currentPassengers < mission.maxPassengers &&
            mission.status == MissionStatus.scheduled)
        .toList();
  }
  
  // Sample missions data
  final List<Mission> _missions = [
    Mission(
      id: 'mars-expedition-2025',
      name: 'Mars Expedition 2025',
      planetId: 'mars',
      planetName: 'Mars',
      type: MissionType.surfaceExpedition,
      departureDate: DateTime(2025, 8, 15),
      estimatedReturnDate: DateTime(2025, 12, 20),
      durationInDays: 127,
      price: 25000000,
      maxPassengers: 8,
      currentPassengers: 5,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Join our flagship Mars expedition to explore the Valles Marineris canyon system. This mission includes surface exploration with state-of-the-art rovers and a visit to the historic landing sites of previous Mars missions.',
      includedActivities: [
        'Canyon hiking expedition',
        'Rover driving experience',
        'Sample collection',
        'Historic site visits',
        'Zero-G recreation',
      ],
      requirements: [
        'Advanced space training certification',
        'Medical clearance for extended space travel',
        'Minimum fitness level: Category B',
        'Psychological evaluation',
      ],
      captainName: 'Cmdr. Elena Rodriguez',
      spaceshipModel: 'Ares VII Explorer',
      spaceshipImagePath: 'assets/images/ships/ares_vii.png',
    ),
    Mission(
      id: 'lunar-orbit-2025',
      name: 'Lunar Orbit Experience',
      planetId: 'earth', // Moon is considered part of Earth system
      planetName: 'Earth\'s Moon',
      type: MissionType.orbitalTour,
      departureDate: DateTime(2025, 6, 10),
      estimatedReturnDate: DateTime(2025, 6, 17),
      durationInDays: 7,
      price: 1500000,
      maxPassengers: 12,
      currentPassengers: 8,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Experience the beauty of Earth\'s natural satellite up close with our premium lunar orbit tour. Circle the Moon and witness Earth-rise from lunar orbit, a sight few humans have ever seen.',
      includedActivities: [
        'Earth-rise viewing',
        'Lunar photography workshop',
        'Space gourmet dining',
        'Lunar geology lectures',
        'Zero-G recreation',
      ],
      requirements: [
        'Basic space training certification',
        'Medical clearance for space travel',
        'Minimum fitness level: Category C',
      ],
      captainName: 'Cmdr. James Chen',
      spaceshipModel: 'Artemis Luxury Orbiter',
      spaceshipImagePath: 'assets/images/ships/artemis_orbiter.png',
    ),
    Mission(
      id: 'jupiter-research-2026',
      name: 'Jupiter Atmospheric Research',
      planetId: 'jupiter',
      planetName: 'Jupiter',
      type: MissionType.researchMission,
      departureDate: DateTime(2026, 3, 20),
      estimatedReturnDate: DateTime(2026, 9, 15),
      durationInDays: 179,
      price: 35000000,
      maxPassengers: 6,
      currentPassengers: 4,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Join our scientific expedition to study Jupiter\'s complex atmospheric systems. This mission will deploy advanced probes into Jupiter\'s atmosphere to collect unprecedented data about the gas giant.',
      includedActivities: [
        'Atmospheric probe deployment',
        'Great Red Spot observation',
        'Scientific data analysis',
        'Io volcanic activity monitoring',
        'Europa flyby',
      ],
      requirements: [
        'PhD in relevant scientific field',
        'Advanced space training certification',
        'Medical clearance for extended space travel',
        'Minimum fitness level: Category B',
        'Previous zero-G research experience',
      ],
      captainName: 'Dr. Hiroshi Yamamoto',
      spaceshipModel: 'Galileo Research Vessel',
      spaceshipImagePath: 'assets/images/ships/galileo_vessel.png',
    ),
    Mission(
      id: 'saturn-rings-2025',
      name: 'Saturn Ring Expedition',
      planetId: 'saturn',
      planetName: 'Saturn',
      type: MissionType.luxuryCruise,
      departureDate: DateTime(2025, 11, 5),
      estimatedReturnDate: DateTime(2026, 2, 15),
      durationInDays: 102,
      price: 45000000,
      maxPassengers: 10,
      currentPassengers: 3,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Experience the ultimate luxury space cruise through Saturn\'s magnificent ring system. Witness the beauty of the gas giant and its rings from our observation deck while enjoying premium accommodations and services.',
      includedActivities: [
        'Ring particle collection',
        'Titan flyby',
        'Luxury space dining',
        'Enceladus geyser observation',
        'Hexagon storm viewing',
        'Space spa treatments',
      ],
      requirements: [
        'Basic space training certification',
        'Medical clearance for extended space travel',
        'Minimum fitness level: Category D',
        'Luxury package subscription',
      ],
      captainName: 'Cmdr. Sophia Blackwell',
      spaceshipModel: 'Cassini Luxury Liner',
      spaceshipImagePath: 'assets/images/ships/cassini_liner.png',
    ),
    Mission(
      id: 'venus-orbit-2025',
      name: 'Venus Orbital Study',
      planetId: 'venus',
      planetName: 'Venus',
      type: MissionType.researchMission,
      departureDate: DateTime(2025, 9, 30),
      estimatedReturnDate: DateTime(2026, 1, 15),
      durationInDays: 107,
      price: 28000000,
      maxPassengers: 6,
      currentPassengers: 6,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Join our scientific mission to study Venus\'s complex atmosphere and surface conditions. Deploy advanced probes to gather data about Earth\'s mysterious sister planet.',
      includedActivities: [
        'Atmospheric probe deployment',
        'Surface mapping',
        'Greenhouse effect studies',
        'Volcanic activity monitoring',
        'Scientific data analysis',
      ],
      requirements: [
        'PhD in relevant scientific field',
        'Advanced space training certification',
        'Medical clearance for extended space travel',
        'Minimum fitness level: Category B',
        'Previous experience with extreme environment research',
      ],
      captainName: 'Dr. Aisha Okafor',
      spaceshipModel: 'Magellan Research Vessel',
      spaceshipImagePath: 'assets/images/ships/magellan_vessel.png',
    ),
    Mission(
      id: 'proxima-centauri-2030',
      name: 'Proxima Centauri First Contact',
      planetId: 'proxima-centauri-b',
      planetName: 'Proxima Centauri b',
      type: MissionType.colonizationProject,
      departureDate: DateTime(2030, 1, 1),
      estimatedReturnDate: DateTime(2045, 1, 1),
      durationInDays: 5479,
      price: 500000000,
      maxPassengers: 20,
      currentPassengers: 0,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Be part of humanity\'s first mission to another star system. This groundbreaking colonization project will establish the first human outpost on Proxima Centauri b, the closest potentially habitable exoplanet to Earth.',
      includedActivities: [
        'Cryosleep journey',
        'First exoplanet landing',
        'Habitat construction',
        'Exobiology studies',
        'Resource extraction training',
        'Colony establishment',
      ],
      requirements: [
        'Elite space training certification',
        'Medical clearance for extended cryosleep',
        'Minimum fitness level: Category A+',
        'Psychological evaluation for long-term isolation',
        'Specialized skills in colony development',
        'No return guarantee acknowledgment',
      ],
      captainName: 'Adm. Marcus Zhang',
      spaceshipModel: 'Starshot Colony Vessel',
      spaceshipImagePath: 'assets/images/ships/starshot_vessel.png',
    ),
    Mission(
      id: 'mercury-mining-2025',
      name: 'Mercury Mining Operation',
      planetId: 'mercury',
      planetName: 'Mercury',
      type: MissionType.miningOperation,
      departureDate: DateTime(2025, 7, 10),
      estimatedReturnDate: DateTime(2025, 10, 20),
      durationInDays: 102,
      price: 18000000,
      maxPassengers: 15,
      currentPassengers: 12,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Join our profitable mining expedition to Mercury\'s resource-rich surface. Extract rare metals and minerals essential for advanced technology manufacturing while experiencing the extreme conditions of the closest planet to the Sun.',
      includedActivities: [
        'Resource extraction operations',
        'Heavy machinery operation',
        'Extreme temperature management',
        'Mineral processing',
        'Solar energy harvesting',
      ],
      requirements: [
        'Mining operation certification',
        'Advanced space training certification',
        'Medical clearance for extended space travel',
        'Minimum fitness level: Category A',
        'Experience with extreme environment operations',
      ],
      captainName: 'Cmdr. Viktor Petrov',
      spaceshipModel: 'Hermes Mining Vessel',
      spaceshipImagePath: 'assets/images/ships/hermes_vessel.png',
    ),
    Mission(
      id: 'mars-colony-2026',
      name: 'Mars Colony Expansion',
      planetId: 'mars',
      planetName: 'Mars',
      type: MissionType.colonizationProject,
      departureDate: DateTime(2026, 4, 15),
      estimatedReturnDate: DateTime(2028, 6, 20),
      durationInDays: 796,
      price: 75000000,
      maxPassengers: 30,
      currentPassengers: 18,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Be part of humanity\'s permanent presence on the Red Planet. This mission will expand the existing Mars colony with new habitats, greenhouses, and infrastructure. Long-term residency options available.',
      includedActivities: [
        'Habitat construction',
        'Greenhouse agriculture',
        'Water extraction operations',
        'Solar array deployment',
        'Martian geology exploration',
        'Colony life integration',
      ],
      requirements: [
        'Advanced space training certification',
        'Medical clearance for extended Mars habitation',
        'Minimum fitness level: Category B',
        'Psychological evaluation for long-term isolation',
        'Specialized skills in colony development',
      ],
      captainName: 'Cmdr. Sarah Nguyen',
      spaceshipModel: 'Olympus Colony Transport',
      spaceshipImagePath: 'assets/images/ships/olympus_transport.png',
    ),
    Mission(
      id: 'neptune-research-2027',
      name: 'Neptune Deep Atmosphere Study',
      planetId: 'neptune',
      planetName: 'Neptune',
      type: MissionType.researchMission,
      departureDate: DateTime(2027, 2, 10),
      estimatedReturnDate: DateTime(2028, 5, 15),
      durationInDays: 460,
      price: 42000000,
      maxPassengers: 5,
      currentPassengers: 2,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Join our pioneering scientific expedition to study Neptune\'s mysterious atmosphere and weather systems. Deploy advanced probes to gather data about the least-explored giant planet in our solar system.',
      includedActivities: [
        'Atmospheric probe deployment',
        'Great Dark Spot observation',
        'Storm system tracking',
        'Triton moon observation',
        'Scientific data analysis',
      ],
      requirements: [
        'PhD in relevant scientific field',
        'Elite space training certification',
        'Medical clearance for extended deep space travel',
        'Minimum fitness level: Category A',
        'Previous outer planet research experience',
      ],
      captainName: 'Dr. Liam O\'Connor',
      spaceshipModel: 'Voyager Research Vessel',
      spaceshipImagePath: 'assets/images/ships/voyager_vessel.png',
    ),
    Mission(
      id: 'earth-orbit-2025',
      name: 'Earth Orbital Experience',
      planetId: 'earth',
      planetName: 'Earth',
      type: MissionType.orbitalTour,
      departureDate: DateTime(2025, 5, 5),
      estimatedReturnDate: DateTime(2025, 5, 8),
      durationInDays: 3,
      price: 500000,
      maxPassengers: 20,
      currentPassengers: 15,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Experience the beauty of our home planet from orbit. This short mission provides the perfect introduction to space travel with breathtaking views of Earth from 400km above the surface.',
      includedActivities: [
        'Earth observation',
        'Space photography workshop',
        'Zero-G experience',
        'Space gourmet dining',
        'Sunrise/sunset viewing (16 per day)',
      ],
      requirements: [
        'Basic space training certification',
        'Medical clearance for space travel',
        'Minimum fitness level: Category D',
      ],
      captainName: 'Cmdr. Thomas Rivera',
      spaceshipModel: 'Aurora Orbital Shuttle',
      spaceshipImagePath: 'assets/images/ships/aurora_shuttle.png',
    ),
    Mission(
      id: 'trappist-research-2035',
      name: 'TRAPPIST-1e Habitability Study',
      planetId: 'trappist-1e',
      planetName: 'TRAPPIST-1e',
      type: MissionType.researchMission,
      departureDate: DateTime(2035, 6, 1),
      estimatedReturnDate: DateTime(2055, 6, 1),
      durationInDays: 7305,
      price: 750000000,
      maxPassengers: 8,
      currentPassengers: 0,
      status: MissionStatus.scheduled,
      completionPercentage: 0.0,
      description:
          'Join humanity\'s first mission to the TRAPPIST-1 system to study the most promising potentially habitable exoplanet discovered to date. This groundbreaking mission will determine if TRAPPIST-1e could support human colonization.',
      includedActivities: [
        'Cryosleep journey',
        'Exoplanet orbital study',
        'Atmospheric analysis',
        'Surface probe deployment',
        'Habitability assessment',
        'Potential landing site identification',
      ],
      requirements: [
        'PhD in relevant scientific field',
        'Elite space training certification',
        'Medical clearance for extended cryosleep',
        'Minimum fitness level: Category A+',
        'Psychological evaluation for extreme isolation',
        'No return guarantee acknowledgment',
      ],
      captainName: 'Dr. Fatima Al-Farsi',
      spaceshipModel: 'Hawking Deep Space Explorer',
      spaceshipImagePath: 'assets/images/ships/hawking_explorer.png',
    ),
  ];
}