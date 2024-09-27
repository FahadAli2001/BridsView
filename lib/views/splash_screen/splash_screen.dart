import 'dart:developer';
import 'package:birds_view/controller/splash_controller/splash_controller.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/onboarding_screen/onboarding_two_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
      
        checkRoute();
      }
    });
  }

  Future<void> checkRoute() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      // ignore: use_build_context_synchronously
      final splashController =
          // ignore: use_build_context_synchronously
          Provider.of<SplashController>(context, listen: false);
      String? id = sp.getString('user_id') ?? '';
      String? token = sp.getString('token') ?? '';
      log('User ID: $id, Token: $token');

      if (id.isEmpty && token.isEmpty) {
        log('Navigating to OnboardingOneScreen');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(PageTransition(
            duration: const Duration(seconds: 1),
            child: const OnboardTwoScreen(),
            type: PageTransitionType.fade));
      } else {
        log('Fetching user profile');
        // ignore: use_build_context_synchronously
        await splashController.fetchUserProfile(id, token, context);
      }
    } catch (e) {
      log('Error in checkRoute: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.1),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            image: DecorationImage(
              image: AssetImage(splashBackground),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.9),
                BlendMode.srcOver,
              ),
            )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  whiteLogo,
                  height: size.height * 0.3,
                ),
              ),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: RichText(
                    text: TextSpan(
                      text: "BIRDS",
                      style: GoogleFonts.urbanist(
                          fontSize: size.height * 0.05,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'VIEW',
                          style: GoogleFonts.urbanist(
                              fontSize: size.height * 0.05,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
