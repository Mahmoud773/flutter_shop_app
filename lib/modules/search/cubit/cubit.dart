import 'package:flutter_app/modules/search/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/search_model.dart';
import '../../../shared/d/components/constants.dart';
import '../../../shared/d/end_points.dart';
import '../../../shared/d/remote/dio_helper.dart';


class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel model;

  void search(String text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then((value)
    {
      model = SearchModel.fromJson(value.data);

      emit(SearchSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}