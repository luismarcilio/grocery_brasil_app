import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc_backup/purchase_bloc.dart';
import '../domain/Purchase.dart';
import '../features/purchase/presentation/widgets/NFScreensWidgets.dart';
import '../services/PurchaseRepository.dart';
import 'common/loading.dart';

class FullFiscalNoteScreen extends StatelessWidget {
  final String _docId;

  FullFiscalNoteScreen(this._docId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PurchaseBloc>(
      create: (context) => PurchaseBloc(FirestorePurchaseRepository()),
      child: PurchaseFullFiscalNoteScreen(_docId),
    );
  }
}

class PurchaseFullFiscalNoteScreen extends StatelessWidget {
  final String _docId;

  PurchaseFullFiscalNoteScreen(this._docId);

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
        } else if (state is PurchaseInitial) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        } else if (state is PurchaseResumeLoaded) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state) {
        if (state is PurchaseLoading) {
          return Loading();
        } else if (state is PurchaseLoaded) {
          return BuildPurchaseScreen(state.purchase);
        } else {
          BlocProvider.of<PurchaseBloc>(context)
              .add(LoadPurchaseByAccessKey(_docId));

          return Loading();
        }
      },
    );
  }
}

class BuildPurchaseScreen extends StatelessWidget {
  final Purchase _purchase;
  BuildPurchaseScreen(this._purchase);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: NFScreensWidgets.resumoNfCard(
                purchase: _purchase,
                context: context,
                onTap: null,
                onLongPress: null)),
        body: ListView(
          children: _purchase.purchaseItemList
              .map<Widget>((purchaseItem) => NFScreensWidgets.newnfItemCard(
                  context: context,
                  onLongPress: null,
                  onTap: null,
                  purchaseItem: purchaseItem))
              .toList(),
        ));
  }
}
