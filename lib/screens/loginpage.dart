import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/screens/gamestartpage.dart';
import 'package:heroes_apir/utils/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _tokenController = TextEditingController();
  final SuperheroApi _api = SuperheroApi();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSavedToken();
  }

  Future<void> _checkSavedToken() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final savedToken = await DatabaseManager.instance.getApiAccessToken();

      if (savedToken != null) {
        // If a token exists, validate it by calling the API
        await _api.testAccessToken(savedToken);

        // If valid, navigate to the GameStartPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GameStartPage(),
          ),
        );
      }
    } catch (e) {
      // If the saved token is invalid, do nothing and allow the user to log in
      print('Saved token is invalid: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter Access Token',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _tokenController,
                    decoration: InputDecoration(
                      labelText: 'Access Token',
                      border: const OutlineInputBorder(),
                      errorText: _errorMessage,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onLoginPressed,
                    child: const Text('Login'),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _onLoginPressed() async {
    final token = _tokenController.text.trim();

    if (token.isEmpty) {
      setState(() {
        _errorMessage = 'Access token cannot be empty';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Validate the token by calling the API
      await _api.testAccessToken(token);

      // Save the token to the database
      await DatabaseManager.instance.saveApiAccessToken(token);

      // Navigate to the GameStartPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GameStartPage(),
        ),
      );
    } catch (e) {
      // If an error occurs, show an error message
      setState(() {
        _errorMessage = 'Invalid access token. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}