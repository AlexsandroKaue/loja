import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final int page;
  const DrawerTile({this.iconData, this.title, this.page});

  @override
  Widget build(BuildContext context) {

    final int curPage = context.watch<PageManager>().page;
    final Color color = Theme.of(context).primaryColor;
    return InkWell(
      onTap: (){
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Icon(
                iconData,
                size: 32,
                color: curPage == page ? color : Colors.grey[700],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: curPage == page ? color: Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}
