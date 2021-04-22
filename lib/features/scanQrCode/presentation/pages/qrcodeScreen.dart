import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';
import 'package:grocery_brasil_app/screens/common/loading.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';

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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          Navigator.of(context).pop<QRCode>(null);
        } else if (state is QrcodeReadDone) {
          Navigator.of(context).pop<QRCode>(state.qrCode);
        }
      }, builder: (context, state) {
        if (state is QrcodeInitial) {
          BlocProvider.of<QrcodeBloc>(context).add(ReadQRCode());
        } else if (state is QrcodeReading) {
          return QrCamera(
              onError: (context, error) {
                BlocProvider.of<QrcodeBloc>(context).add(ReadCodeErrorReceived(
                    qrCodeFailure: QRCodeFailure(messageId: error)));
                return Loading();
              },
              child: Text("Child"),
              fit: BoxFit.fitWidth,
              formats: [BarcodeFormats.QR_CODE],
              qrCodeCallback: (code) {
                BlocProvider.of<QrcodeBloc>(context)
                    .add(ReadCodeReceived(qrCode: QRCode(url: code)));
                return;
              });
        }
        return Loading();
      }),
    );
  }
}
