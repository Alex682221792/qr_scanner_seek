import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner_app/domain/entities/history_item.dart';

class HistoryItemWidget extends StatelessWidget {
  final HistoryItem detail;

  HistoryItemWidget(this.detail);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      height: 100,
      color: Colors.white,
      child: Row(
        children: [
          ColoredBox(
            color: randomColor(),
            child: SizedBox(height: 100, width: 10),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.7,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.data,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.black
                  ),
                ),
                Text(detail.shortDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  )
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(onPressed: () async {
            await Clipboard.setData(ClipboardData(text: detail.data));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Texto copiado a portapapeles")));
          }, icon: Icon(Icons.copy, size: 32.0)),
        ],
      ),
    );
  }

  Color randomColor() {
    return Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));
  }
}
