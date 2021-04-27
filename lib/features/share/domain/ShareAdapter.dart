import 'Shareable.dart';

abstract class ShareAdapter {
  Future<void> share(Shareable shareable);
}
