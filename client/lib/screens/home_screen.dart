import 'package:client/screens/calender_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/widgets/space.dart';
import 'package:client/widgets/white_noise.dart';
import 'package:client/widgets/log.dart';
import 'package:client/widgets/planet.dart';
import 'package:client/screens/calender_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// SUN (Default)
class _HomeScreenState extends State<HomeScreen>{

  @override
  Widget build(BuildContext context){
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