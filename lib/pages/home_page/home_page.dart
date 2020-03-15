import 'dart:convert';
import 'package:flutter/material.dart';
import '../../service/service_method.dart';
import 'swiper_widget.dart';
import 'topnavigator_widget.dart';
import 'ad_banner.dart';
import 'leader_phone.dart';
import 'shop_recommend.dart';
import 'floor_content.dart';
import 'floor_title.dart';
import 'hotgoods_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据';

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('商城'),
        ),
        body: FutureBuilder(
            future: request('homePageContext',
                formData: {'lon': '115.02932', 'lat': '35.76189'}),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = json.decode(snapshot.data.toString());
                List<Map> swiperDataList =
                    (data['data']['slides'] as List).cast(); // 顶部轮播组件数
                List<Map> navigatorList =
                    (data['data']['category'] as List).cast(); //类别列表
                String advertesPicture =
                    data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
                String leaderImage =
                    data['data']['shopInfo']['leaderImage']; //店长图片
                String leaderPhone =
                    data['data']['shopInfo']['leaderPhone']; //店长电话
                List<Map> recommendList =
                    (data['data']['recommend'] as List).cast(); // 商品推荐
                String floor1Title =
                    data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
                String floor2Title =
                    data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
                String floor3Title =
                    data['data']['floor3Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
                List<Map> floor1 =
                    (data['data']['floor1'] as List).cast(); //楼层1商品和图片
                List<Map> floor2 =
                    (data['data']['floor2'] as List).cast(); //楼层1商品和图片
                List<Map> floor3 =
                    (data['data']['floor3'] as List).cast(); //楼层1商品和图片
                return EasyRefresh(
                  refreshFooter: ClassicsFooter(
                      key: _footerKey,
                      bgColor: Colors.white,
                      textColor: Colors.pink,
                      moreInfoColor: Colors.pink,
                      showMore: true,
                      noMoreText: '',
                      moreInfo: '加载中',
                      loadReadyText: '上拉加载....'),
                  child: ListView(
                    children: <Widget>[
                      SwiperDiy(swiperDataList: swiperDataList), // 页面顶部轮播插件
                      TopNavigator(navigatorList: navigatorList), // 导航插件
                      AdBanner(advertesPicture: advertesPicture), // 横幅广告
                      LeaderPhone(
                          leaderImage: leaderImage, leaderPhone: leaderPhone),
                      //广告组件
                      Recommend(
                        recommendList: recommendList,
                      ),
                      FloorTitle(pictureAaddress: floor1Title),
                      FloorContent(floorGoodsList: floor1),
                      FloorTitle(pictureAaddress: floor2Title),
                      FloorContent(floorGoodsList: floor2),
                      FloorTitle(pictureAaddress: floor3Title),
                      FloorContent(floorGoodsList: floor3),
//                      HotGoods()
                    _hotGoods()
                    ],
                  ),
                  loadMore: () async {
                    print('开始加载更多');
                    var formPage = {'page': page};
                    await request('homePageBelowConten', formData: formPage)
                        .then((val) {
                      var data = json.decode(val.toString());
                      List<Map> newGoodsList = (data['data'] as List).cast();
                      setState(() {
                        hotGoodsList.addAll(newGoodsList);
                        page++;
                      });
                    });
                  },
                );
              } else {
                return Center(
                  child: Text('加载中'),
                );
              }
            }));
  }






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
          onTap: (){

            // 使用静态路由进行跳转
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
          },
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
                  style: TextStyle(color:Colors.pink,fontSize: ScreenUtil().setSp(35)),),
                Row(
                  children: <Widget>[
                    Text('¥${val['mallPrice']}', style: TextStyle(fontSize: ScreenUtil().setSp(37)),),
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

// 每次书写前先进行接口调试

//class HotGoods extends StatefulWidget {
//  @override
//  _HotGoodsState createState() => _HotGoodsState();
//}
//
//class _HotGoodsState extends State<HotGoods> {
//
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//
//    request('homePageBelowConten').then((val){
//      print(val);
//      print('获取成功');
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Text('jiekou'),
//    );
//  }
//}
