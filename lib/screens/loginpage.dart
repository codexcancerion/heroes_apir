import 'package:flutter/material.dart';
import 'package:heroes_apir/db/api_access_token_dao.dart';
import 'package:heroes_apir/screens/gamestartpage.dart';
import 'package:heroes_apir/utils/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _tokenController = TextEditingController();
  final SuperheroApi _api = SuperheroApi();
  final ApiAccessTokenDao _apiAccessTokenDao = ApiAccessTokenDao();
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
      final savedToken = await _apiAccessTokenDao.getApiAccessToken();

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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400, // Set a max width for responsiveness
            ),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome to Heroes APIR',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter your access token to continue:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _tokenController,
                      decoration: InputDecoration(
                        labelText: 'Access Token',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _errorMessage,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _onLoginPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
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
      await _apiAccessTokenDao.saveApiAccessToken(token);

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