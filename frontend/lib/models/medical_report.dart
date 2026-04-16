import 'package:flutter/material.dart';

enum ReportStatus { verified, critical, locked }

class MedicalReport {
  final String id;
  final String title;
  final String type;
  final String imageUrl;
  final DateTime createdAt;
  final String timeLabel;
  final ReportStatus status;
  final bool isLocked;
  final String? source;
  final String? patientName;
  final String? doctorName;

  MedicalReport({
    required this.id,
    required this.title,
    required this.type,
    required this.imageUrl,
    required this.createdAt,
    required this.timeLabel,
    required this.status,
    this.isLocked = false,
    this.source,
    this.patientName,
    this.doctorName,
  });
}
