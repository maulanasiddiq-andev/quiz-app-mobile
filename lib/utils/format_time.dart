String formatTime(int? seconds) {
  if (seconds == null) {
    return "--:--";
  }
  
  var minute = (seconds ~/ 60).toString().padLeft(2, '0');
  var second = (seconds % 60).toString().padLeft(2, '0');

  return '$minute:$second';
}