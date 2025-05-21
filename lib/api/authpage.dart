// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swifty_companion/search_page.dart';
import 'package:swifty_companion/api/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;
  bool _isCheckingToken = true;

  @override
  void initState() {
    super.initState();
    _checkExistingToken();
  }

  Future<void> _checkExistingToken() async {
    try {
      final hasValidToken = await AuthService.hasValidToken();

      if (hasValidToken && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
      }
    } catch (e) {
      debugPrint('Error checking token: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingToken = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_isCheckingToken) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo42.png'),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Color(0xFFF7941D),
              ),
            ],
          ),
        ),
      );
    }




    return Scaffold(
      body: Stack(
        children: [
          // Background Image
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
                // Logo and Title
                Image.asset('assets/images/logo42.png'),
                const Text(
                  'Swifty Companion',
                  style: TextStyle(
                      color: Colors.white, fontSize: 50, fontFamily: 'my'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: (screenSize.width * 35) / 100,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      backgroundColor: const Color(0xFFF7941D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'mytwo',
                                  fontSize: 20,
                                ),
                              ),
                              Icon(
                                Iconsax.login,
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

  Future<void> _handleLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.authenticateUser();

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
