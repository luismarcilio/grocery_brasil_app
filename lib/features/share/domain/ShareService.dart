import 'Shareable.dart';

abstract class ShareService {
  Future<bool> shareContent(Shareable input);
}
