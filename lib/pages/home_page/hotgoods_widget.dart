import 'dart:convert';

import 'package:flutter/material.dart';
import '../../service/service_method.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotGoods extends StatefulWidget {

  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {

//  int page = 1;
  List<Map> hotGoodsList=[];

//  @override
//  void initState() {
////    _getHotGoods();
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _hotGoods(),
    );
  }

//  // 火爆商品接口
//  void _getHotGoods(){
//    var formPage={'page': page};
//    request('homePageBelowConten', formData: formPage).then((val){
//      var data = json.decode(val.toString());
//      List<Map> newGoodsList = (data['data'] as List).cast();
//      setState(() {
//        hotGoodsList.addAll(newGoodsList);
//        page++;
//      });
//    });
//  }

  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),

    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 0.5, color: Colors.black12)
      )
    ),
    child: Text('火爆专区'),
  );

  // 火爆专区子项
  Widget _wrapList(){
    if(hotGoodsList.length!=0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){print('点击了火爆专区商品');},
          child: Container(
            width: ScreenUtil().setWidth(530),
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(540),),
                Text(val['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color:Colors.pink,fontSize: ScreenUtil().setSp(26)),),
                Row(
                  children: <Widget>[
                    Text('¥${val['mallPrice']}'),
                    Text('¥${val['price']}',style: TextStyle(color:Colors.black26,decoration: TextDecoration.lineThrough),),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    }else{
      return Text('');
    }
  }

  // 火爆专区组合
  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }
}


