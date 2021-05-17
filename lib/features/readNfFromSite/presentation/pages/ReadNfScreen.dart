import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../domain/model/NFProcessData.dart';
import '../../domain/model/NfHtmlFromSite.dart';
import '../bloc/readnf_bloc.dart';

class ReadNfScreen extends StatelessWidget {
  final String url;

  const ReadNfScreen({Key key, @required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }

  BlocProvider<ReadnfBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReadnfBloc>(),
      child: BlocConsumer<ReadnfBloc, ReadnfState>(
        listener: (context, state) {
          if (state is GetDetailsFromUrlError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
              ),
            );
          } else if (state is SaveNfError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.purchaseFailure.message),
              ),
            );
          } else if (state is SaveNfDone) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is ReadnfInitial) {
            BlocProvider.of<ReadnfBloc>(context)
                .add(GetDetailsFromUrl(url: url));
          } else if (state is GetDetailsFromUrlDoing) {
            return Loading();
          } else if (state is SaveNfDoing) {
            return Loading();
          } else if (state is GetDetailsFromUrlDone) {
            return NfWebView(nFProcessData: state.nFProcessData);
          }
          return Loading();
        },
      ),
    );
  }
}

class NfWebView extends StatelessWidget {
  final NFProcessData nFProcessData;

  const NfWebView({Key key, @required this.nFProcessData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('nFProcessData.initialUrl: ${nFProcessData.initialUrl}');

    print('javascript: ${nFProcessData.javascriptFunctions}');

    SaveNf saveNf = SaveNf(state: nFProcessData.uf, context: context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Lendo nota fiscal"),
            TextButton(onPressed: () {}, child: Icon(Icons.refresh))
          ],
        ),
      ),
      body: InAppWebView(
        iosShouldAllowDeprecatedTLS: (controller, challenge) async {
          return IOSShouldAllowDeprecatedTLSAction.ALLOW;
        },
        initialUrlRequest: URLRequest(url: Uri.parse(nFProcessData.initialUrl)),
        onReceivedServerTrustAuthRequest: (InAppWebViewController controller,
            URLAuthenticationChallenge challenge) async {
          return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED);
        },
        onLoadError: (controller, uri, code, msg) =>
            print("onLoadError $code: $msg"),
        onLoadHttpError: (controller, uri, code, msg) =>
            print("onLoadHttpError $code: $msg"),
        onLoadStop: (controller, url) async {
          final result = await controller.evaluateJavascript(
              source: nFProcessData.javascriptFunctions);
          print(result.runtimeType); // int
          print(result);
          await saveNf.onMessageReceived(result);
          return;
        },
      ),
    );
  }
}

class SaveNf {
  final String state;
  final BuildContext context;
  SaveNf({@required this.state, @required this.context});

  get onMessageReceived => (String message) async {
        print("PrintHtml: $message");
        if (message == null || message == 'undefined' || message == '(null)') {
          return;
        }
        BlocProvider.of<ReadnfBloc>(context).add(
          SaveNfEvent(
            nfHtmlFromSite: NfHtmlFromSite(html: message, uf: state),
          ),
        );
      };
}
