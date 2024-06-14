String displayDateDifferenceFromTodayWithMS(DateTime inputTime) {
  final d = inputTime;
  final now = DateTime.now();
  final diff = now.difference(d);
  final diffInYear = (diff.inDays / 365).floor();
  final diffInMonth = (diff.inDays / 30).floor();
  final diffInWeeks = (diff.inDays / 7).floor();
  if (diffInYear >= 1) {
    return '$diffInYear yr ago';
  } else if (diffInMonth >= 1) {
    return '$diffInMonth month ago';
  } else if (diffInWeeks >= 1) {
    return '$diffInWeeks week ago';
  } else if (diff.inDays >= 1) {
    return '${diff.inDays} days ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} min ago';
  } else if (diff.inSeconds >= 3) {
    return '${diff.inSeconds} sec ago';
  } else {
    return 'now';
  }
}
