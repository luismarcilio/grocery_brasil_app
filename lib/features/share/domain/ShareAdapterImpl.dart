import 'package:grocery_brasil_app/features/share/domain/ShareAdapter.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:share/share.dart';
import 'package:meta/meta.dart';

class ShareAdapterImpl implements ShareAdapter {
  final FlutterShareStub flutterShareStub;

  ShareAdapterImpl({@required this.flutterShareStub});

  @override
  Future<void> share(contents, ShareFormat format) {
    switch (format) {
      case ShareFormat.TEXT:
        return flutterShareStub.share(contents);
        break;
      default:
        throw UnimplementedError();
    }
  }
}

class FlutterShareStub {
  Future<void> share(String text) {
    return Share.share(text);
  }
}
