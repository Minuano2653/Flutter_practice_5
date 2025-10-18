extension DateFormatting on DateTime {
  String toFormattedDate() {
    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';
  }
}