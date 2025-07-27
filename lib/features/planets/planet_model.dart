import 'package:flutter/material.dart';

class Planet {
  final String id;
  final String name;
  final String description;
  final double distanceFromEarth; // in light years or AU
  final double diameter; // in km
  final double gravity; // relative to Earth (Earth = 1.0)
  final double temperature; // in Celsius
  final bool hasAtmosphere;
  final bool hasWater;
  final bool isHabitable;
  final List<String> keyFeatures;
  final Color color;
  final int explorationProgress; // 0-100%

  Planet({
    required this.id,
    required this.name,
    required this.description,
    required this.distanceFromEarth,
    required this.diameter,
    required this.gravity,
    required this.temperature,
    required this.hasAtmosphere,
    required this.hasWater,
    required this.isHabitable,
    required this.keyFeatures,
    required this.color,
    required this.explorationProgress,
  });

  Planet copyWith({
    String? id,
    String? name,
    String? description,
    double? distanceFromEarth,
    double? diameter,
    double? gravity,
    double? temperature,
    bool? hasAtmosphere,
    bool? hasWater,
    bool? isHabitable,
    List<String>? keyFeatures,
    Color? color,
    int? explorationProgress,
  }) {
    return Planet(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      distanceFromEarth: distanceFromEarth ?? this.distanceFromEarth,
      diameter: diameter ?? this.diameter,
      gravity: gravity ?? this.gravity,
      temperature: temperature ?? this.temperature,
      hasAtmosphere: hasAtmosphere ?? this.hasAtmosphere,
      hasWater: hasWater ?? this.hasWater,
      isHabitable: isHabitable ?? this.isHabitable,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      color: color ?? this.color,
      explorationProgress: explorationProgress ?? this.explorationProgress,
    );
  }
}