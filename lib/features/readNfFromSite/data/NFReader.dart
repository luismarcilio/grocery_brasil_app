import 'package:meta/meta.dart';

import '../domain/NfHtmlFromSite.dart';

abstract class NFReader {
  Future<NfHtmlFromSite> read({@required String url});
}
