import 'package:flutter/material.dart';

class DateSelectionDialog extends StatefulWidget {
  const DateSelectionDialog({super.key});

  @override
  _DateSelectionDialogState createState() => _DateSelectionDialogState();
}

class _DateSelectionDialogState extends State<DateSelectionDialog> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          _selectDate(context);
        },
        child: SizedBox(
          width: 230,
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
              isDense: true,
              suffixIcon: Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text: '${selectedDate.toLocal()}'.split(' ')[0],
            ),
            enabled: false,
          ),
        ),
      ),
    );
  }
}
