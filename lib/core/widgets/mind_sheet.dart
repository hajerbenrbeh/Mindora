import 'package:flutter/material.dart';

import '../../app/theme/mind_tokens.dart';

/// Presents a token-styled modal bottom sheet (`surface` fill, top radius `32`,
/// `1px line` top border, `tokens.scrim` backdrop, grabber bar).
Future<T?> showMindSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool showGrabHandle = true,
}) {
  final tokens = context.tokens;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: tokens.scrim,
    elevation: 0,
    builder: (sheetContext) {
      return MindSheet(
        showGrabHandle: showGrabHandle,
        child: builder(sheetContext),
      );
    },
  );
}

/// Modal bottom sheet container driven exclusively by [MindTokens].
class MindSheet extends StatelessWidget {
  const MindSheet({
    super.key,
    required this.child,
    this.showGrabHandle = true,
    this.padding = const EdgeInsets.fromLTRB(18, 10, 18, 28),
  });

  final Widget child;
  final bool showGrabHandle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.90;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(tokens.sheetRadius),
        ),
        border: Border(top: BorderSide(color: tokens.line, width: 1.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showGrabHandle) ...[
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: tokens.lineStrong,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ],
              Flexible(child: SingleChildScrollView(child: child)),
            ],
          ),
        ),
      ),
    );
  }
}
