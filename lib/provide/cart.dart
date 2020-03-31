import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cartInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 购物车provide
class CartProvide with ChangeNotifier{
  String cartString="[]";

   // 显示购物车列表
  List<CartInfoModel> cartList =[];

  double allPrice = 0;
  int allGoodsCount = 0;

  // 是否全选
  bool isAllCheck = true;

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
        'images':images,
        'isCheck':true
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

      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck = true;

      tempList.forEach((item){

        if(item['isCheck']){
          allPrice+=(item['count']*item['price']);
          allGoodsCount+=item['count'];
        }else{
          isAllCheck=false;
        }

        cartList.add(CartInfoModel.fromJson(item));
      });
    }

    notifyListeners();
  }

  // 删除单个商品
  deleteOneGoods(String goodsId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString())as List).cast();

    int tempIndex = 0;
    int delIndex =0;
    tempList.forEach((item){
      if(item['goodsId'] == goodsId){
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 修改选中状态
  changeCheckState(CartInfoModel cartItem) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString())as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item){
      if(item['goodsId'] == cartItem.goodsId){
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex]=cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

//  //点击全选按钮操作
//  changeAllCheckBtnState(bool isCheck) async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    cartString=prefs.getString('cartInfo');
//    List<Map> tempList= (json.decode(cartString.toString()) as List).cast();
//    List<Map> newList=[]; //新建一个List，用于组成新的持久化数据。
//    for(var item in tempList ){
//      var newItem = item; //复制新的变量，因为Dart不让循环时修改原值
//      newItem['isCheck']=isCheck; //改变选中状态
//      newList.add(newItem);
//    }
//
//    cartString= json.encode(newList).toString();//形成字符串
//    prefs.setString('cartInfo', cartString);//进行持久化
//    await getCartInfo();
//
//  }

    // 点击全选按钮的操作
    changeAllCheckBtnState(bool isCheck) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cartString = prefs.getString('cartInfo');
      List<Map> tempList = (json.decode(cartString.toString())as List).cast();
      List<Map> newList = [];// 新建一个List，用于组成新的持久化数据
      for(var item in tempList){
        var newItem = item; // 复制新的变量，因为Dart不让循环时修改原值
        newItem['isCheck']=isCheck; // 改变选中状态
        newList.add(newItem);
      }

      cartString = json.encode(newList).toString();// 形成字符串
      prefs.setString('cartInfo', cartString);// 进行持久化
      await getCartInfo();
    }

}