import 'dart:math';

import 'package:client/viewmodels/information_viewmodel.dart';
import 'package:client/viewmodels/initial_data_viewmodel.dart';
import 'package:client/viewmodels/observation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:client/widgets/space.dart';
// import 'package:client/widgets/white_noise.dart';
// import 'package:client/widgets/log.dart';
// import 'package:client/widgets/planet.dart';
import 'package:client/models/observation_position.dart';

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
    // final vmInitialData = context.read<InitialDataViewmodel>();
    // final vmObservationData = context.read<ObservationViewmodel>();
  }   

  @override
  Widget build(BuildContext context){
    // final vmInitialData = context.watch<InitialDataViewmodel>();
    final vmInformationData = context.watch<InformationViewModel>();
    final vmObservationData = context.watch<ObservationViewModel>();
    final vmWhiteNoiseData = context.watch<WhiteNoiseViewModel>();

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
          SpaceAudioCard(
            title: vmWhiteNoiseData.audioName,         // "sound of solar"
            utcTime:  "UTC+9",         // "UTC+9"
            solDate: vmInformationData.loadMarsDate() as String,         // "596 sol"
            onPlay: () {
              vmWhiteNoiseData.playAudio();            // ViewModel에서 재생
            },
            onNext: () {
              vmWhiteNoiseData.fetchNextAudio();       // 우주선 버튼 → 다음 오디오 요청
            },
          ),
          Log(),
          Planet(),
        ],
      )
    );
  }
}


class Space extends StatelessWidget {
  const Space({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF10243E), // 진한 우주색
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1) 별 랜덤 생성
            ...List.generate(40, (i) {
              final random = Random();
              return Positioned(
                left: random.nextDouble() * 330,
                top: random.nextDouble() * 190,
                child: Container(
                  width: random.nextDouble() * 3 + 1,
                  height: random.nextDouble() * 3 + 1,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(random.nextDouble()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),

            // 2) 중앙 캐릭터
            Image.asset(
              "assets/images/astronaut.png", // 너가 가진 우주인 이미지 경로
              width: 90,
              height: 90,
            ),
          ],
        ),
      ),
    );
  }
}

class SpaceAudioCard extends StatelessWidget {
  final String title;       // sound of solar
  final String utcTime;     // UTC+9
  final String solDate;     // 596 sol
  final VoidCallback onPlay;
  final VoidCallback onNext;

  const SpaceAudioCard({
    super.key,
    required this.title,
    required this.utcTime,
    required this.solDate,
    required this.onPlay,
    required this.onNext,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2846),        // 진한 우주색
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "PressStart2P", // 픽셀 글꼴(없으면 제거)
                  ),
                ),
                const SizedBox(height: 14),

                // Play + Next
                Row(
                  children: [
                    // Play button
                    GestureDetector(
                      onTap: onPlay,
                      child: Image.asset(
                        "assets/icons/play_pixel.png",
                        width: 28,
                        height: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Next song icon (우주선)
                    GestureDetector(
                      onTap: onNext,
                      child: Image.asset(
                        "assets/icons/ufo_pixel.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ------------------------
          // RIGHT SIDE
          // ------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                utcTime,   // 예: UTC+9
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "PressStart2P",
                ),
              ),
              const SizedBox(height: 6),
              Text(
                solDate,   // 예: 596 sol
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: "PressStart2P",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


class Log extends StatelessWidget {
  const Log({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ObservationViewmodel>();

    return Column(
      children: vm.observations.map((o) {
        return ListTile(
          title: Text(o.type),
          subtitle: Text(o.date),
        );
      }).toList(),
    );
  }
}

class Planet extends StatelessWidget {
  const Planet({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InitialDataViewmodel>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("현재 행성: ${vm.currentPlanetName}"),
    );
  }
}







// //
// void fetchData() async {
//   final response = await http.get(Uri.parse('http://127.0.0.1:8000/items/1'));
  
//   if (response.statusCode == 200) {
//     var data = jsonDecode(response.body);
//     print(data);
//   } else {
//     print('Failed to load data');
//   }
// }


