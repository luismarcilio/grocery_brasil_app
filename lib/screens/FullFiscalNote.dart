import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/screens/common/NfItemCard.dart';
import 'package:grocery_brasil_app/services/notasFiscaisRepository.dart';

import 'common/ResumoNfCard.dart';

class FullFiscalNoteScreen extends StatelessWidget {
  final DocumentSnapshot document;
  FullFiscalNoteScreen(this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: resumoNfCard(
            document: document,
            onTap: () {
              Navigator.pop(context);
            },
            onLongPress: () {}),
      ),
      body: FutureBuilder(
          future: getFullNfFromDocId(document.id),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              //TODO
              return Text('Error');
            }
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              );
            }

            return ListView(
              children:
                  snapshot.data.data()['purchaseItemList'].map<Widget>((item) {
                return nfItemCard(
                    purchaseItem: item, onTap: () {}, onLongPress: () {});
              }).toList(),
            );
          }),
    );
  }
}
