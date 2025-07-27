import 'package:flutter/material.dart';

enum MissionStatus {
  scheduled,
  inProgress,
  completed,
  aborted,
  cancelled,
}

enum MissionType {
  orbitalTour,
  surfaceExpedition,
  researchMission,
  colonizationProject,
  miningOperation,
  luxuryCruise,
}

class Mission {
  final String id;
  final String name;
  final String planetId;
  final String planetName;
  final MissionType type;
  final DateTime departureDate;
  final DateTime estimatedReturnDate;
  final int durationInDays;
  final double price; // in space credits
  final int maxPassengers;
  final int currentPassengers;
  final MissionStatus status;
  final double completionPercentage; // 0.0 to 1.0
  final String description;
  final List<String> includedActivities;
  final List<String> requirements;
  final String captainName;
  final String spaceshipModel;
  final String spaceshipImagePath;
  
  const Mission({
    required this.id,
    required this.name,
    required this.planetId,
    required this.planetName,
    required this.type,
    required this.departureDate,
    required this.estimatedReturnDate,
    required this.durationInDays,
    required this.price,
    required this.maxPassengers,
    required this.currentPassengers,
    required this.status,
    required this.completionPercentage,
    required this.description,
    required this.includedActivities,
    required this.requirements,
    required this.captainName,
    required this.spaceshipModel,
    required this.spaceshipImagePath,
  });
  
  // Factory constructor to create a Mission from JSON
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] as String,
      name: json['name'] as String,
      planetId: json['planetId'] as String,
      planetName: json['planetName'] as String,
      type: MissionType.values.firstWhere(
        (e) => e.toString() == 'MissionType.${json['type']}',
        orElse: () => MissionType.orbitalTour,
      ),
      departureDate: DateTime.parse(json['departureDate'] as String),
      estimatedReturnDate: DateTime.parse(json['estimatedReturnDate'] as String),
      durationInDays: json['durationInDays'] as int,
      price: json['price'] as double,
      maxPassengers: json['maxPassengers'] as int,
      currentPassengers: json['currentPassengers'] as int,
      status: MissionStatus.values.firstWhere(
        (e) => e.toString() == 'MissionStatus.${json['status']}',
        orElse: () => MissionStatus.scheduled,
      ),
      completionPercentage: json['completionPercentage'] as double,
      description: json['description'] as String,
      includedActivities: List<String>.from(json['includedActivities'] as List),
      requirements: List<String>.from(json['requirements'] as List),
      captainName: json['captainName'] as String,
      spaceshipModel: json['spaceshipModel'] as String,
      spaceshipImagePath: json['spaceshipImagePath'] as String,
    );
  }
  
  // Convert Mission to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'planetId': planetId,
      'planetName': planetName,
      'type': type.toString().split('.').last,
      'departureDate': departureDate.toIso8601String(),
      'estimatedReturnDate': estimatedReturnDate.toIso8601String(),
      'durationInDays': durationInDays,
      'price': price,
      'maxPassengers': maxPassengers,
      'currentPassengers': currentPassengers,
      'status': status.toString().split('.').last,
      'completionPercentage': completionPercentage,
      'description': description,
      'includedActivities': includedActivities,
      'requirements': requirements,
      'captainName': captainName,
      'spaceshipModel': spaceshipModel,
      'spaceshipImagePath': spaceshipImagePath,
    };
  }
  
  // Create a copy of Mission with some properties changed
  Mission copyWith({
    String? id,
    String? name,
    String? planetId,
    String? planetName,
    MissionType? type,
    DateTime? departureDate,
    DateTime? estimatedReturnDate,
    int? durationInDays,
    double? price,
    int? maxPassengers,
    int? currentPassengers,
    MissionStatus? status,
    double? completionPercentage,
    String? description,
    List<String>? includedActivities,
    List<String>? requirements,
    String? captainName,
    String? spaceshipModel,
    String? spaceshipImagePath,
  }) {
    return Mission(
      id: id ?? this.id,
      name: name ?? this.name,
      planetId: planetId ?? this.planetId,
      planetName: planetName ?? this.planetName,
      type: type ?? this.type,
      departureDate: departureDate ?? this.departureDate,
      estimatedReturnDate: estimatedReturnDate ?? this.estimatedReturnDate,
      durationInDays: durationInDays ?? this.durationInDays,
      price: price ?? this.price,
      maxPassengers: maxPassengers ?? this.maxPassengers,
      currentPassengers: currentPassengers ?? this.currentPassengers,
      status: status ?? this.status,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      description: description ?? this.description,
      includedActivities: includedActivities ?? this.includedActivities,
      requirements: requirements ?? this.requirements,
      captainName: captainName ?? this.captainName,
      spaceshipModel: spaceshipModel ?? this.spaceshipModel,
      spaceshipImagePath: spaceshipImagePath ?? this.spaceshipImagePath,
    );
  }
  
  // Helper method to get color based on mission status
  Color getStatusColor() {
    switch (status) {
      case MissionStatus.scheduled:
        return Colors.blue;
      case MissionStatus.inProgress:
        return Colors.amber;
      case MissionStatus.completed:
        return Colors.green;
      case MissionStatus.aborted:
        return Colors.red;
      case MissionStatus.cancelled:
        return Colors.red.shade700;
    }
  }
  
  // Helper method to get icon based on mission type
  IconData getTypeIcon() {
    switch (type) {
      case MissionType.orbitalTour:
        return Icons.rotate_right;
      case MissionType.surfaceExpedition:
        return Icons.terrain;
      case MissionType.researchMission:
        return Icons.science;
      case MissionType.colonizationProject:
        return Icons.home_work;
      case MissionType.miningOperation:
        return Icons.construction;
      case MissionType.luxuryCruise:
        return Icons.star;
    }
  }
  
  // Helper method to get formatted price
  String getFormattedPrice() {
    return '${price.toStringAsFixed(0)} SC'; // SC = Space Credits
  }
  
  // Getter for formatted price
  String get formattedPrice => getFormattedPrice();
  
  // Getter for formatted departure date
  String get formattedDepartureDate {
    return '${departureDate.day}/${departureDate.month}/${departureDate.year}';
  }
  
  // Helper method to get availability status
  String getAvailabilityStatus() {
    final available = maxPassengers - currentPassengers;
    if (available <= 0) {
      return 'Fully Booked';
    } else if (available <= 5) {
      return 'Limited Availability';
    } else {
      return 'Available';
    }
  }
}