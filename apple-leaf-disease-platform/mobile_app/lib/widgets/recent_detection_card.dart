import 'dart:io';
import 'package:flutter/material.dart';
import '../models/detection_result.dart';

class RecentDetectionCard extends StatelessWidget {
  final DetectionResult result;
  final VoidCallback onTap;

  const RecentDetectionCard({
    required this.result,
    required this.onTap,
  });

  Color _getDiseaseColor() {
    switch (result.diseaseName) {
      case 'Apple Scab':
        return Colors.brown;
      case 'Black Rot':
        return Colors.grey[900]!;
      case 'Cedar Rust':
        return Colors.orange[900]!;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diseaseColor = _getDiseaseColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: FileImage(File(result.imagePath)),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                diseaseColor.withOpacity(0.8),
              ],
            ),
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.diseaseName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                '${result.confidence.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _getTimeAgo(result.timestamp),
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}