import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/cart.dart';
import './provider/auth.dart';
import './provider/order.dart';
import './provider/products.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';
import './screens/order_screen.dart';
import './screens/splash_screen.dart';
import 'screens/user_product_screen.dart';
import 'screens/edit_product_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, auth, preriousProducts) => Products(
              auth.token.toString(),
              auth.userId,
              preriousProducts == null ? [] : preriousProducts.items),
          create: (_) => Products('', '', []),
        ),
        // ChangeNotifierProxyProvider<Auth, Products>(
        // update: (ctx, auth, previouetoken) => Products(auth.token),
        // ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => Orders(),
        // ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, preriousOrders) => Orders(
              auth.token.toString(),
              auth.userId.toString(),
              preriousOrders == null ? [] : preriousOrders.orders),
          create: (_) => Orders('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.grey,
            scaffoldBackgroundColor: const Color.fromARGB(255, 216, 215, 215),
            fontFamily: 'VarelaRound',
          ),
          debugShowCheckedModeBanner: false,
          title: 'Shopify',
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
