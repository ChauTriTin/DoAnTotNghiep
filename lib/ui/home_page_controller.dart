import 'package:get/get.dart';

import '../base/base_controller.dart';

class HomePageController extends BaseController {
  // PackageInfo packageInfo = PackageInfo(
  //   appName: 'Unknown',
  //   packageName: 'Unknown',
  //   version: 'Unknown',
  //   buildNumber: 'Unknown',
  // );
  //
  // var versionName = "".obs;
  // var listChapWrapper = ListChapWrapper().obs;
  //
  void clearOnDispose() {
    Get.delete<HomePageController>();
  }
//
// Future<void> initPackageInfo() async {
//   final info = await PackageInfo.fromPlatform();
//   packageInfo = info;
//
//   versionName.value = packageInfo.version;
//   versionName.refresh();
// }
//
// //https://drive.google.com/drive/u/0/folders/1VRqfDGcj99vi53uCowQr0SEKXwk3IPFg
// void getListChap() async {
//   try {
//     setAppLoading(true, "Loading", TypeApp.getListChap);
//     var response = await Dio().get(
//         'https://drive.google.com/uc?export=download&id=1BEBhPA6mb8zCk0lIE42JXBD5xm_29PFH');
//     Dog.d(">>>response $response");
//     Map<String, dynamic> results = json.decode(response.data);
//     listChapWrapper.value = ListChapWrapper.fromJson(results);
//     Dog.d("_listChapWrapper >>> ${jsonEncode(listChapWrapper)}");
//   } catch (e) {
//     var msg = e.toString();
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//     } else {
//       msg = "No internet connection";
//     }
//     setAppError(msg, TypeApp.getListChap);
//   }
//   setAppLoading(false, "", TypeApp.getListChap);
// }
}
