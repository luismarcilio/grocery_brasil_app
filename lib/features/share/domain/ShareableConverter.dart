import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../domain/Company.dart';
import '../../../domain/PurchaseItem.dart';
import '../../product/domain/ProductPrices.dart';
import '../../product/domain/ProductSearchModel.dart';
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
        content: ShareableContent(
            subject: 'Veja o preço que encontrei!',
            text: '''Veja o preço que encontrei: 
${input.purchaseItem.product.name} em ${input.company.name} 
que fica na ${input.company.address.street}, ${input.company.address.number} ${input.company.address.complement != null ? input.company.address.complement : ""} 
no bairro ${input.company.address.county}
por R\$ ${NumberFormat("###.00", "pt_BR").format(input.purchaseItem.unityValue)} / ${input.purchaseItem.unity.name}.

Baixe o aplicativo pra encontrar outras ofertas! http://www.grocerybrasil.com'''),
        format: ShareFormat.TEXT);
  }
}

class ProductPricesConverterInput extends Equatable {
  final ProductPrices productPrices;
  final ProductSearchModel product;

  ProductPricesConverterInput(
      {@required this.productPrices, @required this.product});

  @override
  List<Object> get props => [productPrices, product];
}

class ProductPricesConverter
    implements ShareableConverter<ProductPricesConverterInput> {
  @override
  Shareable convert(ProductPricesConverterInput input) {
    return Shareable(
        content: ShareableContent(
            subject: 'Veja o preço que encontrei!',
            text: '''Veja o preço que encontrei: 
${input.product.name} em ${input.productPrices.company.name} 
que fica na ${input.productPrices.company.address.street}, ${input.productPrices.company.address.number} ${input.productPrices.company.address.complement != null ? input.productPrices.company.address.complement : ""} 
no bairro ${input.productPrices.company.address.county}
por R\$ ${NumberFormat("###.00", "pt_BR").format(input.productPrices.unityValue)} / ${input.product.unity.name}.

Baixe o aplicativo pra encontrar outras ofertas! http://www.grocerybrasil.com'''),
        format: ShareFormat.TEXT);
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
