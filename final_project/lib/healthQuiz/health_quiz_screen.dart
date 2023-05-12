import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart' as Survey;
import 'package:survey_kit/survey_kit.dart';

class HealthQuizScreen extends StatefulWidget {
  static const routeName = '/health-quiz-screen';
  const HealthQuizScreen({super.key});

  @override
  State<HealthQuizScreen> createState() => _HealthQuizScreenState();
}

class _HealthQuizScreenState extends State<HealthQuizScreen> {
  Map _userAnswers = {
    0: '',
    1: '',
    2: '',
    3: 0.0,
    4: 0.0,
  };
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
          print(result.results[1].results);
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
                TextChoice(text: 'Lose Weight', value: 'lose weight'),
                TextChoice(text: 'Maintain Weight', value: 'maintain weight'),
                TextChoice(text: 'Gain Weight', value: 'gain weight'),
              ]),
              isOptional: false),
          QuestionStep(
              title: 'What is your activity level?',
              answerFormat: const SingleChoiceAnswerFormat(textChoices: [
                TextChoice(
                    text: 'None',
                    subText: 'Little or no exercise',
                    value: 'low'),
                TextChoice(
                    text: 'low',
                    subText: 'Light exercise 1-3 days/week',
                    value: 'low'),
                TextChoice(
                    text: 'medium',
                    subText: 'Moderate exercise 3-5 days/week',
                    value: 'medium'),
                TextChoice(
                    text: 'High',
                    subText: 'Hard exercise 6-7 days/week',
                    value: 'high'),
                TextChoice(
                    text: 'Extra',
                    subText: 'Very hard exercise or physical job',
                    value: 'high'),
              ]),
              isOptional: false),
          QuestionStep(
              title: 'What is your gender?',
              answerFormat: const SingleChoiceAnswerFormat(textChoices: [
                TextChoice(text: 'Male', value: 'female'),
                TextChoice(text: 'Female', value: 'male'),
              ]),
              isOptional: false),
          QuestionStep(
              title: 'What is your weight in Kg?',
              answerFormat: const ScaleAnswerFormat(
                  maximumValue: 300,
                  minimumValue: 0,
                  defaultValue: 70,
                  step: 1,
                  minimumValueDescription: '0 Kg',
                  maximumValueDescription: '300 Kg'),
              isOptional: false),
          QuestionStep(
              title: 'What is your height in cm?',
              answerFormat: const ScaleAnswerFormat(
                  maximumValue: 300,
                  minimumValue: 0,
                  defaultValue: 70,
                  step: 1,
                  minimumValueDescription: '0 cm',
                  maximumValueDescription: '300 cm'),
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
