import 'package:final_project/onBoarding/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5),() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_)=> const HomeScreen())

      );
    }
    );
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:  Container(
        decoration:  const BoxDecoration(
          color: Color.fromRGBO(11, 102, 35, 1),
    ),
          child:  Center(
            // child: Text('Bookit',style: TextStyle(
            //   fontSize: 24,
            //   color: Colors.white,
            //   fontWeight: FontWeight.bold
            // ),
            // ),
    child:Lottie.asset('assets/splash.json'),
          )

          )




    );
  }
}


