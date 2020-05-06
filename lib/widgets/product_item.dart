import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final scaffold = Scaffold.of(context);
    final product = Provider.of<Product>(
      context,
    );
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ProductDetailsScreen(),
                  settings: RouteSettings(arguments: product.id)));
            },
            child: Hero(
              tag: product.id,
                          child: FadeInImage(
                placeholder: AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
              //child here in the args does't rebuilds
              builder: (ctx, product, child) => IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () async {
                      try {
                        await product.toggleFavoriteStatus(
                            auth.token, auth.userId);
                      } catch (error) {
                        scaffold.hideCurrentSnackBar();
                        scaffold.showSnackBar(SnackBar(
                          content: Text(error.toString()),
                        ));
                      }
                    },
                    color: Theme.of(context).accentColor,
                  )),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).removeCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Item is added'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
                duration: Duration(seconds: 1),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
