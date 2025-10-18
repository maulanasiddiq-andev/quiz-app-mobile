import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;

  Future<void> initialize({String? clientId, String? serverClientId}) async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );
      _isInitialized = true;

      // Optional: listen to auth events
      _googleSignIn.authenticationEvents.listen((event) {
        // Handle events if needed
      }).onError((err) {
        // Handle errors
      });

      // Try lightweight (silent) auth
      // _googleSignIn.attemptLightweightAuthentication();
    }
  }

  Future<GoogleSignInAccount> signIn() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final account = await _googleSignIn.authenticate();
      return account;
    } on GoogleSignInException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }
}