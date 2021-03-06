import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final String text;
  final bool visible;
  final DateTime minDate;
  final Function(DateRangePickerSelectionChangedArgs args) callback;

  const AppCalendar(
      {Key? key,
      required this.callback,
      required this.selectedDate,
      required this.text,
      this.visible = false,
      required this.minDate})
      : super(key: key);

  @override
  _AppCalendarState createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late bool _isVisible;
  final DateTime _maxDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _isVisible = widget.visible;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: thirdSize),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.text, style: secondTextStyle),
                    Icon(
                      _isVisible
                          ? Icons.arrow_drop_up_outlined
                          : Icons.arrow_drop_down_outlined,
                    )
                  ]),
              onTap: () {
                setState(() => _isVisible = !_isVisible);
              },
            ),
            Visibility(
                visible: _isVisible,
                child: SfDateRangePicker(
                    minDate: widget.minDate,
                    maxDate: _maxDate,
                    initialSelectedDate: widget.selectedDate,
                    todayHighlightColor: primaryColor,
                    selectionColor: primaryColor,
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: widget.callback)),
          ],
        ),
      );
}
