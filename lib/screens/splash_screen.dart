import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

  class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
      super.initState();
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomeScreen())
          );
      });
    }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.teal.shade300,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.monetization_on, size: 100, color: Colors.white),
              SizedBox(height: 20,),
              Text(
                'Control de Gastos',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      );
    }
  }
