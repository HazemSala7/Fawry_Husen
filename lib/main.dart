import 'package:fawri_app_refactor/LocalDB/Database/local_storage.dart';
import 'package:fawri_app_refactor/LocalDB/Provider/AddressProvider.dart';
import 'package:fawri_app_refactor/pages/authentication/login_screen/login_screen.dart';
import 'package:fawri_app_refactor/pages/cart/cart.dart';
import 'package:fawri_app_refactor/pages/choose-size-shoes/choose-size-shoes.dart';
import 'package:fawri_app_refactor/pages/chooses_birthdate/chooses_birthdate.dart';
import 'package:fawri_app_refactor/pages/code_birthdate/code_birthdate.dart';
import 'package:fawri_app_refactor/pages/home_screen/home_screen.dart';
import 'package:fawri_app_refactor/pages/newest_orders/newest_orders.dart';
import 'package:fawri_app_refactor/pages/privacy_policy/privacy_policy.dart';
import 'package:fawri_app_refactor/pages/product-screen/product-screen.dart';
import 'package:fawri_app_refactor/pages/remain_birthdate/remain_birthdate.dart';
import 'package:fawri_app_refactor/services/notifications/notifications.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uni_links/uni_links.dart';
import 'LocalDB/Provider/CartProvider.dart';
import 'LocalDB/Provider/FavouriteProvider.dart';
import 'firebase/cart/CartProvider.dart';
import 'pages/category-splash/category-splash.dart';
import 'server/functions/functions.dart';
import 'services/auth/firebase_user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
  await LocalStorage().initHive();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => FavouriteProvider()),
      ChangeNotifierProvider(create: (_) => AddressProvider()),
    ],
    child: Fawri(),
  ));
}

class Fawri extends StatefulWidget {
  Fawri({super.key});

  @override
  State<Fawri> createState() => _FawriState();
}

class _FawriState extends State<Fawri> {
  bool FirstScreen = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void handleDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      handleDeepLink(deepLink);
    }).onError((error) {
      print('onLinkError: $error');
    });

    // Handle deep link when app is opened initially
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = initialLink?.link;
    if (deepLink != null) {
      handleDeepLink(deepLink);
    }
  }

  void handleDeepLink(Uri deepLink) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserID = prefs.getString('user_id') ?? "";
    if (deepLink.path == '/product') {
      final productId = deepLink.queryParameters['id'];
      if (productId != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              id: int.parse(productId.toString()),
              SubCategories: [],
              Sub_Category_Key: "",
              cart_fav: false,
              favourite: false,
              index: 1,
              page: 1,
              price: 0,
              priceMul: 1,
              sizes: [],
              url: "",
              ALL: false,
              IDs: [],
              Images: [],
              Product: [],
              SIZES: [],
            ),
          ),
        );
      } else {
        // Handle the case where 'id' parameter is missing
        print('Product ID not found in the deep link.');
      }
    } else if (deepLink.path == '/cart') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => Cart()),
      );
    } else if (deepLink.path == '/track_order') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserID = prefs.getString('user_id') ?? "";
      navigatorKey.currentState?.push(
        MaterialPageRoute(
            builder: (context) => NewestOrders(
                  user_id: UserID,
                )),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    handleDynamicLinks();
    ios_push();
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications(context);
    checkFirstSeen();
  }

  ios_push() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? _seen = prefs.getBool('login');
    setState(() {
      FirstScreen = _seen != true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Fawri',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      locale: Locale("ar"),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        dialogBackgroundColor: Colors.white,
        shadowColor: Colors.white,
        textTheme: GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme),
      ),
      home: FadeTransition(
        opacity: CurvedAnimation(
          parent: AlwaysStoppedAnimation(1),
          curve: Interval(1.0, 0.5, curve: Curves.ease),
        ),
        child: ShowCaseWidget(
          builder: Builder(
            builder: (context) =>
                FirstScreen ? LoginScreen() : CategorySplash(selectedIndex: 0),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/product_details') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => Privacy(),
          );
        }
        return null;
      },
    );
  }
}
