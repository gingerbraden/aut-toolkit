class EatingHabit {
  DateTime? _from;
  DateTime? _to;
  bool? _isEatingFlag;
  String? _name;
  String? _description;

  DateTime? get from => _from;

  set from(DateTime value) {
    _from = value;
  }

  DateTime? get to => _to;

  String? get description => _description;

  set description(String value) {
    _description = value;
  }

  String? get name => _name;

  set name(String value) {
    _name = value;
  }

  bool? get isEatingFlag => _isEatingFlag;

  set isEatingFlag(bool value) {
    _isEatingFlag = value;
  }

  set to(DateTime value) {
    _to = value;
  }
}
