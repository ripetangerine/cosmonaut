import 'dart:collection';
import 'dart:math';

import 'package:client/models/observation.dart';
import 'package:client/viewmodels/information_viewmodel.dart';
import 'package:client/viewmodels/initial_data_viewmodel.dart';
import 'package:client/viewmodels/observation_viewmodel.dart';
import 'package:client/viewmodels/whitenoise_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
// TODO : 이전 행성 상태 관리
class _HomeScreenState extends State<HomeScreen>{
  final PageController _pageController = PageController();
  int currentIndex = 0;
  final pageTypes = ["solar", "mars", "earth"];
  final String defaultPageType = "solar"; // 이전에 저장된 페이지의 타입이 없거나/불러올 수 없음 -> 해당 인용
  late String currentPageType = defaultPageType;

  late List<String> universeSoundList;
  // TODO : 모듈 연산으로 메인페이지수, 노래 인덱스 수  나타내기
  int currentSoundIndex = 0;
  late String? currentSound = universeSoundList[currentSoundIndex];

  @override
  void initState(){
    super.initState();
    // final vmInitialData = context.read<InitialDataViewmodel>();
    // final vmObservationData = context.read<ObservationViewModel>();
  }
  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index-1;
    });
    String type = pageTypes[currentIndex];
    context.read<ObservationViewModel>().fetchOne(
      type: type,
      // TODO : 추후 오늘 날짜로 변경 
      startDate: "2025-01-01",
      endDate: "2025-01-01",
    );
  }
  @override
  Widget build(BuildContext context){
    final vmInitial = context.watch<InitialDataViewmodel>();
    final vmInfo = context.watch<InformationViewModel>();
    final vmObs = context.watch<ObservationViewModel>();
    final vmWhite = context.watch<WhiteNoiseViewModel>();

    universeSoundList = vmWhite.audioListData as List<String>;


    return Scaffold(
      appBar: AppBar(
        title: const Text("cosmonaut",
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
                  builder: (context) => CalenderScreen(),  
                )
              );
            }, 
            icon: SvgPicture.asset('assets/icons/calender_icon_dot', width:22, height:22),
          )
        ],
        //기본 스타일 구성
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          _buildPage(
            vmInitial, 
            vmObs, 
            vmWhite, 
            vmInfo, 
            currentSound, 
            currentPageType
          ),
        ],
      ),
    );
  }
}

Widget _buildPage(
    InitialDataViewmodel vmInitial, 
    ObservationViewModel vmObs, 
    WhiteNoiseViewModel vmWhite, 
    InformationViewModel vmInfo, 
    String? currentSound,
    String pageType,
  ){

  Observation vmObsFetchOne = vmObs.fetchOne(
    type:pageType, 
    startDate:"2025-01-01", 
    endDate:"2025-01-01"
  ) as Observation;

  return 
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Space(),
        SpaceAudioCard(
          title: (currentSound as String),   // "sound of solar"
          utcTime:  "UTC+9",         // "UTC+9"
          solDate: vmInfo.loadMarsDate() as String,         // "596 sol"
          onPlay: () {
            vmWhite.playAudio(title:currentSound);            // ViewModel에서 재생
          },
          onNext: () {
            vmWhite.fetchPlayAudio(
              title: currentSound
            );       // 우주선 버튼 → 다음 오디오 요청
          },
        ),  
        LogCard(
          title: vmObsFetchOne.eventTitle,
          subtitle: vmObsFetchOne.eventTime,
          detail: vmObsFetchOne.content
        ),
        OrbCard(
          type: pageType,
        ),
      ],
    );
 }

// TODO : 10초단위로 별 자동 렌더링 구현
class _Space extends StatelessWidget {
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

            Image.asset(
              "assets/images/astronaut.png", 
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

class LogCard extends StatelessWidget {
  final String title;        // 관측 종류 (예: FLR)
  final String subtitle;     // 부제 (예: "태양 플레어 알림")
  final String detail; 
  const LogCard({
    super.key, required this.title, required this.subtitle, required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x66102030), // 반투명 네모 박스
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "관측 일지",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: "pixel",
                ),
              ),  
              Container(
                padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF074A87),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "전체탐사",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "pixel",
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 8),
          /// CONTENT
          Text(
            "$title ($subtitle)",
            style: const TextStyle(
              color: Color(0xFF00FF00), // 초록 텍스트
              fontSize: 16,
              fontFamily: "pixel",
            ),
          ),
        ],
      ),
    );
  }
}

class OrbCard extends StatefulWidget{
  final String type;
  const OrbCard({super.key, required this.type});
  
  @override
  State<OrbCard> createState() => _OrbCardState();
}

class _OrbCardState extends State<OrbCard>{
 String currentOrbUrl = "";

  @override
  void initState(){
    super.initState();
    currentOrbUrl = "/${widget.type}.svg";
  }

 @override
 Widget build(BuildContext buildContext){
  return SizedBox(
    height: 300,
    width: 300,
    child: Stack(
      children: [
        Positioned(
          child: OverflowBox(
            minWidth: 0,
            minHeight: 0,
            maxHeight: double.infinity,
            maxWidth: double.infinity,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "asset/icons$currentOrbUrl"
            )
          )
        )
      ],
    )
  );
 }
}