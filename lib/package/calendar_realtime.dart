import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snap_journal/services/feeling_services.dart';
import 'package:snap_journal/services/theme_extension.dart';

class RealTimeCalendar extends StatefulWidget {
  final List<dynamic> moods;

  const RealTimeCalendar({super.key, required this.moods});

  @override
  State<RealTimeCalendar> createState() => _RealTimeCalendarState();
}

class _RealTimeCalendarState extends State<RealTimeCalendar> {
  DateTime selectedDate = DateTime.now();
  Map<String, String> _moodByDate = {};

  static const Map<String, String> moodEmoji = {
    'Happy': '😍',
    'Calm': '😄',
    'Sad': '😢',
    'Tired': '😴',
    'Angry': '😠',
    'Neutral': '🙂',
  };

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await FeelingServices.getFeelingHistory();
    final Map<String, String> mapped = {};
    for (final item in history) {
      final date = item['date'] as String?;
      final mood = item['mood'] as String?;
      if (date != null && mood != null) mapped[date] = mood;
    }
    setState(() => _moodByDate = mapped);
  }

  void _changeMonth(int value) => setState(() {
        selectedDate =
            DateTime(selectedDate.year, selectedDate.month + value, 1);
      });

  void _selectMonth(int month) => setState(() {
        selectedDate = DateTime(selectedDate.year, month, 1);
      });

  void _selectYear(int year) => setState(() {
        selectedDate = DateTime(year, selectedDate.month, 1);
      });

  Map<String, dynamic>? _getMoodForDate(DateTime date) {
    try {
      return widget.moods.firstWhere((mood) {
        final moodDate = DateTime.parse(mood['date']);
        return moodDate.year == date.year &&
            moodDate.month == date.month &&
            moodDate.day == date.day;
      });
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.watchPrimaryColor;
    final DateTime firstDay =
        DateTime(selectedDate.year, selectedDate.month, 1);
    final int daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final int startWeekday = firstDay.weekday % 7;
    final int totalItems = startWeekday + daysInMonth;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // ─── HEADER ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 18),
                onPressed: () => _changeMonth(-1),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<int>(
                      value: selectedDate.month,
                      dropdownColor: Colors.white,
                      underline: const SizedBox(),
                      iconEnabledColor: primary,
                      style: TextStyle(
                          color: primary, fontWeight: FontWeight.w600),
                      items: List.generate(
                          12,
                          (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text(DateFormat.MMM()
                                    .format(DateTime(0, i + 1))),
                              )),
                      onChanged: (v) {
                        if (v != null) _selectMonth(v);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<int>(
                      value: selectedDate.year,
                      isDense: true,
                      dropdownColor: Colors.white,
                      underline: const SizedBox(),
                      iconEnabledColor: primary,
                      style: TextStyle(
                          color: primary, fontWeight: FontWeight.w600),
                      items: List.generate(20, (i) {
                        final year = DateTime.now().year - 10 + i;
                        return DropdownMenuItem(
                            value: year, child: Text("$year"));
                      }),
                      onChanged: (v) {
                        if (v != null) _selectYear(v);
                      },
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 18),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ─── DAY LABELS ───
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DayLabel("Su"),
              _DayLabel("Mo"),
              _DayLabel("Tu"),
              _DayLabel("We"),
              _DayLabel("Th"),
              _DayLabel("Fr"),
              _DayLabel("Sa"),
            ],
          ),

          const SizedBox(height: 16),

          // ─── GRID ───
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalItems,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox();

              final day = index - startWeekday + 1;
              final dateKey = DateFormat('yyyy-MM-dd')
                  .format(DateTime(selectedDate.year, selectedDate.month, day));
              final mood = _moodByDate[dateKey];
              final emoji = mood != null ? moodEmoji[mood] : null;

              final isToday = day == DateTime.now().day &&
                  selectedDate.month == DateTime.now().month &&
                  selectedDate.year == DateTime.now().year;

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday ? Colors.red.withOpacity(0.7) : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: emoji != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 14)),
                          Text("$day",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500)),
                        ],
                      )
                    : Text("$day",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String text;
  const _DayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(text,
            style: const TextStyle(
                color: Colors.white70, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
