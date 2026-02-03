import 'package:client/theme.dart';
import 'package:client/viewmodels/initial_data_viewmodel.dart';
import 'package:client/viewmodels/observation_viewmodel.dart';
import 'package:client/views/calender_screen.dart';
import 'package:client/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:client/util/datetimeutil.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: 'assets/config/.env');
  await dotenv.load(fileName: ".env"); 
  tz.initializeTimeZones();
  var locations = tz.timeZoneDatabase.locations;

  for (var element in locations.entries) {
//    if (element.value.currentTimeZone.abbreviation ==
//        DateTime.now().timeZoneName) {
    if(element.value.currentTimeZone.offset ==
      DateTime.now().timeZoneOffset.inMilliseconds) {
      debugPrint(element.value.name);
      debugPrint(element.value.currentTimeZone.abbreviation);
      DateTimeUtil.timezone = element.value.name;
      break;
    }
  }
  
  runApp(
    MultiProvider(
      providers : [
        ChangeNotifierProvider(create: (_) => InitialDataViewmodel()),
        ChangeNotifierProvider(create: (_) => ObservationViewModel()), //type : ignore
    ], 
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
      // title:"Cosmonaut",
      theme: appTheme,
      // home: HomeScreen(),
      routes:{
        "/" : (context) => HomeScreen(),
        '/calender': (context) => CalenderScreen()
      }
    );
  }
}
