import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart' show rootBundle;

// Function to read credentials from JSON file
Future<Map<String, dynamic>> getCredentials() async {
  final String jsonString = await rootBundle.loadString('credentials.json');
  return json.decode(jsonString);
}

Future<void> redirect(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Uri> listen(Uri redirectUrl) async {
  var server = await HttpServer.bind('localhost', 8080);

  try {
    var request = await server.first;
    var params = request.uri.queryParameters;

    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/html');
    request.response
        .writeln('Authorization successful! You can close this window.');
    await request.response.close();

    return Uri.parse('${redirectUrl.toString()}?${request.uri.query}');
  } finally {
    await server.close();
  }
}

Future<void> authenticateUser() async {
  try {
    // Read credentials from file
    final credentials = await getCredentials();
    debugPrint("$credentials");
    final clientId = credentials['API_KEY'];
    final clientSecret = credentials['SECRET_ID'];
    final redirectUrl = Uri.parse('https://api.intra.42.fr/oauth/');

    // Create authorization URL
    final authUrl = Uri.parse('https://api.intra.42.fr/oauth/authorize'
        '?client_id=$clientId'
        '&redirect_uri=${Uri.encodeComponent(redirectUrl.toString())}'
        '&response_type=code'
        '&scope=public');

    await redirect(authUrl);

    final responseUrl = await listen(redirectUrl);
    final code = responseUrl.queryParameters['code'];

    if (code == null) throw Exception('No authorization code received');

    final tokenResponse = await http.post(
      Uri.parse('https://api.intra.42.fr/oauth/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUrl.toString(),
      },
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception('Failed to get token: ${tokenResponse.body}');
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', tokenResponse.body);

    print('Authentication successful! Token response: ${tokenResponse.body}');
  } catch (e) {
    print('Authentication error: $e');
    throw Exception('Failed to authenticate: $e');
  }
}

void main() async {
  try {
    await authenticateUser();
  } catch (e) {
    print('Error in main: $e');
  }
}
