import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';

abstract class ShareService {
  dynamic convertToShareFormat(dynamic input);
  Future<bool> shareContent(dynamic input, ShareFormat format);
}
