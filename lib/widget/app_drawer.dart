import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopping_app/provider/auth.dart';
import 'package:sopping_app/screens/order_screen.dart';
import 'package:sopping_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('sopify'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Order'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Your order'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductScreen.routeName);

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
