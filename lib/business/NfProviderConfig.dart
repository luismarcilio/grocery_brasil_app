import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../services/FiscalNoteBusiness.dart';

final Map<String, NfProvider> nfProviderFactory = {
  'MG': NfProviderMG(),
  'RJ': NfProviderRJ()
};

Set<JavascriptChannel> nfJavascriptChannels(
    String state, BuildContext context) {
  return ({SaveNf(state, context), SetNfKey(), ClickDetailedNF()});
}

class SaveNf implements JavascriptChannel {
  String _state;
  BuildContext _context;
  SaveNf(this._state, this._context);

  @override
  String get name => 'Print';

  @override
  get onMessageReceived => (JavascriptMessage message) async {
        print("PrintHtml: ${message.message}");
        print("state: $_state");
        saveNf(message.message, _state).then((http.Response response) {
          print(response.toString());
          Navigator.pop(_context);
        }).catchError((e) => print("Error: " + e.toString()));
      };
}

class SetNfKey implements JavascriptChannel {
  @override
  String get name => 'SetNfKey';

  @override
  get onMessageReceived => (JavascriptMessage message) {
        print("Javascript message: ${message.message}");
      };
  showHtml(String html) {
    print("SetNfKey: $html");
  }
}

class ClickDetailedNF implements JavascriptChannel {
  @override
  String get name => 'ClickDetailedNF';

  @override
  get onMessageReceived => (JavascriptMessage message) {
        print("ClickDetailedNF: ${message.message}");
      };
}

class NfProvider {
  String nfUrl;

  String getSetAccessKeyJavascript(String accessKey) {
    return null;
  }

  String getClickDetailedFiscalNoteButtonJavascript() {
    return null;
  }

  String getJavaScriptToRun(String currentUrl, String accessKey) {
    return null;
  }

  String getClickDetailedNfClassName() {
    return 'ClickDetailedNF';
  }

  String getSetAccessKeyClassName() {
    return 'SetNfKey';
  }

  void executeJs(
      WebViewController _webViewController, String url, String accessKey) {}

  String readHtml() {
    return "javascript:Print.postMessage(document.documentElement.outerHTML)";
  }
}

class NfProviderMG extends NfProvider {
  NfProviderMG() {
    nfUrl =
        'http://nfce.fazenda.mg.gov.br/portalnfce/sistema/consultaarg.xhtml';
  }
  @override
  String getSetAccessKeyJavascript(String accessKey) {
    return "javascript:SetNfKey.postMessage(document.getElementById('formPrincipal:chaveacesso').value='$accessKey');";
  }

  @override
  String getClickDetailedFiscalNoteButtonJavascript() {
    return "javascript:ClickDetailedNF.postMessage(document.querySelector('div.col-xs-12.col-md-2.col-lg-2 > a').click())";
  }

  @override
  void executeJs(
      WebViewController _webViewController, String url, String accessKey) {
    final bool isSimplifiedNf = url.contains('consultaarg.xhtml');
    final bool isCompletedNf = url.contains('consultaresumida.xhtml');
    if (isSimplifiedNf) {
      _webViewController.loadUrl(getSetAccessKeyJavascript(accessKey));
      _webViewController.loadUrl(getClickDetailedFiscalNoteButtonJavascript());
      return;
    }
    if (isCompletedNf) {
      _webViewController.loadUrl(readHtml());
      return;
    }
    return;
  }
}

class NfProviderRJ extends NfProvider {
  NfProviderRJ() {
    nfUrl =
        'http://www4.fazenda.rj.gov.br/consultaDFe/paginas/consultaChaveAcesso.faces';
  }
  @override
  String getSetAccessKeyJavascript(String accessKey) {
    final js =
        "javascript:SetNfKey.postMessage(document.querySelector('#chaveAcesso').value='$accessKey');document.querySelector('#captcha').focus()";
    print("js: $js");
    return js;
  }

  @override
  String getClickDetailedFiscalNoteButtonJavascript() {
    return "javascript:ClickDetailedNF.postMessage(document.querySelector('#menu_botoes > input.bot_consulta.imgBtDetalhada.mB_12').click())";
  }

  @override
  void executeJs(
      WebViewController _webViewController, String url, String accessKey) {
    final bool shouldSetAccessKey = url.contains('consultaChaveAcesso.faces');
    final bool shouldClickDetailedButton = url.contains('resultadoNfce.faces');
    final bool shouldSaveNf = url.contains('resultadoDfeDetalhado.faces');

    if (shouldSetAccessKey) {
      _webViewController.loadUrl(getSetAccessKeyJavascript(accessKey));
      return;
    }
    if (shouldClickDetailedButton) {
      _webViewController.loadUrl(getClickDetailedFiscalNoteButtonJavascript());
      return;
    }

    if (shouldSaveNf) {
      _webViewController.loadUrl(readHtml());
      return;
    }

    return;
  }
}
