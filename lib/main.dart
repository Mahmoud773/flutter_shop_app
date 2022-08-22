import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/layout/cubit/cubit.dart';
import 'package:flutter_app/shared/d/components/constants.dart';
import 'package:flutter_app/shared/d/local/cache_helper.dart';
import 'package:flutter_app/shared/d/remote/dio_helper.dart';
import 'package:flutter_app/styles/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import 'layout/cubit/states.dart';
import 'layout/shop_layout.dart';
import 'modules/shop_app_login/login/cubit/shop_login_screen.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  //Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

 // bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  //bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');

 // uId = CacheHelper.getData(key: 'uId');


    if(token != null) widget = ShopLayout();
    else widget = ShopLoginScreen();


 //

  runApp(MyApp(
    startWidget: widget,
  ));
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget
{
  // constructor
  // build
  final bool isDark;
  final Widget startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}