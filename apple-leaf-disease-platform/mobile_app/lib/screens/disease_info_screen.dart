import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/detection_provider.dart';
import '../models/disease_model.dart';
import '../widgets/loading_indicator.dart';

class DiseaseInfoScreen extends StatefulWidget {
  final String diseaseName;

  const DiseaseInfoScreen({Key? key, required this.diseaseName}) : super(key: key);

  @override
  _DiseaseInfoScreenState createState() => _DiseaseInfoScreenState();
}

class _DiseaseInfoScreenState extends State<DiseaseInfoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Disease? _diseaseInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDiseaseInfo();
  }

  Future<void> _loadDiseaseInfo() async {
    setState(() => _isLoading = true);
    
    final provider = Provider.of<DetectionProvider>(context, listen: false);
    final info = await provider.getDiseaseInfo(widget.diseaseName);
    
    setState(() {
      _diseaseInfo = info;
      _isLoading = false;
    });
  }

  Color _getDiseaseColor() {
    switch (widget.diseaseName) {
      case 'Apple Scab':
        return Colors.brown;
      case 'Black Rot':
        return Colors.grey[900]!;
      case 'Cedar Rust':
        return Colors.orange[900]!;
      case 'Healthy':
        return Colors.green;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diseaseColor = _getDiseaseColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diseaseName),
        backgroundColor: diseaseColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Description'),
            Tab(text: 'Treatment'),
            Tab(text: 'Prevention'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: _isLoading
          ? LoadingIndicator(message: 'Loading disease information...')
          : _diseaseInfo == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load disease information',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDiseaseInfo,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDescriptionTab(),
                    _buildTreatmentTab(),
                    _buildPreventionTab(),
                  ],
                ),
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getDiseaseColor(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _diseaseInfo!.description,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Symptoms',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getDiseaseColor(),
                    ),
                  ),
                  SizedBox(height: 8),
                  ..._diseaseInfo!.symptoms.map((symptom) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: Text(
                            symptom,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.eco, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Organic Treatment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ..._diseaseInfo!.organicTreatment.map((treatment) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🌱 ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: Text(
                            treatment,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.science, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Chemical Treatment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ..._diseaseInfo!.chemicalTreatment.map((treatment) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🧪 ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: Text(
                            treatment,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreventionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prevention Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getDiseaseColor(),
                ),
              ),
              SizedBox(height: 16),
              ..._diseaseInfo!.prevention.map((tip) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: _getDiseaseColor(),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}