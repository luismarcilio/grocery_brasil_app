import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/screens/loading.dart';
import 'package:grocery_brasil_app/services/FiscalNoteBusiness.dart';
import 'package:grocery_brasil_app/services/qrcode.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../business/NfProviderConfig.dart';

class ScanNfScreen extends StatelessWidget {
  Widget webView(BuildContext context, String url) {
    FiscalNoteUrlData fiscalNoteUrlData = FiscalNoteUrlData(url);
    WebViewController _webViewController;
    return WebView(
      debuggingEnabled: false,
      initialUrl: nfProviderFactory[fiscalNoteUrlData.state].nfUrl,
      javascriptMode: JavascriptMode.unrestricted,
      gestureNavigationEnabled: true,
      onPageFinished: (String url) {
        print('url: $url');
        nfProviderFactory[fiscalNoteUrlData.state]
            .executeJs(_webViewController, url, fiscalNoteUrlData.accessKey);
      },
      javascriptChannels:
          nfJavascriptChannels(fiscalNoteUrlData.state, context),
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ler QRCODE'),
      ),
      body: FutureBuilder(
        future: scanQrcode(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            //TODO
            return Text('Erro lendo QRCODE');
          }
          if (!snapshot.hasData) {
            return Loading();
          }
          return webView(context, snapshot.data);
        },
      ),
    );
  }
}
