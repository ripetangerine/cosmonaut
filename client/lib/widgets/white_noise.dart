
import 'package:flutter/material.dart';

class WhiteNoise extends StatefulWidget{
  final String musicName, defaultTime, marsDay;

  const WhiteNoise({
    super.key,
    this.musicName = 'Sound of Solar - Nasa',
    this.defaultTime = 'UTC+9',
    this.marsDay = 'Sol 1'
  });

  @override
  State<WhiteNoise> createState() => _WhiteNoiseState();
}

class _WhiteNoiseState extends State<WhiteNoise>{

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 98,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "sound of solar(1)",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Text(
                    "UTC+9",
                  ),
                  Text(
                    "596 sol",
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            // 사이즈 82
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    
                  });
                }, 
                icon: Icon(Icons.play_arrow),
              ),
              IconButton(
                onPressed: (){
                  setState((){

                  });
                }, 
                icon: Icon(Icons.play_arrow),
              )
            ],
          ),
        ],
      ),
    );
  }
}