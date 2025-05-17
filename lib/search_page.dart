import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swifty_companion/api/auth.dart';
import 'package:swifty_companion/profile.dart';
import 'package:swifty_companion/api/authpage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final username = _searchController.text.trim();
    if (username.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a username';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });
    try {
      // Get user data from API
      final userData = await ApiService.searchUser(username);
      if (mounted) {
        if (userData != null) {
          // Navigate to profile page with user data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(userData: userData),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'User not found';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Iconsax.logout_1, color: Colors.white),
              onPressed: _handleLogout,
              tooltip: 'Logout',
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/logo42.png'),
                const Text(
                  'Swifty Companion',
                  style: TextStyle(
                      color: Colors.white, fontSize: 50, fontFamily: 'my'),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: screenSize.width - 100,
                  child: TextField(
                    controller: _searchController,
                    cursorColor: Colors.black,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'mytwo', fontSize: 20),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter User Login',
                      hintStyle: const TextStyle(fontFamily: 'mytwo'),
                      errorText: _errorMessage,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),

                const SizedBox(height: 10),

                // Search Button
                SizedBox(
                  width: screenSize.width - 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isSearching ? null : _performSearch,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      backgroundColor: const Color(0xFFF7941D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: _isSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
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
