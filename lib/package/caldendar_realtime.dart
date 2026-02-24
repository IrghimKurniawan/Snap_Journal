import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RealTimeCalendar extends StatefulWidget {
  const RealTimeCalendar({super.key});

  @override
  State<RealTimeCalendar> createState() => _RealTimeCalendarState();
}

class _RealTimeCalendarState extends State<RealTimeCalendar> {
  DateTime selectedDate = DateTime.now();

  void _changeMonth(int value) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + value, 1);
    });
  }

  void _selectMonth(int month) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, month, 1);
    });
  }

  void _selectYear(int year) {
    setState(() {
      selectedDate = DateTime(year, selectedDate.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDay = DateTime(selectedDate.year, selectedDate.month, 1);

    int daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;

    int startWeekday = firstDay.weekday % 7;

    int totalItems = startWeekday + daysInMonth;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF9B7EBD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          /// ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => _changeMonth(-1),
              ),

              Row(
                children: [
                  /// MONTH DROPDOWN
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white, // background putih
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<int>(
                      value: selectedDate.month,
                      dropdownColor: Colors.white, // menu dropdown putih juga
                      underline: const SizedBox(),
                      iconEnabledColor: const Color(0xFF9B7EBD),
                      style: const TextStyle(
                        color: Color(0xFF9B7EBD),
                        fontWeight: FontWeight.w600,
                      ),
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            DateFormat.MMM().format(DateTime(0, index + 1)),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          _selectMonth(value);
                        }
                      },
                    ),
                  ),

                  SizedBox(width: 10),

                  /// YEAR DROPDOWN
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, // background tombol putih
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<int>(
                      value: selectedDate.year,
                      isDense: true,
                      dropdownColor: const Color(0xFFF5F0FF),
                      underline: const SizedBox(),
                      iconEnabledColor: const Color(0xFF9B7EBD),
                      style: const TextStyle(
                        color: Color(0xFF9B7EBD),
                        fontWeight: FontWeight.w600,
                      ),
                      items: List.generate(20, (index) {
                        int year = DateTime.now().year - 10 + index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text("$year"),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          _selectYear(value);
                        }
                      },
                    ),
                  ),
                ],
              ),

              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ===== DAY LABEL =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
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

          /// ===== GRID =====
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalItems,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              if (index < startWeekday) {
                return const SizedBox();
              }

              int day = index - startWeekday + 1;

              bool isToday =
                  day == DateTime.now().day &&
                  selectedDate.month == DateTime.now().month &&
                  selectedDate.year == DateTime.now().year;

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday ? Colors.red : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "$day",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
