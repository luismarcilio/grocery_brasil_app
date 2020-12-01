import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../domain/ProductSearchModel.dart';
import '../bloc/products_bloc.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductsBloc>(),
      child: BuildProductsScreen(),
    );
  }
}

class BuildProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [SearchTextForm(), Expanded(child: BuildResultsTable())],
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class SearchTextForm extends StatelessWidget {
  final Debouncer debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (text) => debouncer.run(() =>
            BlocProvider.of<ProductsBloc>(context)
                .add(SearchProductsByText(text))),
        decoration: InputDecoration(
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
            hintText: 'Nome do produto',
            prefixIcon: Icon(Icons.local_grocery_store_rounded)),
        controller: controller,
      ),
    );
  }
}

// class ResultsTable extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => sl<ProductsBloc>(),
//       child: BuildResultsTable(),
//     );
//   }
// }

class BuildResultsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
      if (state is ProductError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(state.failure.toString()),
          ),
        );
      }
    }, builder: (context, state) {
      if (state is ProductsSearching) {
        return Loading();
      } else if (state is ProductsTextAvailable) {
        return BuildProductsTable(products: state.products);
      }
      return Container();
    });
  }
}

class BuildProductsTable extends StatelessWidget {
  final List<ProductSearchModel> products;

  const BuildProductsTable({Key key, this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List<Widget>.of(
            products.map((product) => ProductCard(product: product))).toList());
  }
}

class ProductCard extends StatelessWidget {
  final ProductSearchModel product;
  final Function onTap;
  final Function onLongPress;

  const ProductCard({Key key, this.product, this.onTap, this.onLongPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("product: $product");
    return Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: product.thumbnail == null
                      ? Icon(Icons.shopping_cart)
                      : Image.network(product.thumbnail),
                  title: new Text(product.name),
                  trailing: new Text("R\$ 15,12"),
                  subtitle:
                      new Text(product.unity != null ? product.unity.name : ''),
                  onTap: onTap,
                  onLongPress: onLongPress,
                ),
                ListTile(
                  title: new Text('ZEBU CARNES SUPERMERCADOS LTDA'),
                  subtitle: new Text(
                      "Avenida da Saudade, 1110, Santa Marta, Uberaba"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MoreItemsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(child: Icon(Icons.share)),
        const PopupMenuItem(child: Icon(Icons.delete)),
      ],
    );
  }
}
