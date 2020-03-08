
class CommonFunctions{
  static String formatTime(DateTime time){
    String myTime =
      (time.hour > 12 ? (time.hour - 12).toString() : time.hour.toString()) +
          ":" +
          time.minute.toString() +
          (time.hour > 12 ? " PM" : " AM");
  return myTime;
  }
}