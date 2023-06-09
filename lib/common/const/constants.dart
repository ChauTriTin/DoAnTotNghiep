// https://console.cloud.google.com/apis/credentials?project=ace-tranquility-382606

// https://console.cloud.google.com/google/maps-apis/home;onboard=true?project=graphic-chain-382806&authuser=2
import 'package:flutter/cupertino.dart';

class Constants {
  // static const String pdfURL =
  //     "https://raw.githubusercontent.com/nisrulz/flutter-examples/master/view_pdf_file/assets/Hello.pdf";

  static const _prefix = "AIz${_iHaveNoGirl}aSy";
  static const _iHaveNoGirl = "CuocSongNayQuaDauThuong";

  // static const String _iHaveNoMoney = "${_prefix}BIM${_iHaveNoGirl}dmyzom9kQ5b0HaEOaKl${_iHaveNoGirl}4KKXBuHH41U";
  // static const String _iHaveNoMoney = "${_prefix}AIzaSyCcB${_iHaveNoGirl}h8zpD6jg6${_iHaveNoGirl}bi6MM2fIq${_iHaveNoGirl}5BKwhnXfypic";
  static const String _iHaveNoMoney =
      "${_prefix}Ay${_iHaveNoGirl}XE57uyeaXMaXRla${_iHaveNoGirl}Na-txkc${_iHaveNoGirl}NH6SaWXcU";
  // static const String _iHaveNoMoney = "${_prefix}CLW1Up${_iHaveNoGirl}21QHcOy8OvNlr-psK${_iHaveNoGirl}aLQep2u3mg";
  // static const String _iHaveNoMoney = "${_prefix}CETUQZj2Iq${_iHaveNoGirl}8MSlRgKZq9FKXThs${_iHaveNoGirl}GbULI68";

  static String iLoveYou() {
    String alice = _iHaveNoMoney.replaceAll(_iHaveNoGirl, "");
    debugPrint("iLoveYou $alice");
    return alice;
  }

  static const String detailTrip = "detailTrip";
}
