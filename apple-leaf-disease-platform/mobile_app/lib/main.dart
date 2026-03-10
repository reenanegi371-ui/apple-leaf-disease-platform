import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/detection_provider.dart';
import 'providers/history_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await DatabaseService.instance.init();
  await NotificationService.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DetectionProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'LeafHealth AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: SplashScreen(),
            routes: {
              '/home': (context) => HomeScreen(),
              '/camera': (context) => CameraScreen(),
              '/gallery': (context) => GalleryScreen(),
              '/results': (context) => ResultsScreen(),
              '/disease-info': (context) => DiseaseInfoScreen(),
              '/history': (context) => HistoryScreen(),
              '/settings': (context) => SettingsScreen(),
            },
            onGenerateRoute: (settings) {
              // Handle named routes with arguments
              if (settings.name == '/results') {
                final result = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) => ResultsScreen(result: result),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}