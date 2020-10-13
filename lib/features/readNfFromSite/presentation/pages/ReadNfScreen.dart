import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NfHtmlFromSite.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../injection_container.dart';
import '../../../../screens/common/loading.dart';
import '../../domain/model/NFProcessData.dart';
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
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
              ),
            );
          } else if (state is SaveNfError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.nfFailure.message),
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
    WebViewController _webViewController;

    print('nFProcessData.initialUrl: ${nFProcessData.initialUrl}');

    print('javascript: ${nFProcessData.javascriptFunctions}');
    return WebView(
      debuggingEnabled: true,
      initialUrl: nFProcessData.initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      gestureNavigationEnabled: true,
      onPageFinished: (String url) {
        _webViewController.loadUrl(nFProcessData.javascriptFunctions);
      },
      javascriptChannels: Set<JavascriptChannel>.from(
          {SaveNf(state: nFProcessData.state, context: context)}),
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
      },
    );
  }
}

class SaveNf implements JavascriptChannel {
  final String state;
  final BuildContext context;
  SaveNf({@required this.state, @required this.context});

  @override
  String get name => 'Print';

  @override
  get onMessageReceived => (JavascriptMessage message) async {
        print("PrintHtml: ${message.message}");
        if (message.message == 'undefined') {
          return;
        }
        BlocProvider.of<ReadnfBloc>(context).add(
          SaveNfEvent(
            nfHtmlFromSite: NfHtmlFromSite(html: message.message, uf: state),
          ),
        );
      };
}
