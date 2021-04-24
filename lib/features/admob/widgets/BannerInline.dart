import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/features/admob/domain/AddFactory.dart';
import 'package:grocery_brasil_app/features/admob/widgets/AdHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdd implements AddFactory<BannerInline> {
  @override
  BannerInline get() {
    return BannerInline();
  }
}

class BannerInline extends StatefulWidget {
  BannerInline({Key key}) : super(key: key);

  @override
  _BannerInlineState createState() => _BannerInlineState();
}

class _BannerInlineState extends State<BannerInline> {
  BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return !_isAdLoaded
        ? Container()
        : Container(
            child: AdWidget(
              ad: _ad,
            ),
            width: _ad.size.width.toDouble(),
            height: _ad.size.height.toDouble(),
            alignment: Alignment.center,
          );
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }
}
