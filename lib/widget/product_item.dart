import 'package:flutter/material.dart';
import '../provider/auth.dart';
import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    // print('heart is pressed');
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/cloth.png'),
              image: NetworkImage(
                product.imageUrl.toString(),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
              ),
              onPressed: () {
                product.toggleFavouriteStatus(
                    authData.token.toString(), authData.userId.toString());
                print(authData.userId);
              },
            ),
          ),
          title: Text(
            product.title.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'VarelaRound'),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.redAccent,
            ),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Added item to cart!',
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.red,
                    onPressed: () {
                      cart.removeSingleItem(product.id.toString());
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}



// InkWell(
    //   onTap: () {},
    //   splashColor: Colors.white,
    //   borderRadius: BorderRadius.circular(20),
    //   child: Stack(
    //     children: [
    //       ClipRRect(
    //         borderRadius: BorderRadius.circular(20),
    //         child: Image.network(
    //           imageUrl,
    //           height: double.infinity,
    //           width: double.infinity,
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ],
    //   ),
    // );