part of 'readnf_bloc.dart';

abstract class ReadnfState extends Equatable {
  const ReadnfState();

  @override
  List<Object> get props => [];
}

class ReadnfInitial extends ReadnfState {}

class GetDetailsFromUrlDoing extends ReadnfState {}

class GetDetailsFromUrlDone extends ReadnfState {
  final NFProcessData nFProcessData;

  GetDetailsFromUrlDone({@required this.nFProcessData});
}

class GetDetailsFromUrlError extends ReadnfState {
  final NFProcessDataFailure failure;

  GetDetailsFromUrlError({@required this.failure});
}

class SaveNfDoing extends ReadnfState {}

class SaveNfError extends ReadnfState {
  final NfFailure nfFailure;

  SaveNfError({@required this.nfFailure});
}

class SaveNfDone extends ReadnfState {}
