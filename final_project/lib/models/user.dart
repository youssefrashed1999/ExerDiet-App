class User {
  // This constructor is private to prevent external object initialization.
  User._internal() {
    // Do some initialization here.
  }

  // This is the static variable that stores the instance of the class.
  static final User _instance = User._internal();

  // This is the public getter for the instance of the class.
  static User get instance => _instance;

  String _birthdate = '';
  String _gender = '';
  double _height = -1;
  double _weight = -1;
  int _dailyCaloriesNeeds = -1;
  int _caloriesIntakeToday = -1;
  int _caloriesBurnedToday = -1;
  int _dailyWaterNeeds = -1;
  int _waterIntakeToday = -1;
  double _carbsRatio = -1;
  double _fatsRatio = -1;
  double _proteinRatio = -1;
  double _carbsNeeds = -1;
  double _fatsNeeds = -1;
  double _proteinNeeds = -1;
  double _carbsIntakeToday = -1;
  double _fatsIntakeToday = -1;
  double _proteinIntakeToday = -1;
  String _activityLevel = '';
  String _goal = '';
  int _dailyStreak = -1;

  //getters
  get birthdate => _birthdate;

  get gender => _gender;

  get height => _height;

  get weight => _weight;

  int get dailyCaloriesNeeds => _dailyCaloriesNeeds;

  get caloriesIntakeToday => _caloriesIntakeToday;

  get caloriesBurnedToday => _caloriesBurnedToday;

  int get dailyWaterNeeds => _dailyWaterNeeds;

  get waterIntakeToday => _waterIntakeToday;

  get carbsRatio => _carbsRatio;

  get fatsRatio => _fatsRatio;

  get proteinRatio => _proteinRatio;

  get carbsIntakeToday => _carbsIntakeToday;

  get fatsIntakeToday => _fatsIntakeToday;

  get proteinIntakeToday => _proteinIntakeToday;

  get carbsNeeds => _carbsNeeds;

  get fatsNeeds => _fatsNeeds;

  get proteinNeeds => _proteinNeeds;

  String get activityLevel => _activityLevel;

  String get goal => _goal;

  get dailyStreak => _dailyStreak;

  //setters - not every attribute has setters
  set setDailyWaterNeeds(int value) => _dailyWaterNeeds = value;
  set setDailyCaloriesNeeds(int value) => _dailyCaloriesNeeds = value;

  // This method sets the name of the user.

  static User fromJson(Map<String, dynamic> json) {
    _instance._birthdate = json["birthdate"];
    _instance._gender = json["gender"];
    _instance._height = json["height"].toDouble();
    _instance._weight = json["weight"].toDouble();
    _instance._dailyCaloriesNeeds = json["daily_calories_needs"].toInt();
    _instance._caloriesIntakeToday = json["calories_intake_today"].toInt();
    _instance._caloriesBurnedToday = json["calories_burned_today"].toInt();
    _instance._dailyWaterNeeds = json["daily_water_needs"].toInt();
    _instance._waterIntakeToday = json["water_intake_today"].toInt();
    _instance._carbsRatio = json["carbs_ratio"].toDouble();
    _instance._fatsRatio = json["fats_ratio"].toDouble();
    _instance._proteinRatio = json["protein_ratio"].toDouble();
    _instance._carbsIntakeToday = json["carbs_intake_today"].toDouble();
    _instance._fatsIntakeToday = json["fats_intake_today"].toDouble();
    _instance._proteinIntakeToday = json["protein_intake_today"].toDouble();
    _instance._carbsNeeds = json["carbs_needs"].toDouble();
    _instance._fatsNeeds = json["fats_needs"].toDouble();
    _instance._proteinNeeds = json["protein_needs"].toDouble();
    _instance._activityLevel = json["activity_level"];
    _instance._goal = json["goal"];
    _instance._dailyStreak = json["daily_streak"].toInt();
    return _instance;
  }
}
