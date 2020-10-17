import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/GetDetailsfromUrlUseCase.dart'
    as GetDetailsfromUrlUseCase;
import 'package:grocery_brasil_app/features/readNfFromSite/domain/SaveNfUseCase.dart'
    as SaveNfUseCase;
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NFProcessData.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NfHtmlFromSite.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/presentation/bloc/readnf_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetDetailsfromUrlUseCase extends Mock
    implements GetDetailsfromUrlUseCase.GetDetailsfromUrlUseCase {}

class MockSaveNfUseCase extends Mock implements SaveNfUseCase.SaveNfUseCase {}

main() {
  MockGetDetailsfromUrlUseCase mockGetDetailsfromUrlUseCase =
      MockGetDetailsfromUrlUseCase();
  MockSaveNfUseCase mockSaveNfUseCase = MockSaveNfUseCase();

  group('GetDetailsFromUrl', () {
    final url = "url";
    final nFProcessData = NFProcessData(
        accessKey: "accessKey",
        initialUrl: "initialUrl",
        javascriptFunctions: "javascriptFunctions",
        state: "state");
    when(mockGetDetailsfromUrlUseCase(
            GetDetailsfromUrlUseCase.Params(url: url)))
        .thenAnswer((realInvocation) async => Right(nFProcessData));
    blocTest('GetDetailsFromUrl',
        build: () => ReadnfBloc(
            getDetailsfromUrlUseCase: mockGetDetailsfromUrlUseCase,
            saveNfUseCase: mockSaveNfUseCase),
        act: (bloc) => bloc.add(GetDetailsFromUrl(url: url)),
        expect: [
          GetDetailsFromUrlDoing(),
          GetDetailsFromUrlDone(nFProcessData: nFProcessData)
        ]);
  });

  group('SaveNfEvent', () {
    final nfHtmlFromSite = NfHtmlFromSite(html: "html", uf: "MG");
    when(mockSaveNfUseCase(
            SaveNfUseCase.Params(nfHtmlFromSite: nfHtmlFromSite)))
        .thenAnswer((realInvocation) async => Right(nfHtmlFromSite));
    blocTest('SaveNfEvent',
        build: () => ReadnfBloc(
            getDetailsfromUrlUseCase: mockGetDetailsfromUrlUseCase,
            saveNfUseCase: mockSaveNfUseCase),
        act: (bloc) => bloc.add(SaveNfEvent(nfHtmlFromSite: nfHtmlFromSite)),
        expect: [SaveNfDoing(), SaveNfDone()]);
  });
}
