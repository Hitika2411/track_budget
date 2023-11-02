import 'package:track_budget/bottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BiometricLogin extends StatefulWidget {
  const BiometricLogin({Key? key}) : super(key: key);

  @override
  State<BiometricLogin> createState() => _BiometricLoginState();
}

showAlertDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

class _BiometricLoginState extends State<BiometricLogin> {
  void _showError(dynamic error) {
    showAlertDialog(context, error.toString());
  }

  _SupportState _supportState = _SupportState.unknown;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    LocalAuthPlatform.instance.isDeviceSupported().then(
      (bool isSupported) {
        setState(() {
          _supportState =
              isSupported ? _SupportState.supported : _SupportState.unsupported;
        });
      },
    );
  }

  Future<void> _cancelAuthentication() async {
    await LocalAuthPlatform.instance.stopAuthentication();
    setState(() {
      _isAuthenticating = false;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      const localizedReason =
          'Perform biometric authentication (fingerprint/face recognition)';

      // Determine options based on available biometric methods
      const options = AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true, // Enable biometrics only
      );

      authenticated = await LocalAuthPlatform.instance.authenticate(
        localizedReason: localizedReason,
        authMessages: <AuthMessages>[const AndroidAuthMessages()],
        options: options,
      );

      setState(() {
        _isAuthenticating = false;
      });
      if (authenticated) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: ((context) => const BottomNavigationBarExample())));
      }
    } on PlatformException catch (e) {
      _showError(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Login'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 30),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_supportState == _SupportState.unknown)
                const CircularProgressIndicator()
              else if (_supportState == _SupportState.supported)
                const Text('This device is supported')
              else
                const Text('This device is not supported'),
              const Divider(height: 100),
              Text('Current State: $_authorized\n'),
              if (_isAuthenticating)
                ElevatedButton(
                  onPressed: _cancelAuthentication,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Cancel Authentication'),
                      Icon(Icons.cancel),
                    ],
                  ),
                )
              else
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _authenticateWithBiometrics,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(_isAuthenticating
                              ? 'Cancel'
                              : 'Authenticate: biometrics only'),
                          const Icon(Icons.fingerprint),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

@override
enum _SupportState {
  unknown,
  supported,
  unsupported,
}
