import 'package:flutter/material.dart';

class Disease {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> organicTreatment;
  final List<String> chemicalTreatment;
  final List<String> prevention;
  final String imageUrl;
  final int colorCode;

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.organicTreatment,
    required this.chemicalTreatment,
    required this.prevention,
    required this.imageUrl,
    required this.colorCode,
  });

  Color get color => Color(colorCode);

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      organicTreatment: List<String>.from(json['organic_treatment'] ?? []),
      chemicalTreatment: List<String>.from(json['chemical_treatment'] ?? []),
      prevention: List<String>.from(json['prevention'] ?? []),
      imageUrl: json['image_url'] ?? '',
      colorCode: json['color_code'] ?? 0xFF2E7D32,
    );
  }
}