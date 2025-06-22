import 'package:damnhour_university/layout/layout.dart';
import 'package:damnhour_university/modules/login/cubit/login_cubit.dart';
import 'package:damnhour_university/modules/onboarding/onboarding.dart';
import 'package:damnhour_university/modules/splash/splash.dart';
import 'package:damnhour_university/shared/constants/constants.dart';
import 'package:damnhour_university/shared/cubit/bloc_observer.dart';
import 'package:damnhour_university/shared/cubit/cubit.dart';
import 'package:damnhour_university/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Cache_Helper.Init();
  token = Cache_Helper.get_saved(key: 'token') ?? 'null';
  userId = Cache_Helper.get_saved(key: 'userId') ?? 'null';
  Widget home;
  if (token == 'null') {
    home = OnBoarding();
  } else {
    home = LayoutScreen();
  }
  print(token);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (BuildContext context) =>
                  UniversityCubit()
                    ..getComplaintsAndSuggestions()
                    ..getprofileinfo()
                    ..getUserComplaintsAndSuggestions()
                    ..filterPostsBySector('الكل')
                    ..getUserReactions(),
        ),

        BlocProvider<LoginCubit>(
          create: (BuildContext context) => LoginCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            ScreenSize.initscreensize(context);
            return AnimatedSplashScreen(
              splash: Splash(),
              nextScreen: home,
              splashIconSize: 500,
              duration: 2000,
            );
          },
        ),
      ),
    ),
  );
}
