class Note {
  String _time;
  String _dateTime;
  String _road;
  String _dayOrNight;
  String _weather;
  String _notes;
  int _id;

  Note(this._time, this._dateTime, this._dayOrNight,
      [this._road, this._weather, this._notes]);
  Note.withId(this._id, this._time, this._dateTime, this._dayOrNight,
      [this._road, this._weather, this._notes]);

  int get id => _id;
  String get time => _time;
  String get dateTime => _dateTime;
  String get road => _road;
  String get dayOrNight => _dayOrNight;
  String get weather => _weather;
  String get notes => _notes;
  set time(String t) {
    this._time = t;
  }
  set dateTime(String t) {
    this._dateTime = t;
  }
  set road(String t) {
    this._road = t;
  }
  set weather(String t) {
    this._weather = t;
  }
  set dayOrNight(String t) {
    this._dayOrNight = t;
  }
  set notes(String t) {
    this._notes = t;
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['time'] = _time;
    map["date"] = _dateTime;
    map['dayOrNight'] = _dayOrNight;
    if (road != null) map['road'] = _road;
    if (weather != null) map['weather'] = _weather;
    if (notes != null) map['notes'] = _notes;
    return map;
  }
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._time = map['time'];
    this._dateTime = map["date"];
    this._road = map['road'];
    this._weather = map['weather'];
    this._dayOrNight = map['dayOrNight'];
    this._notes = map['notes'];
  }
}
