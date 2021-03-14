import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/admin_users_manager.dart';
import 'package:lojavirtualv2/models/cart_manager.dart';
import 'package:lojavirtualv2/models/home_manager.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/models/product_manager.dart';
import 'package:lojavirtualv2/screens/address/address_screen.dart';
import 'package:lojavirtualv2/screens/base_screen.dart';
import 'package:lojavirtualv2/screens/cart/cart_screen.dart';
import 'package:lojavirtualv2/screens/edit_product/edit_product_screen.dart';
import 'package:lojavirtualv2/screens/login_screen.dart';
import 'package:lojavirtualv2/screens/products/product_details_screen.dart';
import 'package:lojavirtualv2/screens/select_product/select_product_screen.dart';
import 'package:lojavirtualv2/screens/signup_screen.dart';
import 'package:provider/provider.dart';

import 'models/user_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  /*CepAbertoService().getAddressFromCep('61.925-560')
      .then((address) => print(address));*/
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          update: (_, userManager, cartManager)
            => cartManager..updateUser(userManager),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          update: (_, userManager, adminUsersManager)
            => adminUsersManager..updateUser(userManager),
          lazy: false
        )
      ],
      child: MaterialApp(
        title: 'Loja do Kauê',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(
            elevation: 0
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (setting){
          switch(setting.name){
            case '/product-details':
              return MaterialPageRoute(
                  builder: (_)
                    => ProductDetailsScreen(setting.arguments as Product)
              );
            case '/cart':
              return MaterialPageRoute(
                  builder: (_)
                  => CartScreen()
              );
            case '/address':
              return MaterialPageRoute(
                  builder: (_)
                    => AddressScreen()
              );
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen()
              );
            case '/edit-product':
              return MaterialPageRoute(
                  builder: (_)
                    => EditProductScreen(setting.arguments as Product),
              );
            case '/select-product':
              return MaterialPageRoute(
                builder: (_)
                => SelectProductScreen(),
              );
            case '/base':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen()
              );
          }
        },
      ),
    );
  }
}

/*await Firebase.initializeApp();

  FirebaseFirestore.instance.collection("names").add({
    "name": "Daniel"
  });

  final DocumentSnapshot document = await FirebaseFirestore.instance.collection("names")
      .doc('9Q7LyDb9rhcRwYt7Y9ke').get();

  final QuerySnapshot query = await FirebaseFirestore.instance.collection("names").get();
  for(final DocumentSnapshot doc in query.docs){
    debugPrint(doc.data().toString());
  }

  debugPrint(document.data().toString());

  FirebaseFirestore.instance.collection("names")
      .doc('9Q7LyDb9rhcRwYt7Y9ke').snapshots().listen((doc) {
        debugPrint(doc.data().toString());
  });

  FirebaseFirestore.instance.collection("names").snapshots().listen((query) {
    for(DocumentSnapshot doc in query.docs) {
      debugPrint(doc.data().toString());
    }
 });*/