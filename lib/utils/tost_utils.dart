import 'package:oktoast/oktoast.dart';

///底部提示
class Toast {
  static show(String msg, {duration = 2000}) {
    showToast(
        msg,
        duration: Duration(milliseconds: duration),
        dismissOtherToast: true
    );
  }

  static cancelToast() {
    dismissAllToast();
  }
}