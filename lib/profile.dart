import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
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
                    child: Center(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                                maxRadius: 50,
                                backgroundImage:
                                    NetworkImage('assets/images/skasmi.jpeg')),
                          ),
                          Column(
                            children: [
                              Text(
                                'skasmi',
                                style: TextStyle(
                                    fontFamily: 'mytwo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                'Level',
                                style: TextStyle(
                                    fontFamily: 'mytwo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    height: 200,
                    width: screenSize.width * 95 / 100,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15)),
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
