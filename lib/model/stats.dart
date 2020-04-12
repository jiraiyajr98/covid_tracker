class Stats {
  String _get;
  int _results;
  List<Response> _response;

  Stats({String get, int results, List<Response> response}) {
    this._get = get;
    this._results = results;
    this._response = response;
  }

  String get get => _get;
  set get(String get) => _get = get;
  int get results => _results;
  set results(int results) => _results = results;
  List<Response> get response => _response;
  set response(List<Response> response) => _response = response;

  Stats.fromJson(Map<String, dynamic> json) {
    _get = json['get'];
    _results = json['results'];
    if (json['response'] != null) {
      _response = new List<Response>();
      json['response'].forEach((v) {
        _response.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['get'] = this._get;
    data['results'] = this._results;
    if (this._response != null) {
      data['response'] = this._response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String _country;
  Cases _cases;
  Deaths _deaths;
  Deaths _tests;
  String _day;
  String _time;

  Response(
      {String country,
        Cases cases,
        Deaths deaths,
        Deaths tests,
        String day,
        String time}) {
    this._country = country;
    this._cases = cases;
    this._deaths = deaths;
    this._tests = tests;
    this._day = day;
    this._time = time;
  }

  String get country => _country;
  set country(String country) => _country = country;
  Cases get cases => _cases;
  set cases(Cases cases) => _cases = cases;
  Deaths get deaths => _deaths;
  set deaths(Deaths deaths) => _deaths = deaths;
  Deaths get tests => _tests;
  set tests(Deaths tests) => _tests = tests;
  String get day => _day;
  set day(String day) => _day = day;
  String get time => _time;
  set time(String time) => _time = time;

  Response.fromJson(Map<String, dynamic> json) {
    _country = json['country'];
    _cases = json['cases'] != null ? new Cases.fromJson(json['cases']) : null;
    _deaths =
    json['deaths'] != null ? new Deaths.fromJson(json['deaths']) : null;
    _tests = json['tests'] != null ? new Deaths.fromJson(json['tests']) : null;
    _day = json['day'];
    _time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this._country;
    if (this._cases != null) {
      data['cases'] = this._cases.toJson();
    }
    if (this._deaths != null) {
      data['deaths'] = this._deaths.toJson();
    }
    if (this._tests != null) {
      data['tests'] = this._tests.toJson();
    }
    data['day'] = this._day;
    data['time'] = this._time;
    return data;
  }
}

class Cases {
  int _active;
  int _critical;
  int _recovered;
  int _total;

  Cases({int active, int critical, int recovered, int total}) {
    this._active = active;
    this._critical = critical;
    this._recovered = recovered;
    this._total = total;
  }

  int get active => _active;
  set active(int active) => _active = active;
  int get critical => _critical;
  set critical(int critical) => _critical = critical;
  int get recovered => _recovered;
  set recovered(int recovered) => _recovered = recovered;
  int get total => _total;
  set total(int total) => _total = total;

  Cases.fromJson(Map<String, dynamic> json) {
    _active = json['active'];
    _critical = json['critical'];
    _recovered = json['recovered'];
    _total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this._active;
    data['critical'] = this._critical;
    data['recovered'] = this._recovered;
    data['total'] = this._total;
    return data;
  }
}

class Deaths {
  int _total;

  Deaths({int total}) {
    this._total = total;
  }

  int get total => _total;
  set total(int total) => _total = total;

  Deaths.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    return data;
  }
}
