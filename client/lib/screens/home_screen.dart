import 'package:client/widgets/space_scene.dart';
import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children : [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Cosmonaut",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_month_rounded),
                    color: Colors.white,
                    onPressed: (){
                      setState(() {
                        
                      });
                    }, 
                  ),
                ]
              ),
              SizedBox(height: 40),
              SpaceScene(),
              
            ],
          ),
        ),
      ),
    );
  }
}