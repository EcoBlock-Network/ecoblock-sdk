import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/core/widgets/skeleton.dart';

class QuestTimerPlaceholder extends StatefulWidget {
  final DateTime deletedAt;
  const QuestTimerPlaceholder({required this.deletedAt, super.key});

  @override
  State<QuestTimerPlaceholder> createState() => QuestTimerPlaceholderState();
}

class QuestTimerPlaceholderState extends State<QuestTimerPlaceholder> {
  late Duration timeLeft;
  // ignore: prefer_typing_uninitialized_variables
  late final ticker;

  @override
  void initState() {
    super.initState();
    _updateTime();
    ticker = Stream.periodic(const Duration(seconds: 1), (_) => _updateTime()).listen((_) {});
  }

  void _updateTime() {
    setState(() {
      timeLeft = Duration(hours: 3) - DateTime.now().difference(widget.deletedAt);
      if (timeLeft.isNegative) timeLeft = Duration.zero;
    });
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // show skeleton while waiting (small visual improvement)
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.06),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonBox(width: 22, height: 22, borderRadius: BorderRadius.circular(6)),
          const SizedBox(width: 10),
          Expanded(
            child: SkeletonBox(height: 16, borderRadius: BorderRadius.circular(6)),
          ),
        ],
      ),
    );
  }
}
