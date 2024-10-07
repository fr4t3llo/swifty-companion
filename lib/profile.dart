import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final String level = '14.05';
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/backV2.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Profile',
                style: TextStyle(
                    fontFamily: 'mytwo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {}),
            ),
            body: Center(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: screenSize.width * 95 / 100,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  maxRadius: 50,
                                  backgroundImage: NetworkImage(
                                      'assets/images/skasmi.jpeg')),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'skasmi',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'mytwo',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: screenSize.width * 0.5,
                                    child: LinearPercentIndicator(
                                      animation: true,
                                      lineHeight: 18.0,
                                      animationDuration: 2500,
                                      percent: 0.05,
                                      barRadius: Radius.circular(10),
                                      curve: Curves.ease,
                                      center: Text(
                                        "Level  $level% ",
                                        style: TextStyle(
                                            fontFamily: 'mytwo',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor: const Color.fromARGB(
                                          255, 217, 0, 101),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
