import 'package:client/viewmodels/initial_data_viewmodel.dart';
import 'package:client/viewmodels/observation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/widgets/space.dart';
import 'package:client/widgets/white_noise.dart';
import 'package:client/widgets/log.dart';
import 'package:client/widgets/planet.dart';
import 'package:client/views/calender_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// SUN (Default)
class _HomeScreenState extends State<HomeScreen>{
  @override
  void initState(){
    super.initState();
  }   

  @override
  Widget build(BuildContext context){
    final initialViewModel = context.watch<InitialDataViewmodel>();
    final observationViewModel = context.read<ObservationViewmodel>();//.fetchAll();
    observationViewModel.fetchAll(type:"solar");

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.surface,
        
        title: const Text(
          "cosmonaut",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalenderScreen(
                    // 파라미터
                  ),  
                )
              );
            }, 
            icon: SvgPicture.asset('assets/icons/calender_icon_dot', width:22, height:22),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Space(),
          WhiteNoise(),
          Log(),
          Planet(),
        ],
      )
    );
  }
}


//
void fetchData() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/items/1'));
  
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print(data);
  } else {
    print('Failed to load data');
  }
}


