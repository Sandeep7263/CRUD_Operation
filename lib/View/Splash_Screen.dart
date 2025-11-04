import 'package:crud_operation/View/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Utils/Animation/Animation_Control.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _scale2Controller;
  late AnimationController _widthController;
  late AnimationController _positionController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _scale2Animation;
  late Animation<double> _widthAnimation;
  late Animation<double> _positionAnimation;

  bool hideIcon = false;
  bool showExplosion = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _widthController.forward();
        }
      });

    _widthController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _widthAnimation = Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _positionController.forward();
        }
      });

    _positionController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _positionAnimation = Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => hideIcon = true);
          _scale2Controller.forward();
        }
      });

    _scale2Controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scale2Animation = Tween<double>(begin: 1.0, end: 32.0).animate(_scale2Controller)
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          // 🎆 Trigger explosion animation
          setState(() => showExplosion = true);

          await Future.delayed(const Duration(milliseconds: 600)); // explosion duration
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(type: PageTransitionType.fade, child: HomeScreen()),
                  (route) => false,
            );
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(1, 8, 24, 1),
      body: Stack(
        children: <Widget>[
          // Background Layers
          for (var i = 0; i < 3; i++)
            Positioned(
              top: -50.0 * (i + 1),
              left: 0,
              child: FadeAnimation(
                1.0 + (0.3 * i),
                Container(
                  width: width,
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/one.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeAnimation(1, const Text("Welcome",
                    style: TextStyle(color: Colors.white, fontSize: 50))),
                const SizedBox(height: 15),
                FadeAnimation(
                    1.3,
                    Text(
                      "We promise that you'll have the most \nfuss-free time with us ever.",
                      style: TextStyle(
                          color: Colors.white.withOpacity(.7),
                          height: 1.4,
                          fontSize: 20),
                    )),
                const SizedBox(height: 180),

                // Animated Button
                FadeAnimation(
                  1.6,
                  AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) => Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _widthController,
                          builder: (context, child) => Container(
                            width: _widthAnimation.value,
                            height: 80,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue.withOpacity(.4),
                            ),
                            child: InkWell(
                              onTap: () {
                                _scaleController.forward();
                              },
                              child: Stack(
                                children: <Widget>[
                                  AnimatedBuilder(
                                    animation: _positionController,
                                    builder: (context, child) => Positioned(
                                      left: _positionAnimation.value,
                                      child: AnimatedBuilder(
                                        animation: _scale2Controller,
                                        builder: (context, child) => Transform.scale(
                                          scale: _scale2Animation.value,
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue),
                                            child: hideIcon
                                                ? Container()
                                                : const Icon(Icons.arrow_forward, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),

          // 🎇 Explosion Effect
          if (showExplosion)
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 3.0),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent.withOpacity(1 - value / 7),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
