import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Common/router.dart';
import 'Common/utils/colors.dart';
import 'Features/Auth/auth_controller.dart';
import 'Features/Auth/landing_screen.dart';
import 'Features/home_screen.dart';
import 'Widgets/error_screen.dart';
import 'Widgets/loader.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Opal 1.1',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        //Can insert AppBarTheme
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      //routes: {'/login': (context) => LoginScreen()},
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              } else {
                return HomeScreen();
              }
            },
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
//ref.watch is always watching the data coming in
//if use Futurebuilder, will need to write if connectionstate, etc ourselves
//when meaning whenever we getting the data, since it's a future.