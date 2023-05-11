class Singleton {
  // This constructor is private to prevent external object initialization.
  Singleton._internal() {
    // Do some initialization here.
  }

  // This is the static variable that stores the instance of the class.
  static final Singleton _instance = Singleton._internal();

  // This is the public getter for the instance of the class.
  static Singleton get instance => _instance;

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
  double _carbsGrams = -1;
  double _fatsGrams = -1;
  double _proteinGrams = -1;
  String _activityLevel = '';
  String _goal = '';
  int _dailyStrak = -1;

  //getters
  get birthdate => _birthdate;

  get gender => _gender;

  get height => _height;

  get weight => _weight;

  get dailyCaloriesNeeds => _dailyCaloriesNeeds;

  get caloriesIntakeToday => _caloriesIntakeToday;

  get caloriesBurnedToday => _caloriesBurnedToday;

  get dailyWaterNeeds => _dailyWaterNeeds;

  get waterIntakeToday => _waterIntakeToday;

  get carbsRatio => _carbsRatio;

  get fatsRatio => _fatsRatio;

  get proteinRatio => _proteinRatio;

  get carbsGrams => _carbsGrams;

  get fatsGrams => _fatsGrams;

  get proteinGrams => _proteinGrams;

  get activityLevel => _activityLevel;

  get goal => _goal;

  get dailyStrak => _dailyStrak;

  // This method sets the name of the user.

  static Singleton fromJson(Map<String, dynamic> json) {
    _instance._birthdate = json["birthdate"];
    _instance._gender = json["gender"];
    _instance._height = json["height"];
    _instance._weight = json["weight"];
    _instance._dailyCaloriesNeeds = json["daily_calories_needs"];
    _instance._caloriesIntakeToday = json["calories_intake_today"];
    _instance._caloriesBurnedToday = json["calories_burned_today"];
    _instance._dailyWaterNeeds = json["daily_water_needs"];
    _instance._waterIntakeToday = json["water_intake_today"];
    _instance._carbsRatio = json["carbs_ratio"];
    _instance._fatsRatio = json["fats_ratio"];
    _instance._proteinRatio = json["protein_ratio"];
    _instance._carbsGrams = json["carbs_grams"];
    _instance._fatsGrams = json["fats_grams"];
    _instance._proteinGrams = json["protein_grams"];
    _instance._activityLevel = json["activity_level"];
    _instance._goal = json["goal"];
    _instance._dailyStrak = json["daily_streak"];
    return _instance;
  }
}
