import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/UserMessaging.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../../admob/domain/AddFactory.dart';
import '../../../admob/domain/DecorateListWithAds.dart';
import '../../../admob/widgets/BannerInline.dart';
import '../../domain/ProductPrices.dart';
import '../../domain/ProductSearchModel.dart';
import '../bloc/product_prices_bloc.dart';
import '../bloc/products_bloc.dart';
import '../widgets/PriceTag.dart';
import 'product_prices_screen.dart';

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
        onChanged: (text) => debouncer.run(() {
          if (text.trim().length > 0) {
            BlocProvider.of<ProductsBloc>(context)
                .add(SearchProductsByText(text));
          }
        }),
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
        showErrorWidget(failure: state.failure, context: context);
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
    final DecorateListWithAds _adDecorator =
        sl<DecorateListWithAds<Widget, BannerAdd>>();
    final AddFactory _addFactory = sl<AddFactory<BannerInline>>();
    final frequency = 10;

    return ListView(
      children: _adDecorator.decorate(
          List<Widget>.of(
                  products.map((product) => ProductCard(product: product)))
              .toList(),
          _addFactory,
          frequency),
    );
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
      child: InkWell(
        onTap: () => _loadListOfPrices(context, product),
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
                    trailing: new Text(
                        product.unity != null ? product.unity.name : ''),
                    onTap: onTap,
                    onLongPress: onLongPress,
                  ),
                  MinimumPriceListTile(productId: product.productId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadListOfPrices(BuildContext context, ProductSearchModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductPricesScreen(product: product),
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
        showErrorWidget(failure: state.productFailure, context: context);
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

  Widget _minimumPricesWidget(ProductPrices productPrices) {
    return ListTile(
      isThreeLine: true,
      dense: true,
      title: new Text(productPrices.company.name),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          priceTag(
              amount: productPrices.unityValue,
              discount: productPrices.discount),
          new Text(DateFormat('d/M/y').format(productPrices.date),
              style: TextStyle(fontSize: 12))
        ],
      ),
      subtitle: new Text(
          '${productPrices.company.address.street},${productPrices.company.address.number} , ${productPrices.company.address.county}, ${productPrices.company.address.city.name}'),
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
