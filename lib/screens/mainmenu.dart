import 'package:flutter/material.dart';
import 'package:heroes_apir/db/api_access_token_dao.dart';
import 'package:heroes_apir/screens/battleground.dart';
import 'package:heroes_apir/screens/bookmarks.dart';
import 'package:heroes_apir/screens/heroofthedaypage.dart';
import 'package:heroes_apir/screens/homepage.dart';
import 'package:heroes_apir/screens/loginpage.dart';
import 'package:heroes_apir/screens/search_page.dart';
import 'package:heroes_apir/screens/testpage.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
  final ApiAccessTokenDao _apiAccessTokenDao = ApiAccessTokenDao();
    // Delete the token from the database
    await _apiAccessTokenDao.deleteApiAccessToken();

    // Navigate to the LoginPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 16, // Adjusted spacing between rows
            crossAxisSpacing: 16, // Adjusted spacing between columns
            children: [
              _buildMenuButton(
                context,
                icon: Icons.home,
                label: 'Home',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: Icons.sports_martial_arts,
                label: 'Battleground',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Battleground()),
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: Icons.bookmark,
                label: 'Bookmarks',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookmarksPage()),
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: Icons.star,
                label: 'Hero of the Day',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HeroOfTheDayPage()),
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: Icons.search,
                label: 'Search',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: Icons.science, 
                label: 'Test Page',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestPage()),
                  );
                },
              ),
              _buildMenuButton(
                context,
                icon: Icons.logout,
                label: 'Logout',
                onTap: () async {
                  await _logout(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingMenuButton(onPressed: () => _openMenu(context));
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(12), // Slightly smaller border radius
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced padding inside buttons
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.white), // Reduced icon size
              const SizedBox(height: 6), // Reduced spacing between icon and text
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingMenuButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingMenuButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.blue.shade700,
      child: const Icon(Icons.menu, color: Colors.white),
    );
  }
}