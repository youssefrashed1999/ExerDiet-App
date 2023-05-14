import 'dart:async';
import 'dart:convert';

import 'package:final_project/auth/open_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_kit/survey_kit.dart' as Survey;
import 'package:survey_kit/survey_kit.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../home/home_page_screen.dart';

class HealthQuizScreen extends StatefulWidget {
  static const routeName = '/health-quiz-screen';
  const HealthQuizScreen({super.key});

  @override
  State<HealthQuizScreen> createState() => _HealthQuizScreenState();
}

class _HealthQuizScreenState extends State<HealthQuizScreen> {
  Map<String, dynamic> _userAnswers = {
    'birthdate': '',
    'gender': '',
    'height': 0.0,
    'weight': 0.0,
    'activity_level': '',
    'goal': '',
  };
  void _SaveUserResults(SurveyResult result) {
    _userAnswers['goal'] = result.results[1].results[0].valueIdentifier;
    _userAnswers['activity_level'] =
        result.results[2].results[0].valueIdentifier;
    _userAnswers['gender'] = result.results[3].results[0].valueIdentifier;
    _userAnswers['weight'] = result.results[4].results[0].valueIdentifier;
    _userAnswers['height'] = result.results[5].results[0].valueIdentifier;
    _userAnswers['birthdate'] = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(result.results[6].results[0].valueIdentifier!));
    print(_userAnswers);
  }

  void _sendHttpRequest() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessKey = prefs.getString(ACCESS_KEY);
      final response = await http.post(
        Uri.parse('${BASE_URL}core/trainees/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
        body: jsonEncode(<String, String?>{
          "birthdate": _userAnswers['birthdate'],
          "gender": _userAnswers['gender'],
          "height": _userAnswers['height'],
          "weight": _userAnswers['weight'],
          "activity_level": _userAnswers['activity_level'],
          "goal": _userAnswers['goal']
        }),
      );
      //account created
      if (response.statusCode == 201) {
        //request user's info from server
        int status = await getUserInfo();
        if (status == 1) {
          if (!context.mounted) return;
          Navigator.of(context).pushReplacementNamed(HomePageScreen.routeName);
        }
        //display toast if otherwise
        else {
          Fluttertoast.showToast(
              msg:
                  'Error occurred while retreiving user\'s information!\nTry again later.',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.white,
              textColor: MY_COLOR[300]);
        }
      }
      //bad data sent
      else if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: 'Data sent had an error!Please take the quiz again.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        Timer(const Duration(seconds: 2), () {});
      } else if (response.statusCode == 500) {
        Fluttertoast.showToast(
            msg: 'Server is down at the moment!\nTry again later.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      }
    } catch (_) {}
  }

  ThemeData theme = ThemeData(
    primarySwatch: const MaterialColor(
      0xFF61DBD5,
      <int, Color>{
        50: Color(0x0061DBD5),
        100: Color(0xFF61DBD5),
        200: Colors.white,
        300: Color(0xFF61DBD5),
        400: Color(0xFF61DBD5),
        500: Color(0xFF61DBD5),
        600: Color(0xFF61DBD5),
        700: Color(0xFF61DBD5),
        800: Color(0xFF61DBD5),
        900: Color(0xFF61DBD5),
      },
    ),
    textTheme: const TextTheme(
      displayMedium: TextStyle(fontSize: 28, fontFamily: 'RobotoCondensed'),
      headlineMedium: TextStyle(
          fontSize: 16,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          fontSize: 14, fontFamily: 'RobotoCondensed', color: Colors.grey),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final SurveyController surveyController = SurveyController();
    return Scaffold(
      body: SurveyKit(
        themeData: theme,
        surveyController: surveyController,
        showProgress: false,
        onResult: (SurveyResult result) {
          //save
          if (result.finishReason == FinishReason.COMPLETED) {
            _SaveUserResults(result);
            _sendHttpRequest();
          } else {
            Navigator.of(context).pushReplacementNamed(OpenScreen.routeName);
          }
        },
        localizations: const {'cancel': 'Cancel', 'next': 'Next'},

        //surveyProgressbarConfiguration: SurveyProgressConfiguration(),
        task: OrderedTask(id: TaskIdentifier(), steps: [
          InstructionStep(
            title: 'Welcome to\nExerDiet\nHealth Survey',
            text: 'Your journey starts now!',
            buttonText: 'Let\'s go!',
          ),
          QuestionStep(
              title: 'What goal do you have in mind?',
              answerFormat: const SingleChoiceAnswerFormat(textChoices: [
                TextChoice(text: 'Lose Weight', value: 'L'),
                TextChoice(text: 'Keep Weight', value: 'K'),
                TextChoice(text: 'Gain Weight', value: 'G'),
              ]),
              isOptional: false),
          QuestionStep(
              title: 'What is your activity level?',
              answerFormat: const SingleChoiceAnswerFormat(textChoices: [
                TextChoice(
                    text: 'Extra',
                    subText:
                        'Very hard exercise or sports, physical job or training',
                    value: 'E'),
                TextChoice(
                    text: 'High',
                    subText: 'Hard exercise or sports 6-7 days/week',
                    value: 'H'),
                TextChoice(
                    text: 'medium',
                    subText: 'Moderate exercise or sports 3-5 days/week',
                    value: 'M'),
                TextChoice(
                    text: 'low',
                    subText: 'Light exercise or sports 1-3 days/week',
                    value: 'L'),
                TextChoice(
                    text: 'None', subText: 'Little or no exercise', value: 'N'),
                TextChoice(
                    text: 'Tracked',
                    subText: 'Track your activity',
                    value: 'T'),
              ]),
              isOptional: false),
          QuestionStep(
              title: 'What is your gender?',
              answerFormat: const SingleChoiceAnswerFormat(textChoices: [
                TextChoice(text: 'Male', value: 'M'),
                TextChoice(text: 'Female', value: 'F'),
              ]),
              isOptional: false),
          QuestionStep(
              title: 'What is your weight in Kg?',
              answerFormat: const IntegerAnswerFormat(hint: 'Enter you weight'),
              isOptional: false),
          QuestionStep(
              title: 'What is your height in cm?',
              answerFormat: const IntegerAnswerFormat(hint: 'Enter you height'),
              isOptional: false),
          QuestionStep(
            title: 'What is your birthdate?',
            answerFormat: DateAnswerFormat(
                defaultDate: DateTime.now(),
                maxDate: DateTime.now(),
                minDate: DateTime(1900, 1, 1, 0, 0)),
            isOptional: false,
          ),
          CompletionStep(
            stepIdentifier: StepIdentifier(),
            text: 'Thanks for taking the survey\nLet\'s begin the journy!',
            title: 'Done!',
            buttonText: 'Submit survey',
          ),
        ]),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
