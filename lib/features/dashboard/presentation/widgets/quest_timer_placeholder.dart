import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class QuestTimerPlaceholder extends StatefulWidget {
  final DateTime deletedAt;
  const QuestTimerPlaceholder({required this.deletedAt, Key? key}) : super(key: key);

  @override
  State<QuestTimerPlaceholder> createState() => QuestTimerPlaceholderState();
}

class QuestTimerPlaceholderState extends State<QuestTimerPlaceholder> {
  late Duration timeLeft;
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withValues(alpha:0.35),
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(18),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FeatherIcons.clock, color: Colors.grey, size: 22),
          const SizedBox(width: 10),
          Text(
            'New quest in ${timeLeft.inHours.toString().padLeft(2, '0')}:${(timeLeft.inMinutes % 60).toString().padLeft(2, '0')}:${(timeLeft.inSeconds % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
