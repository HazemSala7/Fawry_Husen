import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/AddressProvider.dart';
import 'package:fawri_app_refactor/pages/authentication/login_screen/login_screen.dart';
import 'package:fawri_app_refactor/pages/chooses_birthdate/chooses_birthdate.dart';
import 'package:fawri_app_refactor/pages/code_birthdate/code_birthdate.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/pages/remain_birthdate/remain_birthdate.dart';
import 'package:fawri_app_refactor/services/notifications/notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'LocalDB/Provider/CartProvider.dart';
import 'LocalDB/Provider/FavouriteProvider.dart';
import 'firebase/cart/CartProvider.dart';
import 'pages/category-splash/category-splash.dart';
import 'server/functions/functions.dart';
import 'services/auth/firebase_user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// PushNotificationService _pushNotificationService = PushNotificationService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage().initHive();
  // await _pushNotificationService.initialise();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => FavouriteProvider()),
    ChangeNotifierProvider(create: (_) => AddressProvider()),
  ], child: Fawri()));
}

class Fawri extends StatefulWidget {
  Fawri({super.key});

  @override
  State<Fawri> createState() => _FawriState();
}

class _FawriState extends State<Fawri> {
  // This widget is the root ofس your application.
  @override
  bool FirstScreen = false;

  int TypeFirstScreen = 1;

  String Type = "";
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  ios_push() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    ios_push();
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications(context);
    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);
    checkFirstSeen();
    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? _seen = (prefs.getBool('login'));
    if (_seen == true) {
      setState(() {
        FirstScreen = false;
      });
    } else {
      setState(() {
        FirstScreen = true;
      });
    }
  }

  FawriFirebaseUser? initialUser;

  bool displaySplashImage = true;

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fawri',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      locale: Locale("ar"),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
          dialogBackgroundColor: Colors.white,
          shadowColor: Colors.white,
          textTheme: GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme)),
      home: FadeTransition(
          opacity: CurvedAnimation(
            parent: AlwaysStoppedAnimation(1),
            curve: Interval(
              1.0,
              0.5,
              curve: Curves.ease,
            ),
          ),
          child:
              // CodeBirthdate()
              ShowCaseWidget(
            builder: Builder(
                builder: (context) =>
                    FirstScreen ? LoginScreen() : CategorySplash()),
          )),
    );
  }
}
