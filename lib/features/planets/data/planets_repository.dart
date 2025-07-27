import 'package:random_01_space_travel/features/planets/models/planet_model.dart';

class PlanetsRepository {
  // Singleton pattern
  static final PlanetsRepository _instance = PlanetsRepository._internal();
  
  factory PlanetsRepository() {
    return _instance;
  }
  
  PlanetsRepository._internal();
  
  // Get all planets
  List<Planet> getAllPlanets() {
    return _planets;
  }
  
  // Get planet by id
  Planet? getPlanetById(String id) {
    try {
      return _planets.firstWhere((planet) => planet.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get planets by exploration status
  List<Planet> getPlanetsByExplorationStatus(bool isExplored) {
    return _planets.where((planet) => planet.isExplored == isExplored).toList();
  }
  
  // Get planets by difficulty range
  List<Planet> getPlanetsByDifficultyRange(double min, double max) {
    return _planets
        .where((planet) =>
            planet.explorationDifficulty >= min &&
            planet.explorationDifficulty <= max)
        .toList();
  }
  
  // Sample planets data
  final List<Planet> _planets = [
    Planet(
      id: 'mercury',
      name: 'Mercury',
      description:
          'The smallest and innermost planet in the Solar System. Its orbit around the Sun takes 87.97 Earth days, the shortest of all the planets.',
      imagePath: 'assets/images/mercury.svg',
      distanceFromEarth: 0.61,
      diameter: 4879,
      gravity: 0.38,
      temperature: 167,
      features: [
        'Extreme temperature variations',
        'Heavily cratered surface',
        'No atmosphere',
        'No moons',
      ],
      isExplored: true,
      explorationDifficulty: 7.5,
      availableMissions: [
        'Orbital Tour',
        'Research Mission',
        'Mining Operation',
      ],
      atmosphereComposition: {
        'oxygen': 0.0,
        'hydrogen': 0.0,
        'helium': 0.0,
        'sodium': 0.0,
      },
      discoveryYear: -3000, // Ancient civilization
      galaxyLocation: 'Inner Solar System',
    ),
    Planet(
      id: 'venus',
      name: 'Venus',
      description:
          'The second planet from the Sun. It is named after the Roman goddess of love and beauty. As the brightest natural object in Earth\'s night sky after the Moon, Venus can cast shadows and can be visible to the naked eye in broad daylight.',
      imagePath: 'assets/images/venus.svg',
      distanceFromEarth: 0.28,
      diameter: 12104,
      gravity: 0.91,
      temperature: 464,
      features: [
        'Toxic atmosphere',
        'Volcanic activity',
        'Greenhouse effect',
        'Retrograde rotation',
      ],
      isExplored: true,
      explorationDifficulty: 9.0,
      availableMissions: [
        'Orbital Tour',
        'Research Mission',
      ],
      atmosphereComposition: {
        'carbon dioxide': 96.5,
        'nitrogen': 3.5,
        'sulfur dioxide': 0.015,
        'water vapor': 0.002,
      },
      discoveryYear: -3000, // Ancient civilization
      galaxyLocation: 'Inner Solar System',
    ),
    Planet(
      id: 'earth',
      name: 'Earth',
      description:
          'Our home planet and the only known celestial body to harbor life. Earth is the third planet from the Sun and the only astronomical object known to harbor life.',
      imagePath: 'assets/images/earth.svg',
      distanceFromEarth: 0.0,
      diameter: 12742,
      gravity: 1.0,
      temperature: 15,
      features: [
        'Abundant liquid water',
        'Oxygen-rich atmosphere',
        'Diverse ecosystems',
        'Magnetic field',
      ],
      isExplored: true,
      explorationDifficulty: 1.0,
      availableMissions: [
        'Orbital Tour',
        'Surface Expedition',
        'Research Mission',
        'Luxury Cruise',
      ],
      atmosphereComposition: {
        'nitrogen': 78.0,
        'oxygen': 21.0,
        'argon': 0.9,
        'carbon dioxide': 0.04,
      },
      discoveryYear: -3000, // Ancient civilization
      galaxyLocation: 'Inner Solar System',
    ),
    Planet(
      id: 'mars',
      name: 'Mars',
      description:
          'The fourth planet from the Sun and the second-smallest planet in the Solar System, being larger than only Mercury. Mars is often referred to as the "Red Planet".',
      imagePath: 'assets/images/mars.svg',
      distanceFromEarth: 0.52,
      diameter: 6779,
      gravity: 0.38,
      temperature: -65,
      features: [
        'Red surface',
        'Polar ice caps',
        'Largest volcano in the solar system',
        'Ancient river valleys',
      ],
      isExplored: true,
      explorationDifficulty: 6.0,
      availableMissions: [
        'Orbital Tour',
        'Surface Expedition',
        'Research Mission',
        'Colonization Project',
      ],
      atmosphereComposition: {
        'carbon dioxide': 95.3,
        'nitrogen': 2.7,
        'argon': 1.6,
        'oxygen': 0.13,
      },
      discoveryYear: -3000, // Ancient civilization
      galaxyLocation: 'Inner Solar System',
    ),
    Planet(
      id: 'jupiter',
      name: 'Jupiter',
      description:
          'The largest planet in the Solar System. It is a gas giant with a mass more than two and a half times that of all the other planets in the Solar System combined, but slightly less than one-thousandth the mass of the Sun.',
      imagePath: 'assets/images/jupiter.svg',
      distanceFromEarth: 4.2,
      diameter: 139820,
      gravity: 2.53,
      temperature: -110,
      features: [
        'Great Red Spot',
        'Strong magnetic field',
        'Numerous moons',
        'Faint ring system',
      ],
      isExplored: true,
      explorationDifficulty: 8.0,
      availableMissions: [
        'Orbital Tour',
        'Research Mission',
      ],
      atmosphereComposition: {
        'hydrogen': 89.8,
        'helium': 10.2,
        'methane': 0.3,
        'ammonia': 0.026,
      },
      discoveryYear: -3000, // Ancient civilization
      galaxyLocation: 'Outer Solar System',
    ),
    Planet(
      id: 'saturn',
      name: 'Saturn',
      description:
          'The sixth planet from the Sun and the second-largest in the Solar System, after Jupiter. It is a gas giant with an average radius of about nine and a half times that of Earth. It has only one-eighth the average density of Earth.',
      imagePath: 'assets/images/planet_5.svg',
      distanceFromEarth: 8.52,
      diameter: 116460,
      gravity: 1.07,
      temperature: -140,
      features: [
        'Prominent ring system',
        'Hexagonal cloud pattern at north pole',
        'Many moons including Titan',
        'Low density (would float in water)',
      ],
      isExplored: true,
      explorationDifficulty: 8.5,
      availableMissions: [
        'Orbital Tour',
        'Research Mission',
        'Luxury Cruise',
      ],
      atmosphereComposition: {
        'hydrogen': 96.3,
        'helium': 3.25,
        'methane': 0.45,
        'ammonia': 0.0125,
      },
      discoveryYear: -3000, // Ancient civilization
      galaxyLocation: 'Outer Solar System',
    ),
    Planet(
      id: 'uranus',
      name: 'Uranus',
      description:
          'The seventh planet from the Sun. It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System. Uranus is similar in composition to Neptune, and both have bulk chemical compositions which differ from that of the larger gas giants Jupiter and Saturn.',
      imagePath: 'assets/images/planet_2.svg',
      distanceFromEarth: 18.21,
      diameter: 50724,
      gravity: 0.89,
      temperature: -195,
      features: [
        'Blue-green color due to methane',
        'Rotates on its side',
        'Faint ring system',
        'Extreme seasons',
      ],
      isExplored: true,
      explorationDifficulty: 9.0,
      availableMissions: [
        'Orbital Tour',
        'Research Mission',
      ],
      atmosphereComposition: {
        'hydrogen': 82.5,
        'helium': 15.2,
        'methane': 2.3,
        'hydrogen deuteride': 0.009,
      },
      discoveryYear: 1781,
      galaxyLocation: 'Outer Solar System',
    ),
    Planet(
      id: 'neptune',
      name: 'Neptune',
      description:
          'The eighth and farthest-known Solar planet from the Sun. In the Solar System, it is the fourth-largest planet by diameter, the third-most-massive planet, and the densest giant planet.',
      imagePath: 'assets/images/planet_3.svg',
      distanceFromEarth: 29.09,
      diameter: 49244,
      gravity: 1.14,
      temperature: -200,
      features: [
        'Deep blue color',
        'Great Dark Spot',
        'Strongest winds in the solar system',
        'Faint ring system',
      ],
      isExplored: true,
      explorationDifficulty: 9.5,
      availableMissions: [
        'Orbital Tour',
        'Research Mission',
      ],
      atmosphereComposition: {
        'hydrogen': 80.0,
        'helium': 19.0,
        'methane': 1.5,
        'hydrogen deuteride': 0.019,
      },
      discoveryYear: 1846,
      galaxyLocation: 'Outer Solar System',
    ),
    Planet(
      id: 'kepler-186f',
      name: 'Kepler-186f',
      description:
          'The first Earth-sized exoplanet discovered in the habitable zone. It orbits the red dwarf Kepler-186, about 582 light-years from Earth.',
      imagePath: 'assets/images/planet_1.svg',
      distanceFromEarth: 582,
      diameter: 13594, // Estimated
      gravity: 1.44, // Estimated
      temperature: 0, // Estimated average
      features: [
        'Potentially habitable',
        'Rocky composition',
        'Orbits a red dwarf star',
        'Year length of 130 Earth days',
      ],
      isExplored: false,
      explorationDifficulty: 10.0,
      availableMissions: [
        'Research Mission',
      ],
      atmosphereComposition: {
        'unknown': 100.0,
      },
      discoveryYear: 2014,
      galaxyLocation: 'Cygnus Constellation',
    ),
    Planet(
      id: 'trappist-1e',
      name: 'TRAPPIST-1e',
      description:
          'An exoplanet orbiting within the habitable zone of the ultra-cool dwarf star TRAPPIST-1, located 39.6 light-years from Earth. It is one of seven planets in the TRAPPIST-1 system.',
      imagePath: 'assets/images/planet_2.svg',
      distanceFromEarth: 39.6,
      diameter: 9200, // Estimated
      gravity: 0.92, // Estimated
      temperature: 25, // Estimated average
      features: [
        'Potentially habitable',
        'Tidally locked to its star',
        'Possible liquid water',
        'Year length of 6.1 Earth days',
      ],
      isExplored: false,
      explorationDifficulty: 9.8,
      availableMissions: [
        'Research Mission',
        'Colonization Project',
      ],
      atmosphereComposition: {
        'unknown': 100.0,
      },
      discoveryYear: 2017,
      galaxyLocation: 'Aquarius Constellation',
    ),
    Planet(
      id: 'proxima-centauri-b',
      name: 'Proxima Centauri b',
      description:
          'An exoplanet orbiting within the habitable zone of the red dwarf star Proxima Centauri, the closest star to the Sun and part of the Alpha Centauri system.',
      imagePath: 'assets/images/planet_3.svg',
      distanceFromEarth: 4.2,
      diameter: 13000, // Estimated
      gravity: 1.27, // Estimated
      temperature: 10, // Estimated average
      features: [
        'Closest known exoplanet to Earth',
        'Potentially habitable',
        'Tidally locked to its star',
        'Year length of 11.2 Earth days',
      ],
      isExplored: false,
      explorationDifficulty: 9.2,
      availableMissions: [
        'Research Mission',
        'Colonization Project',
      ],
      atmosphereComposition: {
        'unknown': 100.0,
      },
      discoveryYear: 2016,
      galaxyLocation: 'Alpha Centauri System',
    ),
    Planet(
      id: 'hd-209458-b',
      name: 'HD 209458 b',
      description:
          'Also known as Osiris, it was the first exoplanet to have its atmosphere detected and characterized. It is a hot Jupiter that orbits very close to its star.',
      imagePath: 'assets/images/planet_5.svg',
      distanceFromEarth: 159,
      diameter: 154000, // Estimated
      gravity: 9.3, // Estimated
      temperature: 1200, // Estimated average
      features: [
        'Hot Jupiter type planet',
        'Evaporating atmosphere',
        'Orbits very close to its star',
        'Year length of 3.5 Earth days',
      ],
      isExplored: false,
      explorationDifficulty: 9.7,
      availableMissions: [
        'Research Mission',
      ],
      atmosphereComposition: {
        'hydrogen': 90.0,
        'helium': 9.0,
        'sodium': 0.5,
        'water vapor': 0.5,
      },
      discoveryYear: 1999,
      galaxyLocation: 'Pegasus Constellation',
    ),
  ];
}