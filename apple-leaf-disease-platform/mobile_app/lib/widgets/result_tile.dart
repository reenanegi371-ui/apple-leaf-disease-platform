import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultTile extends StatelessWidget {
  final String diseaseName;
  final double confidence;
  final String imagePath;
  final DateTime timestamp;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ResultTile({
    Key? key,
    required this.diseaseName,
    required this.confidence,
    required this.imagePath,
    required this.timestamp,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  Color _getDiseaseColor() {
    switch (diseaseName) {
      case 'Apple Scab':
        return Colors.brown;
      case 'Black Rot':
        return Colors.grey[900]!;
      case 'Cedar Rust':
        return Colors.orange[900]!;
      case 'Healthy':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final diseaseColor = _getDiseaseColor();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Image thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: diseaseColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            diseaseName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: diseaseColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${confidence.toStringAsFixed(1)}% confidence',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          _getTimeAgo(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.share, size: 20),
                    onPressed: () {
                      // Share functionality
                    },
                    color: Colors.grey[600],
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20),
                      onPressed: onDelete,
                      color: Colors.red[300],
                    ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],