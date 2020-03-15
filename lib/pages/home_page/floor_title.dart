import 'package:flutter/material.dart';

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String pictureAaddress;
  FloorTitle({Key key, this.pictureAaddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Image.network(pictureAaddress),
    );
  }
}
