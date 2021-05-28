import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/UserMessaging.dart';
import '../../../../domain/Product.dart';
import '../../../../domain/Purchase.dart';
import '../../../../domain/PurchaseItem.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../../admob/domain/AddFactory.dart';
import '../../../admob/domain/DecorateListWithAds.dart';
import '../../../admob/widgets/BannerInline.dart';
import '../../../product/domain/ProductSearchModel.dart';
import '../../../product/presentation/pages/product_prices_screen.dart';
import '../bloc/purchase_bloc.dart';
import '../widgets/NFScreensWidgets.dart';

class FullPurchaseList extends StatelessWidget {
  final String purchaseId;

  FullPurchaseList({@required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PurchaseBloc>(
      create: (_) => sl<PurchaseBloc>(),
      child: PurchaseFullFiscalNoteScreen(purchaseId: purchaseId),
    );
  }
}

class PurchaseFullFiscalNoteScreen extends StatelessWidget {
  final String purchaseId;

  PurchaseFullFiscalNoteScreen({@required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseBloc, PurchaseState>(
      listener: (context, state) {
        print("listener PurchaseState: $state");
        if (state is PurchaseError) {
          showErrorWidget(failure: state.purchaseFailure, context: context);
        } else if (state is PurchaseInitial) {
          BlocProvider.of<PurchaseBloc>(context)
              .add(GetPurchaseByIdEvent(purchaseId: purchaseId));
        }
      },
      builder: (context, state) {
        print("builder PurchaseState: $state");

        if (state is PurchaseLoading) {
          return Loading();
        } else if (state is PurchaseRetrieved) {
          return BuildPurchaseScreen(state.purchase);
        } else if (state is PurchaseInitial) {
          BlocProvider.of<PurchaseBloc>(context)
              .add(GetPurchaseByIdEvent(purchaseId: purchaseId));
          return Loading();
        } else {
          return Loading();
        }
      },
    );
  }
}

class BuildPurchaseScreen extends StatelessWidget {
  final Purchase _purchase;
  BuildPurchaseScreen(this._purchase);
  final DecorateListWithAds _adDecorator =
      sl<DecorateListWithAds<Widget, BannerAdd>>();
  final AddFactory _addFactory = sl<AddFactory<BannerInline>>();
  static final frequency = 10;
  @override
  Widget build(BuildContext context) {
    final NFScreensWidgets nFScreensWidgets =
        NFScreensWidgets(context: context, purchase: _purchase);
    return Scaffold(
      appBar: AppBar(
          title: nFScreensWidgets.appbarTitle(onTap: null, onLongPress: null)),
      body: ListView(
        children: _adDecorator.decorate(
            _purchase.purchaseItemList
                .map<Widget>((purchaseItem) => nFScreensWidgets.newnfItemCard(
                    onLongPress: null,
                    onTap: () {
                      _loadProductPricesScreen(
                        context: context,
                        purchaseItem: purchaseItem,
                      );
                    },
                    purchaseItem: purchaseItem))
                .toList(),
            _addFactory,
            frequency),
      ),
    );
  }

  _loadProductPricesScreen(
      {@required BuildContext context, @required PurchaseItem purchaseItem}) {
    final ProductSearchModel productSearch = ProductSearchModel(
        productId: purchaseItem.product.productId == null ||
                purchaseItem.product.productId.length == 0
            ? _getProductId(purchaseItem.product)
            : purchaseItem.product.productId,
        name: purchaseItem.product.name,
        eanCode: purchaseItem.product.eanCode,
        ncmCode: purchaseItem.product.ncmCode,
        normalized: purchaseItem.product.normalized,
        thumbnail: purchaseItem.product.thumbnail,
        unity: purchaseItem.product.unity);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductPricesScreen(
          product: productSearch,
        ),
      ),
    );
  }

  _getProductId(Product product) {
// FIXME: Duplicated code with back end

    // getDocId(product: Product): string {
    //   const normalizedItemName = product.name.replace(/[^a-zA-Z0-9]+/g, "-");
    //   const productDocId = !product.eanCode
    //     ? product.ncmCode + "-" + normalizedItemName
    //     : product.eanCode;
    //   return productDocId;
    // }

    final normalizedItemName =
        product.name.replaceAllMapped(RegExp(r'[^a-zA-Z0-9]+'), (match) => '-');
    final productDocId = product.eanCode == null || product.eanCode.length == 0
        ? product.ncmCode + '-' + normalizedItemName
        : product.eanCode;
    return productDocId;
  }
}

class ProductPricesScreenTest extends StatelessWidget {
  final Product product;
  final ProductSearchModel productSearch;

  const ProductPricesScreenTest({Key key, this.product, this.productSearch})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Text('ProductPricesScreenTest'),
      ),
    );
  }
}
