import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/widgets/UserMessaging.dart';
import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../domain/QRCode.dart';
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
          final message = errorMessages[state.failure.messageId]?.message ??
              'Erro lendo QRCODE';
          showInformationWidget(message: message, context: context);
          Navigator.of(context).pop<QRCode>(null);
        } else if (state is QrcodeReadDone) {
          Navigator.of(context).pop<QRCode>(state.qrCode);
        }
      }, builder: (context, state) {
        if (state is QrcodeInitial) {
          BlocProvider.of<QrcodeBloc>(context).add(ReadQRCode());
        } else if (state is QrcodeReading) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Leia o QR Code"),
            ),
            body: QrCamera(
                onError: (context, error) {
                  BlocProvider.of<QrcodeBloc>(context).add(
                      ReadCodeErrorReceived(
                          qrCodeFailure: QRCodeFailure(
                              messageId: MessageIds.PERMISSION_DENIED)));
                  return Loading();
                },
                fit: BoxFit.fitWidth,
                formats: [BarcodeFormats.QR_CODE],
                qrCodeCallback: (code) {
                  BlocProvider.of<QrcodeBloc>(context)
                      .add(ReadCodeReceived(qrCode: QRCode(url: code)));
                  return;
                }),
          );
        }
        return Loading();
      }),
    );
  }
}
