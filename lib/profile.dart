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
    final String login = 'skasmi';
    final String fullName = 'saifeddine kasmi';
    final String wallet = '1400 ₳';
    final String email = 'skasmi@student.1337.ma';
    final String mobile = '+212661189840';

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
                    height: 150,
                    width: screenSize.width * 95 / 100,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Column(
                            children: [
                               CircleAvatar(
                                radius: Radius.circular(10),
                                maxRadius: 50,
                                backgroundImage:
                                    NetworkImage('assets/images/skasmi.jpeg'),
                              ),
                              Text(
                                login,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'mytwo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              fullName,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            Text('wallet: $wallet'),
                            const SizedBox(height: 10),
                            Text('email: $email'),
                            const SizedBox(height: 10),
                            Text('mobile: $mobile'),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: screenSize.width * 0.59,
                              child: LinearPercentIndicator(
                                animation: true,
                                lineHeight: 18.0,
                                animationDuration: 2000,
                                percent: 0.5,
                                barRadius: const Radius.circular(3),
                                center: Text(
                                  "Level  $level% ",
                                  style: const TextStyle(
                                      fontFamily: 'mytwo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                progressColor:
                                    const Color.fromARGB(255, 245, 189, 57),
                              ),
                            ),
                          ],
                        )
                      ],
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
