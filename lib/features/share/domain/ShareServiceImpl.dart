import 'package:grocery_brasil_app/features/share/domain/ShareAdapter.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareService.dart';
import 'package:meta/meta.dart';

class ShareServiceImpl implements ShareService {
  final ShareAdapter shareAdapter;

  ShareServiceImpl({@required this.shareAdapter});

  @override
  convertToShareFormat(input) {
    // TODO: implement convertToShareFormat
    throw UnimplementedError();
  }

  @override
  Future<bool> shareContent(input, ShareFormat format) async {
    await shareAdapter.share(input, format);
    return true;
  }
}
