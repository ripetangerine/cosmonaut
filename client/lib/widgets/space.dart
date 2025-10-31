import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Space extends StatefulWidget{
  const Space({super.key});

  @override
  State<Space> createState() => _SpaceState();
}

class _SpaceState extends State<Space>{
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
      padding: EdgeInsets.all(10),
      width: 380,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        )
      ),
      child: Stack(
        children: <Widget>[
          Positioned( 
            top: 10, // TODO : 좌표로 변경
            bottom: 10,
            left: 10,
            right: 10,
            child: SvgPicture.asset('assets/star_1')
          ),
        ],
      ),
    );
  }
}