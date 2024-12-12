// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swifty_companion/profile.dart';
// import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/logo42.png'),
                const Text('Swifty Companion',
                    style: TextStyle(
                        color: Colors.white, fontSize: 50, fontFamily: 'my')),
                const SizedBox(height: 40),
                SizedBox(

                  width: MediaQuery.sizeOf(context).width - 200,
                  child: TextField(
                    cursorColor: Colors.black,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'mytwo', fontSize: 20),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 250,
                  height: 45, // Adjust the width as needed
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => const SizedBox(
                                height: 150,
                                width: 150,
                                child: Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                              ));
                      await Future.delayed(const Duration(seconds: 5), () {})
                          .whenComplete(() {
                        Navigator.pop(context);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      backgroundColor: const Color(0xFFF7941D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SEARCH",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'mytwo',
                            fontSize: 20,
                          ),
                        ),
                        Icon(
                          Iconsax.search_normal,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
