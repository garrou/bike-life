import 'package:bike_life/styles/general.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppCalendar extends StatefulWidget {
  final String selectedDate;
  final Function(DateRangePickerSelectionChangedArgs args) callback;
  const AppCalendar(
      {Key? key, required this.callback, required this.selectedDate})
      : super(key: key);

  @override
  _AppCalendarState createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        GestureDetector(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(_isVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            Text("Date d'achat", style: secondTextStyle)
          ]),
          onTap: () {
            setState(() {
              _isVisible = _isVisible ? false : true;
            });
          },
        ),
        Visibility(
            visible: _isVisible,
            child: SfDateRangePicker(
                initialSelectedDate: DateTime.parse(widget.selectedDate),
                todayHighlightColor: deepGreen,
                selectionColor: deepGreen,
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                onSelectionChanged: widget.callback))
      ]);
}
