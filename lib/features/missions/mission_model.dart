import 'package:flutter/material.dart';

enum MissionStatus { upcoming, inProgress, completed }
enum MissionType { exploration, research, colonization, mining }

class Mission {
  final String id;
  final String name;
  final String description;
  final MissionType type;
  final MissionStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int durationDays;
  final String planetId;
  final int reward;
  final int difficulty; // 1-5
  final Color color;

  Mission({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.durationDays,
    required this.planetId,
    required this.reward,
    required this.difficulty,
    required this.color,
  });

  Mission copyWith({
    String? id,
    String? name,
    String? description,
    MissionType? type,
    MissionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? durationDays,
    String? planetId,
    int? reward,
    int? difficulty,
    Color? color,
  }) {
    return Mission(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      durationDays: durationDays ?? this.durationDays,
      planetId: planetId ?? this.planetId,
      reward: reward ?? this.reward,
      difficulty: difficulty ?? this.difficulty,
      color: color ?? this.color,
    );
  }
}