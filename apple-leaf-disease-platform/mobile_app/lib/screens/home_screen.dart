import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/disease_card.dart';
import '../widgets/recent_detection_card.dart';
import '../providers/history_provider.dart';
import '../models/detection_result.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecentDetections();
  }

  Future<void> _loadRecentDetections() async {
    setState(() => _isLoading = true);
    await Provider.of<HistoryProvider>(context, listen: false).loadHistory();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final recentResults = historyProvider.recentResults;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF1B5E20),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Welcome to',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'LeafHealth AI',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Detect apple leaf diseases instantly with AI',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.camera_alt,
                                label: 'Take Photo',
                                color: Colors.orange,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/camera'),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.photo_library,
                                label: 'Gallery',
                                color: Colors.blue,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/gallery'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Recent Detections Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Detections',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (recentResults.isNotEmpty)
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/history'),
                      child: Text('View All'),
                    ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: _isLoading
                ? _buildShimmerLoading()
                : recentResults.isEmpty
                    ? _buildEmptyState()
                    : Container(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: recentResults.length > 5
                              ? 5
                              : recentResults.length,
                          itemBuilder: (context, index) {
                            return RecentDetectionCard(
                              result: recentResults[index],
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/results',
                                  arguments: recentResults[index],
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
          
          // Common Diseases Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Common Diseases',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildListDelegate([
                DiseaseCard(
                  name: 'Apple Scab',
                  imagePath: 'assets/images/diseases/apple_scab.jpg',
                  color: Colors.brown,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/disease-info',
                      arguments: {'disease': 'Apple Scab'},
                    );
                  },
                ),
                DiseaseCard(
                  name: 'Black Rot',
                  imagePath: 'assets/images/diseases/black_rot.jpg',
                  color: Colors.grey[900]!,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/disease-info',
                      arguments: {'disease': 'Black Rot'},
                    );
                  },
                ),
                DiseaseCard(
                  name: 'Cedar Rust',
                  imagePath: 'assets/images/diseases/cedar_rust.jpg',
                  color: Colors.orange[900]!,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/disease-info',
                      arguments: {'disease': 'Cedar Rust'},
                    );
                  },
                ),
                DiseaseCard(
                  name: 'Healthy',
                  imagePath: 'assets/images/diseases/healthy.jpg',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/disease-info',
                      arguments: {'disease': 'Healthy'},
                    );
                  },
                ),
              ]),
            ),
          ),
          
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 180,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              width: 150,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 180,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library,
            size: 50,
            color: Colors.grey[400],
          ),
          SizedBox(height: 10),
          Text(
            'No detections yet',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Take a photo or upload from gallery',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}