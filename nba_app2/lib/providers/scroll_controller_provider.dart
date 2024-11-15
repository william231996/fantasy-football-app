import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:flutter/widgets.dart';

final scrollControllersProvider = Provider.autoDispose<_ScrollControllers>((ref) {
  final linkedScrollControllers = LinkedScrollControllerGroup();

  final myScrollController = linkedScrollControllers.addAndGet();
  final opponentScrollController = linkedScrollControllers.addAndGet();

  // Dispose controllers when the provider is disposed
  ref.onDispose(() {
    myScrollController.dispose();
    opponentScrollController.dispose();
  });

  return _ScrollControllers(
    myScrollController: myScrollController,
    opponentScrollController: opponentScrollController,
  );
});

class _ScrollControllers {
  final ScrollController myScrollController;
  final ScrollController opponentScrollController;

  _ScrollControllers({
    required this.myScrollController,
    required this.opponentScrollController,
  });
}