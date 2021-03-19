import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/Address.dart';
import '../../../../domain/Company.dart';
import '../../../../domain/Location.dart';
import '../../../../domain/Product.dart';
import '../../../../domain/Unity.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
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
      return Text(state.toString());
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
              return ListView(
                children: snapshot.data
                    .map((productPrice) => priceCard(
                        context: context, productPrices: productPrice))
                    .toList(),
              );
            }));
  }
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

final oneProductPrice = ProductPrices(
    product: Product(
        name: 'DETERGENTE LÍQUIDO CLEAR YPÊ FRASCO 500ML',
        eanCode: "7896098900253",
        ncmCode: '34022000',
        unity: Unity(name: 'UN'),
        normalized: true,
        thumbnail:
            'https://storage.googleapis.com/grocery-brasil-app-thumbnails/7896098900253'),
    company: Company(
        name: 'ZEBU CARNES SUPERMERCADOS LTDA',
        taxIdentification: '03.214.362/0003-35',
        address: Address(
            rawAddress:
                'Av. da Saudade, 1110 - Santa Marta, Uberaba - MG, 38061-000, Brasil',
            street: 'Avenida da Saudade',
            number: '1110',
            complement: '',
            poCode: '38061-000',
            county: 'Santa Marta',
            country: Country(name: 'Brasil'),
            state: null,
            city: City(name: 'Uberaba'),
            location: Location(lon: -47.9562274, lat: -19.7433014))),
    unityValue: 15.0,
    date: DateTime.now());

final otherProductPrice = ProductPrices(
    product: Product(
        name: 'DETERGENTE LÍQUIDO CLEAR YPÊ FRASCO 500ML',
        eanCode: "7896098900253",
        ncmCode: '34022000',
        unity: Unity(name: 'UN'),
        normalized: true,
        thumbnail:
            'https://storage.googleapis.com/grocery-brasil-app-thumbnails/7896098900253'),
    company: Company(
        name: 'LS GUARATO LTDA',
        taxIdentification: '19.867.464/0001-28',
        address: Address(
            rawAddress:
                'R. Novo Horizonte, 948 - Irmaos Soares, Uberaba - MG, 38060-480, Brasil',
            street: 'Rua Novo Horizonte',
            number: '948',
            complement: '',
            poCode: '38060-480',
            county: 'Irmaos Soares',
            country: Country(name: 'Brasil'),
            state: null,
            city: City(name: 'Uberaba'),
            location: Location(lon: -47.9478899, lat: -19.7490176))),
    unityValue: 14.0,
    date: DateTime.now());
