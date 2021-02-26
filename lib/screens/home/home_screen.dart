import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_drawer.dart';
import 'package:lojavirtualv2/models/home_manager.dart';
import 'package:lojavirtualv2/screens/home/components/section_list.dart';
import 'package:lojavirtualv2/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 118, 130),
                  Color.fromARGB(255, 253, 181, 168),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
             SliverAppBar(
               snap: true,
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja do Kauê'),
                  centerTitle: true,
                ),
               backgroundColor: Colors.transparent,
               elevation: 0,
               actions: [
                 IconButton(
                   icon: const Icon(Icons.shopping_cart),
                   onPressed: (){
                     Navigator.of(context).pushNamed('/cart');
                   }
                 )
               ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManger, __){
                  final List<Widget> children = homeManger.sections
                      .map<Widget>((section) {
                        switch(section.type) {
                          case 'List':
                            return SectionList(section);
                          case 'Staggered':
                            return SectionStaggered(section);
                          default:
                            return Container();
                        }
                  }).toList();

                  return SliverList(
                    delegate: SliverChildListDelegate(children)
                  );
                })
            ],
          ),
        ],
      ),
    );
  }
}
