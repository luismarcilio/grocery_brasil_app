import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/Purchase.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../../admob/domain/AddFactory.dart';
import '../../../admob/domain/DecorateListWithAds.dart';
import '../../../admob/widgets/BannerInline.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error'),
            ),
          );
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
                    onLongPress: null, onTap: null, purchaseItem: purchaseItem))
                .toList(),
            _addFactory,
            frequency),
      ),
    );
  }
}
