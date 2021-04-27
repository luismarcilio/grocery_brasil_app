import 'package:meta/meta.dart';
import 'package:share/share.dart';

import 'ShareAdapter.dart';
import 'ShareFormat.dart';
import 'Shareable.dart';

class ShareAdapterImpl implements ShareAdapter {
  final FlutterShareStub flutterShareStub;

  ShareAdapterImpl({@required this.flutterShareStub});

  @override
  Future<void> share(Shareable shareable) async {
    switch (shareable.format) {
      case ShareFormat.TEXT:
        await flutterShareStub.shareText(shareable);
        break;
      case ShareFormat.PDF:
        await flutterShareStub.shareFile(shareable);
        break;
      default:
        throw UnimplementedError('Not implemented: ${shareable.format}');
    }
  }
}

class FlutterShareStub {
  Future<void> shareText(Shareable shareable) {
    return Share.share(shareable.content.text,
        subject: shareable.content.subject);
  }

  Future<void> shareFile(Shareable shareable) {
    return Share.shareFiles([shareable.content.filePath],
        subject: shareable.content.subject);
  }
}
