import 'package:meta/meta.dart';

import 'ShareAdapter.dart';
import 'ShareService.dart';
import 'Shareable.dart';

class ShareServiceImpl implements ShareService {
  final ShareAdapter shareAdapter;

  ShareServiceImpl({@required this.shareAdapter});

  @override
  Future<bool> shareContent(Shareable input) async {
    await shareAdapter.share(input);
    return true;
  }
}
