import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({required this.changeNotifier});

  void listener({
    required BuildContext context,
    required SuccessVoidCallback successCallBack,
    ErrorVoidCallback? errorCallBack,
  }) {
    changeNotifier.addListener(
      () {
        if (changeNotifier.loading) {
          Loader.show(context);
        } else {
          Loader.hide();
        }
        if (changeNotifier.hasError) {
          if (errorCallBack != null) {
            errorCallBack(changeNotifier, this);
          }
          Messages.of(context)
              .showError(changeNotifier.error ?? ' Erro interno');
        } else if (changeNotifier.isSuccess) {
          successCallBack(changeNotifier, this);
        }
      },
    );
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallback = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef ErrorVoidCallback = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);
