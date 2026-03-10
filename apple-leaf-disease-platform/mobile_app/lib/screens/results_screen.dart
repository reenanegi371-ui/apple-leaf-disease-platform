import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/detection_result.dart';
import '../models/disease_model.dart';
import '../services/api_service.dart';
import '../providers/history_provider.dart';
import '../widgets/loading_indicator.dart';
import '../utils/constants.dart';
import 'disease_info_screen.dart';

class ResultsScreen extends StatefulWidget {
  final dynamic result;

  ResultsScreen({this.result});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DetectionResult? _detectionResult;
  Disease? _diseaseInfo;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _processResult();
  }

  Future<void> _processResult() async {
    setState(() => _isLoading = true);

    try {
      // Check if we already have the result or need to process
      if (widget.result is DetectionResult) {
        _detectionResult = widget.result;
      } else if (widget.result is Map && widget.result.containsKey('imagePath')) {
        // Process image from camera/gallery
        final imageFile = File(widget.result['imagePath']);
        _detectionResult = await ApiService.detectDisease(imageFile);
      }

      if (_detectionResult != null) {
        // Get disease info
        _diseaseInfo = await ApiService.getDiseaseInfo(_detectionResult!.diseaseName);
      }
    } catch (e) {
      print('Error processing result: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing image'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveToHistory() async {
    if (_detectionResult == null) return;

    setState(() => _isSaving = true);

    try {
      await Provider.of<HistoryProvider>(context, listen: false)
          .addResult(_detectionResult!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to history'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error saving to history: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _shareResults() async {
    if (_detectionResult == null) return;

    final text = '''
    🍎 Apple Leaf Disease Detection Result
    
    Disease: ${_detectionResult!.diseaseName}
    Confidence: ${_detectionResult!.confidence.toStringAsFixed(1)}%
    
    Detected using LeafHealth AI App
    ''';

    try {
      await Share.share(text);
    } catch (e) {
      print('Error sharing: $e');
    }
  }

  Color _getDiseaseColor() {
    if (_detectionResult == null) return Colors.green;
    
    switch (_detectionResult!.diseaseName) {
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Analyzing...'),
        ),
        body: LoadingIndicator(message: 'Analyzing image...'),
      );
    }

    if (_detectionResult == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Failed to analyze image',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final diseaseColor = _getDiseaseColor();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: diseaseColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(_detectionResult!.imagePath),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          diseaseColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _detectionResult!.diseaseName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Confidence: ${_detectionResult!.confidence.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: diseaseColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Confidence Chart
                  Text(
                    'Confidence Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipPadding: EdgeInsets.all(8),
                            tooltipMargin: 8,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final disease = _detectionResult!
                                  .allProbabilities.keys.toList()[groupIndex];
                              final value = rod.toY;
                              return BarTooltipItem(
                                '$disease\n',
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${value.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontWeight