import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/DetailsFromUrlRepository.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/GetDetailsfromUrlUseCase.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NFProcessData.dart';
import 'package:mockito/mockito.dart';

class MockDetailsFromUrlRepository extends Mock
    implements DetailsFromUrlRepository {}

main() {
  MockDetailsFromUrlRepository mockDetailsFromUrlRepository;
  GetDetailsfromUrlUseCase getDetailsfromUrlUseCase;

  mockDetailsFromUrlRepository = MockDetailsFromUrlRepository();
  getDetailsfromUrlUseCase =
      GetDetailsfromUrlUseCase(repository: mockDetailsFromUrlRepository);

  group('GetDetailsfromUrlUseCase', () {
    test('should when ', () async {
      //setup
      final url = 'url';
      final nFProcessData = NFProcessData(
          accessKey: "accessKey",
          initialUrl: "initialUrl",
          javascriptFunctions: "javascriptFunctions",
          uf: "MG");

      when(mockDetailsFromUrlRepository(url: url))
          .thenAnswer((realInvocation) async => Right(nFProcessData));

      //act
      final actual = await getDetailsfromUrlUseCase(Params(url: url));
      //assert
      expect(actual, Right(nFProcessData));
    });
  });
}
