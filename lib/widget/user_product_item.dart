import 'package:flutter/material.dart';
import 'package:sopping_app/models/htttp_exception.dart';
import './/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;

  UserProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Colors.grey,
            ),
            IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  } catch (error) {
                    // ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    scaffold.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Deleting Failed',
                          textAlign: TextAlign.center,
                        ),
                        // duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
