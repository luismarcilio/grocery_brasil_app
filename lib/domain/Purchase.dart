import 'dart:convert';

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
  final double totalDiscount;
  final List<PurchaseItem> purchaseItemList;

  Purchase(
      {this.user,
      this.fiscalNote,
      this.totalAmount,
      this.purchaseItemList,
      this.totalDiscount});

  @override
  List<Object> get props =>
      [user, fiscalNote, totalAmount, purchaseItemList, totalDiscount];

  factory Purchase.fromResumeSnapshot(DocumentSnapshot resume) {
    return Purchase(
        fiscalNote: FiscalNote(
            company: Company.fromJson(resume.data()['company']),
            date: resume.data()['date']?.toDate(),
            accessKey: resume.id),
        totalAmount: resume.data()['totalAmount']?.toDouble(),
        totalDiscount: resume.data()['totalDiscount']?.toDouble());
  }

  factory Purchase.fromSnapshot(DocumentSnapshot doc) {
    final Purchase purchase = Purchase.fromJson(doc.data());
    return purchase;
  }

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);

  @override
  String toString() => jsonEncode(this.toJson());
}
