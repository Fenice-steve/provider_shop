import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/cart.dart';
import 'package:provide/provide.dart';

/// 底部结算栏
class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: <Widget>[
          selectAllButton(context),
          allPriceArea(context),
          goButton(context)
        ],
      ),
    );
  }

  // 全选按钮
  Widget selectAllButton(context) {
    bool isAllCheck = Provide.value<CartProvide>(context).isAllCheck;

    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
              value: isAllCheck, activeColor: Colors.red, onChanged: (bool val) {


                Provide.value<CartProvide>(context).changeAllCheckBtnState(val);
          }),
          Text('全选')
        ],
      ),
    );
  }

  // 合计区域
  Widget allPriceArea(context) {
    // 合计金额
    double allPrice = Provide.value<CartProvide>(context).allPrice;

    return Container(
      width: ScreenUtil().setWidth(430),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(280),
                child: Text(
                  '合计',
                  style: TextStyle(fontSize: ScreenUtil().setSp(36)),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(150),
                child: Text(
                  '￥${allPrice}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(36), color: Colors.red),
                ),
              )
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(430),
            alignment: Alignment.centerRight,
            child: Text(
              '满10元免邮费，预购免配送费',
              style: TextStyle(
                  color: Colors.black38, fontSize: ScreenUtil().setSp(22)),
            ),
          )
        ],
      ),
    );
  }

  // 结算按钮
  Widget goButton(context) {
    int allGoodCount = Provide.value<CartProvide>(context).allGoodsCount;

    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(3)),
          child: Text(
            '结算(${allGoodCount})',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
