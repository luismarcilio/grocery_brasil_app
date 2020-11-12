import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Company.dart';
import 'FiscalNote.dart';
import 'PurchaseItem.dart';
import 'User.dart';

part 'Purchase.g.dart';

@JsonSerializable(explicitToJson: true)
class Purchase extends Equatable {
  final User user;
  final FiscalNote fiscalNote;
  final double totalAmount;
  final List<PurchaseItem> purchaseItemlist;

  Purchase(
      {this.user, this.fiscalNote, this.totalAmount, this.purchaseItemlist});

  @override
  List<Object> get props => [user, fiscalNote, totalAmount, purchaseItemlist];

  factory Purchase.fromResumeSnapshot(DocumentSnapshot resume) {
    print('resume.data: ${resume.data()["date"]}');
    return Purchase(
        fiscalNote: FiscalNote(
            company: Company.fromJson(resume.data()['company']),
            // date: resume.data()['date'].toDate(),
            accessKey: resume.id),
        totalAmount: resume.data()['totalAmount']);
  }

  factory Purchase.fromSnapshot(DocumentSnapshot doc) {
    final Purchase purchase = Purchase.fromJson(doc.data());
    return purchase;
  }

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);
  @override
  String toString() {
    return 'Purchase{user: $user, fiscalNote: $fiscalNote, totalAmount: $totalAmount, purchaseItemlist: $purchaseItemlist}';
  }
}
