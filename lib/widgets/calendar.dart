import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final String text;
  final bool visible;
  final Function(DateRangePickerSelectionChangedArgs args) callback;

  const AppCalendar(
      {Key? key,
      required this.callback,
      required this.selectedDate,
      required this.text,
      this.visible = false})
      : super(key: key);

  @override
  _AppCalendarState createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late bool _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.visible;
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: thirdSize),
      child: Column(children: <Widget>[
        GestureDetector(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(widget.text, style: secondTextStyle),
            Icon(_isVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down)
          ]),
          onTap: () {
            setState(() => _isVisible = !_isVisible);
          },
        ),
        Visibility(
            visible: _isVisible,
            child: SfDateRangePicker(
                initialSelectedDate: widget.selectedDate,
                todayHighlightColor: primaryColor,
                selectionColor: primaryColor,
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                onSelectionChanged: widget.callback)),
      ]));
}
