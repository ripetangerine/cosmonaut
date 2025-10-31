import 'package:flutter/material.dart';

class Planet extends StatefulWidget {
  const Planet({super.key});

  @override
  State<Planet> createState() => _PlanetState();
}

class _PlanetState extends State<Planet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

