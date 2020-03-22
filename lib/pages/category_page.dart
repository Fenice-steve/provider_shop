import 'package:flutter/material.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_shop/model/categoryModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/model/categoryGoodsListModel.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategoryNav(), CategoryGoodsList()],
            )
          ],
        ),
      ),
    );
  }
}

// 左侧导航菜单
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0; // 索引

  @override
  void initState() {
    _getCategory();
    _getGoodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180.0),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _leftInkWell(index);
          }),
    );
  }

  // 左侧大类的子项编写
  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });

        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        _getGoodList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100.0),
        padding: EdgeInsets.only(left: 10.0, top: 20.0),
        decoration: BoxDecoration(
//            color: Colors.white,
//            color: isClick ? Colors.black26 : Colors.white,
            color: isClick ? Color.fromRGBO(236, 238, 239, 1) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28.0)),
        ),
      ),
    );
  }

  // 得到后台大类数据
  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);

      setState(() {
        list = category.data;
      });

      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);

//      print(list[0].bxMallSubDto);
//      list[0].bxMallSubDto.forEach((item) => print(item.mallSubName));
    });
  }

  // 得到商品列表数据
  void _getGoodList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsList.data);
//      setState(() {
//        list = goodsList.data;
//      });
//      print('分类商品列表：>>>>>>>>>>>>>>${list[0].goodsName}');
    });
  }
}

// 右侧小类类别
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
//  List list = ['名酒', '宝丰', '北京二锅头'];

  @override
  Widget build(BuildContext context) {
    return Container(child: Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: childCategory.childCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWell(
                    index, childCategory.childCategoryList[index]);
              }),
        );
      },
    ));
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isCheck = false;
    isCheck = (index == Provide.value<ChildCategory>(context).childIndex)
        ? true
        : false;

    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodList(item.mallSubId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isCheck ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  // 得到商品列表数据
  void _getGoodList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);

      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getGoodsList(goodsList.data);
      }
//      setState(() {
//        list = goodsList.data;
//      });
//      print('分类商品列表：>>>>>>>>>>>>>>${list[0].goodsName}');
    });
  }
}

// 商品列表，可以上拉加载
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();

//  List list = [];

//  @override
//  void initState() {
//    // TODO: implement initState
//    _getGoodList();
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(builder: (context, child, data) {
      try {
        if (Provide.value<ChildCategory>(context).page == 1) {
          scrollController.jumpTo(0);
        }
      } catch (e) {
        print('进入页面第一次初始化: ${e}');
      }
      if (data.goodsList.length > 0) {
        return Expanded(
            child: Container(
          width: ScreenUtil().setWidth(570),
          child: EasyRefresh(
            refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                moreInfo: '加载中',
                loadReadyText: '上拉加载'),
            child: ListView.builder(
                controller: scrollController,
                itemCount: data.goodsList.length,
                itemBuilder: (context, index) {
                  return _ListWidget(data.goodsList, index);
                }),
            loadMore: () async {
              if (Provide.value<ChildCategory>(context).noMoreText == '没有更多了') {
                Fluttertoast.showToast(
                    msg: "已经到底了",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.pink,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                _getMoreList();
              }
            },
          ),
        ));
      } else {
        return Text('暂时没有数据');
      }
    });
  }

  // 商品图片
  Widget _goodsImage(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  // 商品名称
  Widget _goodsName(List newList, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(33)),
      ),
    );
  }

  // 商品价格
  Widget _goodsPrice(List newList, index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格:¥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(33)),
          ),
          Text(
            '¥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  // 结合起来
  Widget _ListWidget(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }

  // 上拉加载更多的方法
  void _getMoreList() {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };
    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);

      if (goodsList.data == null) {
        Provide.value<ChildCategory>(context).changeNoMore('没有更多了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .addGoodsList(goodsList.data);
      }
//      setState(() {
//        list = goodsList.data;
//      });
//      print('分类商品列表：>>>>>>>>>>>>>>${list[0].goodsName}');
    });
  }
}
