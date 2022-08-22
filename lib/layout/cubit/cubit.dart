import 'package:flutter/material.dart';

import 'package:flutter_app/layout/cubit/states.dart';
import 'package:flutter_app/models/favorites_model.dart';
import 'package:flutter_app/models/home_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/categories_model.dart';
import '../../models/change_favorites_model.dart';
import '../../models/shop_login_model.dart';
import '../../modules/categories_screen.dart';
import '../../modules/favorites_screen.dart';
import '../../modules/products_screen.dart';
import '../../modules/settings_screen.dart';
import '../../shared/d/components/constants.dart';
import '../../shared/d/end_points.dart';
import '../../shared/d/remote/dio_helper.dart';
class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

 HomeModel homeModel ;
  Map<int , bool> favorites ={} ;
  void getHome(){
    emit(ShopLoadingHomeDataState());
      DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favorites.addAll({
          element.id :element.inFavorites
        });
      });
      }
      ).catchError((error) { print(error.toString());
      emit(ShopErrorHomeDataState());});
  
}
  CategoriesModel categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }




  ChangeFavoritesModel changeFavoritesModel;
  void changeFavorites(int procuctId
  ){
     favorites[procuctId] = !favorites[procuctId];
     emit(ShopChangeFavoritesState());

     DioHelper.postData(url: FAVORITES
      , data: { "product_id" : procuctId}
      , token: token)
        .then((value){
          changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
          if( !changeFavoritesModel.status){
            favorites[procuctId] = !favorites[procuctId];
          }else{
            getFavorites();
          }
          emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));
    })
    .catchError((error){
       favorites[procuctId] = !favorites[procuctId];
       emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      //printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }


  ShopLoginModel userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUserDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    @required String name,
    @required String email,
    @required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateUserState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}