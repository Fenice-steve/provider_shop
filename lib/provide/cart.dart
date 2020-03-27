import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cartInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


List<CartInfoModel> cartList = [];

/// 购物车provide
class CartProvide with ChangeNotifier{
  String cartString="[]";

  save(goodsId, goodsName, count, price, images)async{
    // 初始化SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    // 判断cartString是否为空，为空说明是第一次添加，或者被清除掉了
    // 如果有值进行decode操作
    var temp = cartString==null?[]:json.decode(cartString.toString());
    // 把获得的值转变为List
    List<Map> tempList = (temp as List).cast();
    // 声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false; // 默认没有
    int ival = 0;// 用于进行循环索引使用
    tempList.forEach((item){// 进行循环，找出是否已经存在该商品
      // 如果存在，数量进行+1
      if(item['goodsId']==goodsId){
        tempList[ival]['count'] = item['count']+1;
        cartList[ival].count++;
        isHave = true;
      }
      ival++;

    });
    // 如果没有，进行增加
    if(!isHave){
      Map<String, dynamic> newGoods={
        'goodsId':goodsId,
        'goodsName':goodsName,
        'count':count,
        'price':price,
        'images':images
      };
      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));
    }
    // 把字符串进行encode操作
    cartString = json.encode(tempList).toString();
    print(cartString);
    print(cartList.toString());
    prefs.setString('cartInfo', cartString);
    notifyListeners();
  }

  // 清空购物车
  remove() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear()清空键值对
    prefs.remove('cartInfo');
    print('清空完成---------------');
    notifyListeners();
  }

  // 得到购物车中的商品
  getCartInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 获得购物车中的商品，这时候是一个字符串
    cartString = prefs.getString('cartInfo');
    // 把cartList进行初始化，防止数据混乱
    cartList = [];
    // 判断得到的字符串是否有值，如果不判断会报错
    if(cartString==null){
      cartList =[];
    }else{
      List<Map> tempList = (json.decode(cartString.toString())as List).cast();
      tempList.forEach((item){
        cartList.add(CartInfoModel.fromJson(item));
      });
    }

    notifyListeners();
  }
}