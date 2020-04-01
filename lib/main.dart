import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/currentIndex.dart';
import 'pages/index_page.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/counter.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_shop/routers/routes.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_shop/provide/cart.dart';

void main() {
  var counter = Counter();
  var providers = Providers();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var currentIndexProvide  =CurrentIndexProvide();
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 初始化Fluro
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: '商城',
        debugShowCheckedModeBanner: false,

        // 生成路由页面
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(primaryColor: Colors.red),
        home: IndexPage(),
      ),
    );
  }
}
