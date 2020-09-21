import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/screens/FullFiscalNote.dart';
import 'package:grocery_brasil_app/screens/common/ResumoNfCard.dart';

import '../services/notasFiscaisRepository.dart';

class NotasFiscaisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getResumeNfForUser(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
            return resumoNfCard(
                document: document,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullFiscalNoteScreen(document)));
                },
                onLongPress: () {});
          }).toList());
        });
  }
}
