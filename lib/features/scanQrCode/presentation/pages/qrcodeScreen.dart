import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';
import 'package:grocery_brasil_app/screens/common/loading.dart';

import '../../../../injection_container.dart';
import '../bloc/qrcode_bloc.dart';

class QrCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  BlocProvider<QrcodeBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QrcodeBloc>(),
      child: BlocConsumer<QrcodeBloc, QrcodeState>(listener: (context, state) {
        if (state is QrcodeReadDone) {
          Navigator.of(context).pop<QRCode>(state.qrCode);
        } else if (state is QrcodeReadError) {
          String message;
          switch (state.failure.messageId) {
            case MessageIds.CANCELLED:
              message = 'Scan cancelado';
              break;
            default:
              message = state.failure?.message ?? 'Erro lendo QRCODE';
          }

          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          Navigator.of(context).pop<QRCode>(null);
        }
      }, builder: (context, state) {
        if (state is QrcodeInitial) {
          BlocProvider.of<QrcodeBloc>(context).add(ReadQRCode());
        }
        return Loading();
      }),
    );
  }
}
