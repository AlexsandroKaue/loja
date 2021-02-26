import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_drawer.dart';
import 'package:lojavirtualv2/models/page_manager.dart';
import 'package:lojavirtualv2/models/user_manager.dart';
import 'package:lojavirtualv2/screens/admin_users/admin_users_screen.dart';
import 'package:lojavirtualv2/screens/cart/components/cart_button.dart';
import 'package:lojavirtualv2/screens/home/home_screen.dart';
import 'package:lojavirtualv2/screens/login_screen.dart';
import 'package:lojavirtualv2/screens/products/product_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ProductScreen(),
              Scaffold(
                appBar: AppBar(
                  title: const Text('Home3'),
                  centerTitle: true,
                ),
                drawer: CustomDrawer(),
              ),
              Scaffold(
                appBar: AppBar(
                  title: const Text('Home4'),
                  centerTitle: true,
                ),
                drawer: CustomDrawer(),
              ),
              if(userManager.adminEnabled)
                //a notação ... permite adicionar uma sublista a outra
                // e podemos condicionar em um if
                ...[
                  AdminUsersScreen(),
                  Scaffold(
                    appBar: AppBar(
                      title: const Text('Pedidos'),
                      centerTitle: true,
                    ),
                    drawer: CustomDrawer(),
                  )
                ]
            ],
          );
        } ,
      ),
    );
  }
}
