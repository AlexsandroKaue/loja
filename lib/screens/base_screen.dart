import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_drawer.dart';
import 'package:lojavirtualv2/models/page_manager.dart';
import 'package:lojavirtualv2/screens/login_screen.dart';
import 'package:lojavirtualv2/screens/products/product_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              centerTitle: true,
            ),
            drawer: CustomDrawer(),
          ),
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
        ],
      ),
    );
  }
}
