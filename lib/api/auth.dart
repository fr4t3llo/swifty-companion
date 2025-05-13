import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class AuthService {
  static const String _tokenKey = 'access_token';
  static const String _expiryKey = 'token_expiry';
  static const String _userDataKey = 'user_data';

  // Load credentials from JSON file
  static Future<Map<String, dynamic>> _getCredentials() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/credentials.json');
      return json.decode(jsonString);
    } catch (e) {
      debugPrint('Error loading credentials: $e');
      throw Exception(
          'Failed to load API credentials. Please check your credentials file.');
    }
  }

  // Check if user has a valid token
  static Future<bool> hasValidToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(_tokenKey);
      final int? expiry = prefs.getInt(_expiryKey);

      if (token == null || expiry == null) {
        return false;
      }

      // Check if token is expired (with 5 minute buffer)
      final now = DateTime.now().millisecondsSinceEpoch;
      if (expiry - now < 300000) {
        // Less than 5 minutes remaining
        return false;
      }

      // Validate token with a test API call
      final validToken = await _validateToken(token);
      return validToken;
    } catch (e) {
      debugPrint('Error checking token: $e');
      return false;
    }
  }

  // Validate token with a test API call
  static Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.intra.42.fr/v2/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Main authentication flow
  static Future<bool> authenticateUser() async {
    try {
      // Get API credentials
      final credentials = await _getCredentials();
      final clientId = credentials['API_KEY'];
      final clientSecret = credentials['SECRET_ID'];
      final redirectUri = credentials['REDIRECT_URI'];

      if (clientId == null || clientSecret == null || redirectUri == null) {
        throw Exception(
            'Invalid credentials format. Check your credentials.json file.');
      }

      // Create authorization URL
      final authUrl = Uri.parse('https://api.intra.42.fr/oauth/authorize'
          '?client_id=$clientId'
          '&redirect_uri=${Uri.encodeComponent(redirectUri)}'
          '&response_type=code'
          '&scope=public');

      // Open browser for user authentication
      if (!await _launchBrowser(authUrl)) {
        throw Exception('Could not launch browser for authentication');
      }

      // Listen for redirect with auth code
      final code = await _listenForRedirect();

      if (code == null) {
        throw Exception('Authorization canceled or failed');
      }

      // Exchange code for token
      final tokenData =
          await _getTokenFromCode(code, clientId, clientSecret, redirectUri);

      // Save token data
      await _saveTokenData(tokenData);

      // Fetch and save user data
      await _fetchAndSaveUserData(tokenData['access_token']);

      return true;
    } catch (e) {
      debugPrint('Authentication error: $e');
      throw Exception('Authentication failed: $e');
    }
  }

  // Launch browser for authentication
  static Future<bool> _launchBrowser(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }

  // Listen for redirect with auth code
  static Future<String?> _listenForRedirect() async {
    final server = await HttpServer.bind('localhost', 8080);

    try {
      debugPrint('Server started on localhost:8080, waiting for redirect...');

      // Set a timeout for the server
      final request = await server.first.timeout(
        const Duration(minutes: 5),
        // onTimeout: () {
        //   throw TimeoutException('Authentication timed out after 5 minutes');
        // },
      );

      // Parse the query parameters
      final params = request.uri.queryParameters;
      final code = params['code'];

      // Check for errors in the response
      final error = params['error'];
      if (error != null) {
        // Send error response to browser
        request.response.statusCode = 400;
        request.response.headers.set('content-type', 'text/html');
        request.response.writeln('''
          <!DOCTYPE html>
          <html>
          <head>
            <title>Authentication Failed</title>
            <style>
              body { font-family: Arial, sans-serif; text-align: center; padding-top: 50px; }
              .error { color: #e74c3c; font-size: 24px; margin-bottom: 20px; }
              .container { max-width: 600px; margin: 0 auto; }
            </style>
          </head>
          <body>
            <div class="container">
              <h1 class="error">Authentication Failed</h1>
              <p>Error: $error</p>
              <p>Please close this window and try again.</p>
            </div>
          </body>
          </html>
        ''');
        await request.response.close();
        return null;
      }

      // Send success response to browser
      request.response.statusCode = 200;
      request.response.headers.set('content-type', 'text/html');
      request.response.writeln('''
        <!DOCTYPE html>
        <html>
        <head>
          <title>Authentication Successful</title>
          <style>
            body { font-family: Arial, sans-serif; text-align: center; padding-top: 50px; }
            .success { color: #2ecc71; font-size: 24px; margin-bottom: 20px; }
            .container { max-width: 600px; margin: 0 auto; }
          </style>
        </head>
        <body>
          <div class="container">
            <h1 class="success">Authentication Successful!</h1>
            <p>You can now close this window and return to the application.</p>
          </div>
          <script>
            // Auto-close the window after 3 seconds
            setTimeout(function() {
              window.close();
            }, 3000);
          </script>
        </body>
        </html>
      ''');
      await request.response.close();

      return code;
    }
    // on TimeoutException {
    //   throw Exception('Authentication timed out. Please try again.');
    // }
    catch (e) {
      debugPrint('Error in redirect handling: $e');
      return null;
    } finally {
      await server.close();
    }
  }

  // Exchange code for token
  static Future<Map<String, dynamic>> _getTokenFromCode(String code,
      String clientId, String clientSecret, String redirectUri) async {
    final response = await http.post(
      Uri.parse('https://api.intra.42.fr/oauth/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode != 200) {
      debugPrint('Token error: ${response.body}');
      throw Exception('Failed to get token: ${response.reasonPhrase}');
    }

    return json.decode(response.body);
  }

  // Save token data to shared preferences
  static Future<void> _saveTokenData(Map<String, dynamic> tokenData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Calculate expiry time
    final int expiresIn = tokenData['expires_in'] ?? 7200; // Default to 2 hours
    final int expiryTime =
        DateTime.now().add(Duration(seconds: expiresIn)).millisecondsSinceEpoch;

    // Save token and expiry
    await prefs.setString(_tokenKey, tokenData['access_token']);
    await prefs.setInt(_expiryKey, expiryTime);

    // Save refresh token if available
    if (tokenData['refresh_token'] != null) {
      await prefs.setString('refresh_token', tokenData['refresh_token']);
    }
  }

  // Fetch and save user data
  static Future<void> _fetchAndSaveUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.intra.42.fr/v2/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final userData = response.body;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userDataKey, userData);
      } else {
        debugPrint('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userData = prefs.getString(_userDataKey);

      if (userData != null) {
        return json.decode(userData);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Logout - clear all saved data
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiryKey);
    await prefs.remove(_userDataKey);
    await prefs.remove('refresh_token');
  }
}

class ApiService {
  static const String baseUrl = 'https://api.intra.42.fr/v2';

  // Search for a user by login
  static Future<Map<String, dynamic>?> searchUser(String login) async {
    try {
      // Get the access token
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      // Make the API request
      final response = await http.get(
        Uri.parse('$baseUrl/users/$login'),
        headers: {'Authorization': 'Bearer $token'},
      );

      // Handle response
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return null; // User not found
      } else {
        throw Exception(
            'Failed to search user: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('Error searching user: $e');
      throw Exception('Failed to search user: $e');
    }
  }

  // Get user's projects
  static Future<List<dynamic>> getUserProjects(int userId) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/projects_users'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to fetch user projects: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting user projects: $e');
      throw Exception('Failed to fetch user projects: $e');
    }
  }

  // Get user's skills
  static Future<List<dynamic>> getUserSkills(int userId) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/cursus_users'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch user skills: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting user skills: $e');
      throw Exception('Failed to fetch user skills: $e');
    }
  }
}
