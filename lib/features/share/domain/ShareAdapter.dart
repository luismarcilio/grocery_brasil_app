import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';

abstract class ShareAdapter {
  Future<void> share(dynamic contents, ShareFormat format);
}
