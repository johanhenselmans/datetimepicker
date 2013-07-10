import 'package:web_ui/web_ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_browser.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbols.dart';
import 'dart:html';
import 'dart:async';

class XDateTimeInput extends WebComponent{  
  @observable
  static bool initializing = false;
  @observable
  static bool initialized = false;
  @observable
  static int firstDayOfWeek;
  @observable
  static List<String> monthTexts;
  @observable
  static List<String> weekdayTexts;
  DateTime today = new DateTime.now();
  @observable
  bool showDiv=false;
  @observable
  bool closing=false;
  Timer timer;
  @observable
  String inputid="";
  @observable
  String inputplaceholder="";
  @observable
  int inputmaxlength=9999;
  @observable
  String value;
  @observable
  DateTime date = new DateTime.now();
  @observable
  List get calendarList{
    DateTime first = new DateTime(date.year,date.month,1);
    DateTime last = new DateTime(date.year,date.month+1,1).subtract(new Duration(days:1));
    List<List<int>> calendarList = []; 
    List<int> weekList = [null,null,null,null,null,null,null];
    int pos = first.weekday-firstDayOfWeek;
    if(pos>=7)
      pos-=7;
    if(pos<0)
      pos+=7;
    for(int i=1;i<=last.day;i++){      
      weekList[pos]=i;
      pos++;
      if(pos>=7){
        calendarList.add(weekList);
        weekList = [null,null,null,null,null,null,null];
        pos=0;
      }
    }
    if(pos>0)
      calendarList.add(weekList);
    return calendarList;
  }
  bool isToday(int day){
    if(date.year==today.year&&date.month==today.month&&day==today.day)
      return true;
    else
      return false;
  }
  void chooseDay(int day){
    date=new DateTime(date.year, date.month, day, date.hour, date.minute);
    value=date.toString().substring(0,16);
    showDiv=false;
  }
  void onValueChange(){
    try{
      date = DateTime.parse(value);
    }catch(e){
      date = new DateTime.now();
    }
  }
  void show(){
    onValueChange();
    showDiv=true;
    closing=false;
  }
  void close(){
    closing=true;
    if(timer!=null)
      timer.cancel();
    timer = new Timer(new Duration(seconds:1), (){
      if(closing){
        showDiv=false;
      }
    });
  }
  void previousYear(){
    closing=false;
    date = new DateTime(date.year-1, date.month,date.day,date.hour,date.minute,1);
    value=date.toString().substring(0,16);
    this.host.query("input").focus();
  }
  void nextYear(){
    closing=false;
    date = new DateTime(date.year+1, date.month,date.day,date.hour,date.minute,1);
    value=date.toString().substring(0,16);
    this.host.query("input").focus();    
  }
  void previousMonth(){
    closing=false;
    date = new DateTime(date.year, date.month-1,date.day,date.hour,date.minute, 1);
    value=date.toString().substring(0,16);
    this.host.query("input").focus();    
  }
  void nextMonth(){
    closing=false;
    date = new DateTime(date.year, date.month+1,date.day,date.hour,date.minute, 1);
    value=date.toString().substring(0,16);
    this.host.query("input").focus();    
  }
  void previousHour(){
    closing=false;
    date = new DateTime(date.year, date.month, date.day, date.hour-1,date.minute,1);
    value=date.toString().substring(0,16);
    this.host.query("input").focus();    
  }
  void nextHour(){
    closing=false;
    date = new DateTime(date.year, date.month, date.day, date.hour+1,date.minute,1);
    value=date.toString().substring(0,16);
    this.host.query("input").focus();    
  }
  void previousMinute(){
    closing=false;
    date = new DateTime(date.year, date.month, date.day, date.hour,date.minute-1,1);
    value=date.toString().substring(0,16);
    this.host.query("input").focus();    
  }
  void nextMinute(){
    closing=false;
    date = new DateTime(date.year, date.month, date.day, date.hour,date.minute+1,1);
    value=date.toString().substring(0,16);
    this.host.query("input").focus();    
  }
  String get monthText{
    return monthTexts[date.month-1];
  }
  void _initializeTexts(DateSymbols ds){
    firstDayOfWeek = ds.FIRSTDAYOFWEEK;    
    weekdayTexts = [];
    for(int i=0; i<7; i++){
      int k = firstDayOfWeek+i;
      if(k>=7)
        k = k - 7;
      weekdayTexts.add(ds.STANDALONESHORTWEEKDAYS[k]);
    }
    monthTexts = ds.STANDALONESHORTMONTHS;
  }
  
  void created(){    
    if(!initializing){
      initializing = true;
      findSystemLocale().then((_){
        initializeDateFormatting(Intl.systemLocale, null).then((_){
          _initializeTexts(new DateFormat.E().dateSymbols);
          initialized = true;
        });        
      });
    }
  }
}
