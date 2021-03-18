import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductPrices.dart';
import 'package:grocery_brasil_app/features/product/presentation/bloc/product_prices_bloc.dart';
import 'package:intl/intl.dart';

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

class BuildResultsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
      if (state is ProductError) {
        ScaffoldMessenger.of(context).showSnackBar(
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
                  trailing:
                      new Text(product.unity != null ? product.unity.name : ''),
                  onTap: onTap,
                  onLongPress: onLongPress,
                ),
                MinimumPriceListTile(productId: product.productId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MinimumPriceListTile extends StatelessWidget {
  final String productId;

  const MinimumPriceListTile({Key key, @required this.productId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductPricesBloc>(),
      child: BuildMinimumPriceListTile(productId: productId),
    );
  }
}

class BuildMinimumPriceListTile extends StatelessWidget {
  final String productId;

  const BuildMinimumPriceListTile({Key key, @required this.productId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductPricesBloc, ProductPricesState>(
        listener: (context, state) {
      if (state is ProductPricesError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.productFailure.toString()),
          ),
        );
      }
    }, builder: (context, state) {
      if (state is ProductPricesSearching) {
        return Container();
      } else if (state is MininumProductPriceAvailable) {
        print("productPrices: ${state.productPrices}");
        return _minimumPricesWidget(state.productPrices);
      } else if (state is ProductPricesInitial) {
        BlocProvider.of<ProductPricesBloc>(context)
            .add(GetMininumProductPriceAvailable(productId: productId));
      }
      return Container();
    });
  }

  Widget _minimumPricesWidget(ProductPrices productPrices) => ListTile(
        isThreeLine: false,
        dense: true,
        title: new Text(productPrices.company.name),
        trailing: Column(
          children: [
            new Text("R\$ ${productPrices.unityValue}"),
            new Text(DateFormat('d/M/y').format(productPrices.date))
          ],
        ),
        subtitle: new Text(
            '${productPrices.company.address.street},${productPrices.company.address.number} , ${productPrices.company.address.county}, ${productPrices.company.address.city.name}'),
      );
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
