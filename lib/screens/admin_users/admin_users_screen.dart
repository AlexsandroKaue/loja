import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_drawer.dart';
import 'package:lojavirtualv2/models/admin_users_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __) {
          return AlphabetListScrollView(
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(adminUsersManager.users[index].name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800
                  ),
                ),
                subtitle: Text(adminUsersManager.users[index].email,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
            strList: adminUsersManager.names,
            indexedHeight: (index) => 80,
            showPreview: true,
            keyboardUsage: true,
            highlightTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          );
        },
      ),
    );
  }
}
