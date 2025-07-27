class Planet {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double distanceFromEarth; // in light years or AU
  final double diameter; // in km
  final double gravity; // relative to Earth (Earth = 1.0)
  final double temperature; // in Celsius
  final List<String> features;
  final bool isExplored;
  final double explorationDifficulty; // 1-10 scale
  final List<String> availableMissions;
  final Map<String, dynamic> atmosphereComposition;
  final int discoveryYear;
  final String galaxyLocation;
  
  const Planet({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.distanceFromEarth,
    required this.diameter,
    required this.gravity,
    required this.temperature,
    required this.features,
    required this.isExplored,
    required this.explorationDifficulty,
    required this.availableMissions,
    required this.atmosphereComposition,
    required this.discoveryYear,
    required this.galaxyLocation,
  });
  
  // Factory constructor to create a Planet from JSON
  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      distanceFromEarth: json['distanceFromEarth'] as double,
      diameter: json['diameter'] as double,
      gravity: json['gravity'] as double,
      temperature: json['temperature'] as double,
      features: List<String>.from(json['features'] as List),
      isExplored: json['isExplored'] as bool,
      explorationDifficulty: json['explorationDifficulty'] as double,
      availableMissions: List<String>.from(json['availableMissions'] as List),
      atmosphereComposition: json['atmosphereComposition'] as Map<String, dynamic>,
      discoveryYear: json['discoveryYear'] as int,
      galaxyLocation: json['galaxyLocation'] as String,
    );
  }
  
  // Convert Planet to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'distanceFromEarth': distanceFromEarth,
      'diameter': diameter,
      'gravity': gravity,
      'temperature': temperature,
      'features': features,
      'isExplored': isExplored,
      'explorationDifficulty': explorationDifficulty,
      'availableMissions': availableMissions,
      'atmosphereComposition': atmosphereComposition,
      'discoveryYear': discoveryYear,
      'galaxyLocation': galaxyLocation,
    };
  }
  
  // Create a copy of Planet with some properties changed
  Planet copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    double? distanceFromEarth,
    double? diameter,
    double? gravity,
    double? temperature,
    List<String>? features,
    bool? isExplored,
    double? explorationDifficulty,
    List<String>? availableMissions,
    Map<String, dynamic>? atmosphereComposition,
    int? discoveryYear,
    String? galaxyLocation,
  }) {
    return Planet(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      distanceFromEarth: distanceFromEarth ?? this.distanceFromEarth,
      diameter: diameter ?? this.diameter,
      gravity: gravity ?? this.gravity,
      temperature: temperature ?? this.temperature,
      features: features ?? this.features,
      isExplored: isExplored ?? this.isExplored,
      explorationDifficulty: explorationDifficulty ?? this.explorationDifficulty,
      availableMissions: availableMissions ?? this.availableMissions,
      atmosphereComposition: atmosphereComposition ?? this.atmosphereComposition,
      discoveryYear: discoveryYear ?? this.discoveryYear,
      galaxyLocation: galaxyLocation ?? this.galaxyLocation,
    );
  }
}