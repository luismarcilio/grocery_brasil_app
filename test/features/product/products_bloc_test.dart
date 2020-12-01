import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/product/domain/ListProductsByTextUseCase.dart';
import 'package:grocery_brasil_app/features/product/presentation/bloc/products_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'fixture.dart' as fixture;

class MockListProductsByTextUseCase extends Mock
    implements ListProductsByTextUseCase {}

main() {
  MockListProductsByTextUseCase mockListProductsByTextUseCase;
  group('ListProductsByTextUseCase', () {
    mockListProductsByTextUseCase = new MockListProductsByTextUseCase();
    group('Should list the products', () {
      when(mockListProductsByTextUseCase(Params(text: 'leite')))
          .thenAnswer((realInvocation) async => Right(fixture.expected));
      blocTest('Should list the products',
          build: () => ProductsBloc(
              listProductsByTextUseCase: mockListProductsByTextUseCase),
          act: (bloc) => bloc.add(SearchProductsByText('leite')),
          expect: [
            ProductsSearching(),
            ProductsTextAvailable(products: fixture.expected)
          ]);
    });
    group('Should yield ProductError on failure', () {
      final failure = ProductFailure(
          messageId: MessageIds.UNEXPECTED, message: 'some error');
      when(mockListProductsByTextUseCase(Params(text: 'melão')))
          .thenAnswer((realInvocation) async => Left(failure));
      blocTest('Should yield ProductError on failure',
          build: () => ProductsBloc(
              listProductsByTextUseCase: mockListProductsByTextUseCase),
          act: (bloc) => bloc.add(SearchProductsByText('melão')),
          expect: [ProductsSearching(), ProductError(failure)]);
    });
  });
}
