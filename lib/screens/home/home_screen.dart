import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_drawer.dart';
import 'package:lojavirtualv2/models/home_manager.dart';
import 'package:lojavirtualv2/models/user_manager.dart';
import 'package:lojavirtualv2/screens/home/components/add_section_widget.dart';
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
                 ),
                 Consumer2<UserManager, HomeManager>(
                   builder: (_, userManager, homeManager, __){
                     if(userManager.adminEnabled && !homeManager.loading) {
                       if(homeManager.editing) {
                         return PopupMenuButton(
                           onSelected: (value){
                             if(value == 'Salvar') {
                               homeManager.saveEditing();
                             } else {
                               homeManager.discardEditing();
                             }
                           },
                           itemBuilder: (_) {
                             return ['Salvar', 'Descartar'].map((e){
                                return PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                             }).toList();
                           }
                         );
                       } else {
                         return IconButton(
                             icon: const Icon(Icons.edit),
                             onPressed: homeManager.enterEditing
                         );
                       }
                     } else {
                       return Container();
                     }
                   },
                 )
               ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __){
                  if(homeManager.loading) {
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }

                  final List<Widget> children = homeManager.sections
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

                  if(homeManager.editing) {
                    children.add(AddSectionWidget(homeManager));
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate(children)
                  );
                }
              ),

            ],
          ),
        ],
      ),
    );
  }
}
