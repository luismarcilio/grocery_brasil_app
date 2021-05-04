import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../services/ProductsRepository.dart';

class ProdutosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TypeAheadField textField = TypeAheadField(
      suggestionsCallback: (pattern) async {
        if (pattern.length > 0) return await getAutocompleteTips(pattern);
        return Iterable.empty();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: suggestion.thumbnail != null
              ? Image.network(suggestion.thumbnail)
              : Icon(Icons.shopping_cart),
          title: Text(suggestion.name),
        );
      },
      onSuggestionSelected: (suggestion) {
        print('Selected: $suggestion');
      },
    );

    return Container(
      child: textField,
    );
  }
}
