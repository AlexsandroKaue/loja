import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/page_manager.dart';
import 'package:provider/provider.dart';

class BottomTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final int page;
  const BottomTile({this.iconData, this.title, this.page});

  @override
  Widget build(BuildContext context) {
    final int curPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: (){
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Column(
          children: [
            Icon(
              iconData,
              size: 32,
              color: curPage == page ? Colors.red : Colors.grey[700],
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: curPage == page ? Colors.red : Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}
