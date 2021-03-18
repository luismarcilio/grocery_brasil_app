import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_brasil_app/features/purchase/presentation/widgets/NFScreensWidgets.dart';

import '../bloc_backup/purchase_bloc.dart';
import '../domain/Purchase.dart';
import '../services/PurchaseRepository.dart';
import 'FullFiscalNote.dart';
import 'common/loading.dart';

class NotasFiscaisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchaseBloc(FirestorePurchaseRepository()),
      child: PurchaseResumeScreen(),
    );
  }
}

class PurchaseResumeScreen extends StatelessWidget {
  final String _userId = FirebaseAuth.instance.currentUser.uid;

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
        if (state is PurchaseInitial) {
          BlocProvider.of<PurchaseBloc>(context)
              .add(LoadResumePurchaseByUserId(_userId));
          return Loading();
        } else if (state is PurchaseLoading) {
          return Loading();
        } else if (state is PurchaseResumeLoaded) {
          return BuildListOfPurchases(state.resumes);
        } else if (state is PurchaseLoaded) {
          return BuildPurchaseScreen(state.purchase);
        } else {
          return Loading();
        }
      },
    );
  }
}

class BuildListOfPurchases extends StatelessWidget {
  final Stream<List<Purchase>> _resumes;

  BuildListOfPurchases(this._resumes);

  @override
  Widget build(BuildContext context) {
    return Container(child: StreamBuilder(stream: _resumes, builder: _builder));
  }

  Widget _builder(
      BuildContext context, AsyncSnapshot<List<Purchase>> purchases) {
    if (purchases.hasData) {
      return ListView(
        children: purchases.data
            .map((purchase) => NFScreensWidgets.resumoNfCard(
                onLongPress: () {},
                onTap: () => _loadFullPurchase(context, purchase),
                context: context,
                purchase: purchase))
            .toList(),
      );
    } else if (purchases.hasError) {
      return Loading();
    } else {
      return Loading();
    }
  }

  void _loadFullPurchase(BuildContext context, Purchase purchase) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            FullFiscalNoteScreen(purchase.fiscalNote.accessKey)));
  }
}

class BuildPurchaseScreen extends StatelessWidget {
  final Purchase _purchase;

  BuildPurchaseScreen(this._purchase);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(_purchase.toString()),
    );
  }
}
