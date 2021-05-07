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
import 'FullPurchaseList.dart';

class ResumePurchaseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PurchaseBloc>(),
      child: PurchaseResumeScreen(),
    );
  }
}

class PurchaseResumeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseBloc, PurchaseState>(
      listener: (context, state) {
        if (state is PurchaseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PurchaseInitial || state is PurchaseDeleted) {
          BlocProvider.of<PurchaseBloc>(context).add(ListResumeEvent());
        } else if (state is PurchaseLoading) {
          return Loading();
        } else if (state is ResumeListed) {
          return BuildListOfPurchases(state.purchaseStreamList);
        }
        return Loading();
      },
    );
  }
}

class BuildListOfPurchases extends StatelessWidget {
  final Stream<List<Purchase>> _resumes;
  final DecorateListWithAds _adDecorator =
      sl<DecorateListWithAds<Hero, BannerAdd>>();
  final AddFactory _addFactory = sl<AddFactory<BannerInline>>();
  static final frequency = 10;

  BuildListOfPurchases(this._resumes);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: _resumes, builder: _builder);
  }

  Widget _builder(
      BuildContext context, AsyncSnapshot<List<Purchase>> purchases) {
    if (purchases.hasData) {
      return ListView(
          children: _adDecorator.decorate(
              purchases.data.map((purchase) {
                final NFScreensWidgets nFScreensWidgets =
                    NFScreensWidgets(context: context, purchase: purchase);
                return nFScreensWidgets.resumoNfCard(
                    onLongPress: () {},
                    onTap: () => _loadFullPurchase(context, purchase));
              }).toList(),
              _addFactory,
              frequency));
    } else if (purchases.hasError) {
      return Loading();
    } else {
      return Loading();
    }
  }

  void _loadFullPurchase(BuildContext context, Purchase purchase) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            FullPurchaseList(purchaseId: purchase.fiscalNote.accessKey)));
  }
}
