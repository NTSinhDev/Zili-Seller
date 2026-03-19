// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthenticationServices {
//   static AuthenticationServices? instance = AuthenticationServices._();
//   AuthenticationServices._();

//   factory AuthenticationServices.getInstance() {
//     instance ??= AuthenticationServices._();
//     return instance!;
//   }

//   /* GOOGLE
//     Here define "email && profile" to get email address and user information
//     Other options: contact, driver,...
//     * Can browse to https://console.cloud.google.com/welcome?project=shop-order-app to config Google services
//     Services: OAuth consent screen,...
//   */
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: <String>[
//       'email',
//       'profile',
//     ],
//   );

//   /* FACEBOOK
//   */
//   final FacebookAuth _facebookAuth = FacebookAuth.instance;

//   // Logout the current user
//   Future<void> googleLogout() async {
//     await _googleSignIn.signOut();
//   }

//   Future<void> facebookLogout() async {
//     await _facebookAuth.logOut();
//   }

//   Future<String?> signInWithGoogle() async {
//     try {
//       // Attempt to sign in with Google
//       final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

//       if (googleAccount == null) return null;
//       // Get the authentication details from the signed-in Google account
//       final GoogleSignInAuthentication googleAuthentication =
//           await googleAccount.authentication;

//       return googleAuthentication.accessToken;
//     } catch (e) {
//       throw Exception(
//           '[AuthenticationServices] Failed in signInWithGoogle method');
//     }
//   }

//   Future<String?> signInWithFacebook() async {
//     try {
//       final LoginResult loginResult = await _facebookAuth.login();
//       if (loginResult.status == LoginStatus.success) {
//         return loginResult.accessToken?.token;
//       }
//       return null;
//     } catch (e) {
//       throw Exception(
//           '[AuthenticationServices] Failed in signInWithFacebook method');
//     }
//   }
// }
