import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bouncerwidget/bouncerwidget.dart';
import 'package:fawri_app_refactor/constants/constants.dart';
import 'package:fawri_app_refactor/firebase/user/UserModel.dart';
import 'package:fawri_app_refactor/pages/authentication/register_screen/register_screen.dart';
import 'package:fawri_app_refactor/pages/authentication/sign_in/sign_in.dart';
import 'package:fawri_app_refactor/pages/category-splash/category-splash.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/server/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import '../../../components/button_widget/button_widget.dart';
import '../../../firebase/user/UserController.dart';
import '../../../services/auth/anonymous_auth.dart';
import 'bottom-dialog/bottom-dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    bool isAppleDevice = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // Video background
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                color: Color(0xFF14181B),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/video.gif',
                  ).image,
                ),
              ),
            ),
            loading
                ? Padding(
                    padding: EdgeInsets.only(right: 15, left: 15, top: 450),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                          child: Container(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )),
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(right: 15, left: 15, top: 450),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: 14,
                              left: 14,
                            ),
                            child: BouncingWidget(
                              child: InkWell(
                                onTap: () {
                                  Vibration.vibrate(duration: 100);
                                  setState(() {
                                    loading = true;
                                  });
                                  addUser();
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                      child: Text(
                                    "تخطي",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          // ButtonWidget(
                          //   OnClickFunction: () async {
                          //     setState(() {
                          //       loading = true;
                          //     });
                          //     Timer(Duration(seconds: 1), () async {
                          //       addUser();
                          //     });
                          //   },
                          //   width: double.infinity,
                          //   height: 50,
                          //   name: "تخطي",
                          //   BorderRaduis: 40,
                          //   NameColor: Colors.white,
                          //   BorderColor: Colors.black,
                          //   ButtonColor: Colors.black,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ـــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ OR ــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 20),
                            child: Container(
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Visibility(
                                    //   visible: isAppleDevice,
                                    //   child: Container(
                                    //     height: 50,
                                    //     width: 50,
                                    //     decoration: BoxDecoration(
                                    //         shape: BoxShape.circle,
                                    //         color: MAIN_COLOR),
                                    //     child: Center(
                                    //       child: IconButton(
                                    //           onPressed: () async {
                                    //             showDialog(
                                    //                 context: context,
                                    //                 barrierDismissible: false,
                                    //                 builder:
                                    //                     (BuildContext context) {
                                    //                   return Column(
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .center,
                                    //                     children: [
                                    //                       Card(
                                    //                           color:
                                    //                               Colors.white,
                                    //                           child: Container(
                                    //                               padding:
                                    //                                   const EdgeInsets
                                    //                                           .all(
                                    //                                       50),
                                    //                               child:
                                    //                                   const CircularProgressIndicator())),
                                    //                     ],
                                    //                   );
                                    //                 });
                                    //             await signInWithApple();
                                    //           },
                                    //           icon: Icon(
                                    //             FontAwesome.apple,
                                    //             color: Colors.white,
                                    //             size: 30,
                                    //           )),
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: MAIN_COLOR),
                                      child: Center(
                                        child: IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Card(
                                                            color: Colors.white,
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        50),
                                                                child:
                                                                    const CircularProgressIndicator())),
                                                      ],
                                                    );
                                                  });
                                              await signInWithFacebook();
                                            },
                                            icon: Icon(
                                              FontAwesome.facebook,
                                              color: Colors.white,
                                              size: 30,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: MAIN_COLOR),
                                      child: Center(
                                        child: IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Card(
                                                            color: Colors.white,
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        50),
                                                                child:
                                                                    const CircularProgressIndicator())),
                                                      ],
                                                    );
                                                  });
                                              await signInWithGoogle();
                                            },
                                            icon: Icon(
                                              Icons.mail,
                                              color: Colors.white,
                                              size: 30,
                                            )),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 15,
                                    // ),
                                    // Container(
                                    //   height: 50,
                                    //   width: 50,
                                    //   decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //       color: MAIN_COLOR),
                                    //   child: Center(
                                    //     child: IconButton(
                                    //         onPressed: () {
                                    //           showPhoneDialog()
                                    //               .showBottomDialog(context);
                                    //         },
                                    //         icon: Icon(
                                    //           Icons.phone,
                                    //           color: Colors.white,
                                    //           size: 30,
                                    //         )),
                                    //   ),
                                    // ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var data = await FirebaseAuth.instance.signInWithCredential(credential);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? TOKEN = await prefs.getString('device_token');
      String user_Id = Uuid().v4();
      UserItem newItem = UserItem(
        name: "",
        id: user_Id,
        token: TOKEN.toString(),
        email: data.user!.email.toString(),
        password: "",
        address: 'address',
        birthdate: '',
        area: '',
        gender: '',
        city: '',
        phone: '',
      );
      userService.addUser(newItem).then((_) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user_Id);
        await prefs.setBool('login', true);
        NavigatorFunction(
            context,
            CategorySplash(
              selectedIndex: 0,
            ));
      }).catchError((error) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "حدث خطأ ما , الرجاء المحاوله فيما بعد");
      });

      // Once signed in, return the UserCredential
      return data;
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "حدث خطأ ما , الرجاء المحاوله فيما بعد");
    }
  }

  signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile', 'user_birthday']);
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      var userDate = await FacebookAuth.instance.getUserData();
      String userDataJson = json.encode(userDate);
      String user_Id = Uuid().v4();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? TOKEN = await prefs.getString('device_token');
      UserItem newItem = UserItem(
        name: "",
        id: user_Id,
        token: TOKEN.toString(),
        email: userDate["email"],
        password: "",
        birthdate: '',
        address: '',
        gender: '',
        area: '',
        city: '',
        phone: '',
      );
      userService.addUser(newItem).then((_) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user_Id);
        await prefs.setBool('login', true);
        NavigatorFunction(
            context,
            CategorySplash(
              selectedIndex: 0,
            ));
      }).catchError((error) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "حدث خطأ ما , الرجاء المحاوله فيما بعد");
      });

      // Try to sign in with Facebook credential
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // Handle account linking here
        // Get the email address of the user.
        String email = e.email!;

        // Fetch sign-in methods for the email.
        List<String> methods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        // Check if the user has already signed in using a different provider.
        if (methods.contains('password')) {
          // User already signed in with email/password, show error or handle accordingly.
          Fluttertoast.showToast(
              msg: "You have already signed in with email/password.");
        } else {
          // User signed in with a different provider, link the accounts.
          // Retrieve current user and link the Facebook credential.
          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            // Retrieve loginResult here
            final LoginResult loginResult = await FacebookAuth.instance.login(
                permissions: ['email', 'public_profile', 'user_birthday']);
            final OAuthCredential facebookAuthCredential =
                FacebookAuthProvider.credential(loginResult.accessToken!.token);
            await currentUser.linkWithCredential(facebookAuthCredential);
            // Continue with your application flow after linking the accounts.
          }
        }
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "حدث خطأ ما , الرجاء المحاوله فيما بعد");
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "حدث خطأ ما , الرجاء المحاوله فيما بعد");
    }
  }

  final UserService userService = UserService();
  addUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? TOKEN = await prefs.getString('device_token');
    String user_Id = Uuid().v4();
    UserItem newItem = UserItem(
      name: "",
      id: user_Id,
      token: TOKEN.toString(),
      email: "$user_Id@gmail.com",
      password: "",
      address: '',
      birthdate: '',
      gender: '',
      area: '',
      city: '',
      phone: '',
    );
    userService.addUser(newItem).then((_) async {
      setState(() {
        loading = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user_Id);
      await prefs.setBool('login', true);
      NavigatorFunction(
          context,
          CategorySplash(
            selectedIndex: 0,
          ));
    }).catchError((error) {
      setState(() {
        loading = false;
      });
    });
  }

  bool loading = false;

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}

class showPhoneDialog {
  void showBottomDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: PhoneBottomDialog(),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
