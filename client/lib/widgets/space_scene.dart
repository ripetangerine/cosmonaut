import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpaceScene extends StatefulWidget{
  const SpaceScene({super.key});

  @override
  State<SpaceScene> createState() => _SpaceSceneState();
}

class _SpaceSceneState extends State<SpaceScene>{

  @override
  void initState(){
    super.initState();
    fetchStars();
  }

  Future<void> fetchStars() async{
    
  }

  @override
  Widget build(BuildContext context){
    return Container(
      width: 380,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFF737373),
          width: 1,
        )
      ),
    );
  }
}