import 'package:flutter/material.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/pages/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Efficiently Manage Your\nTasks!",
      "subtitle":
          "Organize, track, and complete your tasks\nwith ease and confidence.",
      "image": "assets/images/onboard/Image-0.png"
    },
    {
      "title": "Collaborate Seamlessly\nwith Your Team!",
      "subtitle":
          "Invite members, assign tasks, and achieve\ngoals together more effectively",
      "image": "assets/images/onboard/Image-1.png"
    },
    {
      "title": "Prioritizr What Truly\nMatters!",
      "subtitle":
          "Set clear priorities and stay focused\non what's most important.",
      "image": "assets/images/onboard/Image-2.png"
    },
  ];

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the next screen or perform another action
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    }
  }

  AnimatedContainer indicator({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 10),
      width: index == currentIndex ? 30 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: index == currentIndex
            ? Colors.deepPurple
            : Colors.grey.withOpacity(0.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      onboardingData[currentIndex]["title"]!,
                      style: font.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      onboardingData[currentIndex]["subtitle"]!,
                      style: font,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Image.asset(
                        onboardingData[currentIndex]["image"]!,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: List.generate(onboardingData.length, (index) {
                      return indicator(index: index);
                    }),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Next',
                    style: font,
                  )
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 58,
                    height: 58,
                    child: CircularProgressIndicator(
                      value: (currentIndex + 1) / onboardingData.length,
                      strokeWidth: 5,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: nextPage,
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.deepPurple, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
