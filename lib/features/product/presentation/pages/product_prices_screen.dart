import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../../admob/domain/AddFactory.dart';
import '../../../admob/domain/DecorateListWithAds.dart';
import '../../../admob/widgets/BannerInline.dart';
import '../../../share/domain/Shareable.dart';
import '../../../share/domain/ShareableConverter.dart';
import '../../../share/presentation/pages/share.dart';
import '../../domain/ProductPrices.dart';
import '../../domain/ProductSearchModel.dart';
import '../bloc/product_prices_bloc.dart';
import '../bloc/products_bloc.dart';

class ProductPricesScreen extends StatelessWidget {
  final ProductSearchModel product;

  const ProductPricesScreen({Key key, @required this.product})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductPricesBloc>(),
      child: BuildProductsPricesScreen(product: product),
    );
  }
}

class BuildProductsPricesScreen extends StatelessWidget {
  final ProductSearchModel product;

  const BuildProductsPricesScreen({Key key, @required this.product})
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
      if (state is ProductsSearching) {
        return Loading();
      } else if (state is ProductPricesAvailable) {
        return BuildProductsPricesTable(
            product: product, products: state.productPrices);
      } else if (state is ProductPricesInitial) {
        BlocProvider.of<ProductPricesBloc>(context)
            .add(GetProductPrices(productId: product.productId));
      }
      return Loading();
    });
  }
}

class BuildProductsPricesTable extends StatelessWidget {
  final ProductSearchModel product;
  final Stream<List<ProductPrices>> products;

  const BuildProductsPricesTable({Key key, this.product, this.products})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DecorateListWithAds _adDecorator =
        sl<DecorateListWithAds<Widget, BannerAdd>>();
    final AddFactory _addFactory = sl<AddFactory<BannerInline>>();
    final frequency = 10;
    return Scaffold(
        appBar: AppBar(
          title: productCard(
            context: context,
            product: product,
          ),
        ),
        body: StreamBuilder<List<ProductPrices>>(
            stream: products,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: _adDecorator.decorate(
                      snapshot.data
                          .map((productPrice) => Container(
                                child: priceCard(
                                    context: context,
                                    productPrices: productPrice),
                              ))
                          .toList(),
                      _addFactory,
                      frequency),
                );
              } else if (snapshot.hasError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(new SnackBar(content: Text(snapshot.error)));
              }
              return Loading();
            }));
  }

  Card productCard(
      {BuildContext context,
      ProductSearchModel product,
      Function onTap,
      Function onLongPress}) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              leading: product.thumbnail == null
                  ? Icon(Icons.shopping_cart)
                  : Image.network(product.thumbnail),
              title: new Text(product.name),
              subtitle: new Text("${product.unity.name} "),
              onTap: onTap,
              onLongPress: onLongPress,
            ),
          ),
        ],
      ),
    );
  }

  Card priceCard(
      {BuildContext context,
      ProductPrices productPrices,
      Function onTap,
      Function onLongPress}) {
    return Card(
      child: ListTile(
        leading: _shareButton(context: context, productPrices: productPrices),
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
      ),
    );
  }

  TextButton _shareButton(
      {@required BuildContext context, @required ProductPrices productPrices}) {
    ShareableConverter converter = ProductPricesConverter();
    ProductPricesConverterInput productPricesConverterInput =
        ProductPricesConverterInput(
      productPrices: productPrices,
      product: product,
    );
    Shareable shareable = converter.convert(productPricesConverterInput);
    return TextButton(
      onPressed: () async {
        await Navigator.push<Share>(
          context,
          MaterialPageRoute(
            builder: (context) => Share(
              shareable: shareable,
            ),
          ),
        );
      },
      child: Icon(Icons.share),
    );
  }
}
