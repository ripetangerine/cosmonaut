import 'package:client/theme.dart';
import 'package:client/viewmodels/initial_data_viewmodel.dart';
import 'package:client/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => InitialDataViewmodel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: HomeScreen(),
    );
  }
}
