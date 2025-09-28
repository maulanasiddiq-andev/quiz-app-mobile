String formatTime(int seconds) {
  var minute = (seconds ~/ 60).toString().padLeft(2, '0');
  var second = (seconds % 60).toString().padLeft(2, '0');

  return '$minute:$second';
}