import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/Company.dart';
import '../../../domain/PurchaseItem.dart';
import 'ShareFormat.dart';
import 'Shareable.dart';

abstract class ShareableConverter<T> {
  Shareable convert(T input);
}

class PurchaseItemConverter
    implements ShareableConverter<PurchaseItemConverterInput> {
  @override
  Shareable convert(PurchaseItemConverterInput input) {
    return Shareable(
        content: ShareableContent(subject: 'Veja o item que comprei!', text: '''
${input.purchaseItem.product} na ${input.company.name} 
que fica na ${input.company.address.location}, ${input.company.address.number}
${input.company.address.complement} 
no bairro ${input.company.address.county}
por apenas ${input.purchaseItem.unityValue} / ${input.purchaseItem.unity.name}
            '''), format: ShareFormat.TEXT);
  }
}

class PurchaseItemConverterInput extends Equatable {
  final PurchaseItem purchaseItem;
  final Company company;

  PurchaseItemConverterInput(
      {@required this.purchaseItem, @required this.company});

  @override
  List<Object> get props => [company, purchaseItem];
}
