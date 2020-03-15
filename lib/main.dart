import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/counter.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_shop/routers/routes.dart';
import 'package:flutter_shop/routers/application.dart';

void main() {
  var counter = Counter();
  var providers = Providers();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));
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
