import 'package:facility/screens/reset_password.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  @override
  initState() {
    super.initState();
    authenticate();
  }

  authenticate() async {
    print("pré autenticação");
    if (await authenticateIsAvailable()) {
      print("Disponivel para autenticar");
      await _getListOfBiometricTypes();
      await _authenticateUser();
    }
  }

  Future<bool> authenticateIsAvailable() async {
    final isAvailable = await _localAuthentication.canCheckBiometrics;
    final isDeviceSupported = await _localAuthentication.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics =
        await _localAuthentication.getAvailableBiometrics();
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: "Use a biometria para prosseguir");
    if (isAuthenticated) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResetPassword(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: GNav(
        gap: 8,
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.favorite_border,
            text: 'Likes',
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}