

import '../../../modules/shop_app_login/login/cubit/shop_login_screen.dart';
import '../local/cache_helper.dart';
import 'components.dart';

String token='';

void signOut(context)
{
  CacheHelper.removeData(key: 'token',).then((value) {
    if(value)
    {
      navigateAndFinish(context, ShopLoginScreen(),);
    }
  });
}
