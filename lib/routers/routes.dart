import 'package:flutter/material.dart';
import 'router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes{
  static String root = '/';
  static String detailsPage = '/detail';
  static void configureRoutes(Router router){

    // 空路由跳转
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params){

        print('EPPOR=====>ROUTE WAS NOT FOUND!!!!!');
      }
    );
    
    // 正确的路由跳转
    router.define(detailsPage, handler: detailsHandler);
  }
}