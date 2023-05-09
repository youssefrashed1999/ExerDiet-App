import 'package:final_project/constants.dart';
import 'package:final_project/home/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:im_stepper/stepper.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

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
  Widget createStepWidget(
      BuildContext context, String question, List<String> answers) {
    final deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.width * 0.9,
      height: deviceSize.height * 0.5,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(deviceSize.width * 0.05),
                child: Center(
                  child: Text(
                    question,
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: MY_COLOR.shade700),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: deviceSize.width * 0.05),
                child: GroupButton(
                  controller: _groupButtonController,
                  buttons: answers,
                  isRadio: true,
                  onSelected: (value, index, isSelected) {
                    _userAnswers[_activeStep] = value;
                    _ispressed = true;
                    setState(() {});
                  },
                  options: GroupButtonOptions(
                      buttonWidth: MediaQuery.of(context).size.width * 0.8,
                      borderRadius: BorderRadius.circular(30),
                      direction: Axis.vertical,
                      selectedTextStyle: const TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 16,
                          color: Colors.black),
                      unselectedTextStyle: const TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 16,
                          color: Colors.black),
                      unselectedColor: MY_COLOR.shade50.withOpacity(0.3),
                      selectedColor: MY_COLOR.shade900),
                ),
              )
            ],
          )),
    );
  }

  Widget createWeightAndHeightWidget(BuildContext context, String question,
      String unit, double initialWeight, int minWeight, double interval) {
    final deviceSize = MediaQuery.of(context).size;
    _ispressed = true;
    return SizedBox(
      width: deviceSize.width * 0.9,
      height: deviceSize.height * 0.5,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(deviceSize.height * 0.05),
                child: Center(
                  child: Text(
                    question,
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: MY_COLOR.shade700),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '$_saver $unit',
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: MY_COLOR.shade700),
                ),
              ),
              VerticalWeightSlider(
                height: deviceSize.height * 0.3,
                controller: WeightSliderController(
                    initialWeight: initialWeight,
                    minWeight: minWeight,
                    interval: interval),
                decoration: PointerDecoration(
                  width: deviceSize.width * 0.4,
                  height: 3.0,
                  largeColor: const Color(0xFF898989),
                  mediumColor: const Color(0xFFC5C5C5),
                  smallColor: const Color(0xFFF0F0F0),
                ),
                onChanged: (double value) {
                  setState(() {
                    _userAnswers[_activeStep] = value;
                    _saver = value;
                  });
                },
                indicator: Container(
                  height: 3.0,
                  width: deviceSize.width * 0.6,
                  alignment: Alignment.centerLeft,
                  color: MY_COLOR.shade700,
                ),
              )
            ],
          )),
    );
  }

  Widget getSteps(BuildContext context) {
    const goalQuestion = 'What goal do you have in mind?';
    const goalAnswers = ['Lose weight', 'Maintain weight', 'Gain weight'];

    const activityQuestion = 'What is your activity level?';
    const activityAnswers = ['Low', 'Medium', 'High'];

    const genderQuestion = 'What is your gender?';
    const genderAnswers = ['Male', 'Female'];
    Widget step;
    switch (_activeStep) {
      case 0:
        step = createStepWidget(context, goalQuestion, goalAnswers);
        break;
      case 1:
        step = createStepWidget(context, activityQuestion, activityAnswers);
        break;
      case 2:
        step = createStepWidget(context, genderQuestion, genderAnswers);
        break;
      case 3:
        step = createWeightAndHeightWidget(
            context, 'What is your weight?', 'Kg', 70, 0, 0.1);
        break;
      case 4:
        step = createWeightAndHeightWidget(
            context, 'What is your height?', 'Cm', 170, 0, 1);

        break;
      default:
        step = Container();
    }
    return step;
  }

  Widget controlButtons(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_activeStep != 0)
          SizedBox(
            width: deviceSize.width * 0.4,
            child: ElevatedButton(
              onPressed: previousQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
              child: Text('Back', style: TextStyle(color: MY_COLOR.shade700)),
            ),
          ),
        SizedBox(
          width: _activeStep == 0
              ? deviceSize.width * 0.9
              : deviceSize.width * 0.4,
          child: ElevatedButton(
            onPressed: _ispressed ? nextQuestion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: MY_COLOR.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            ),
            child: Text(_activeStep == _dotCount - 1 ? 'Finish' : 'Next',
                style: const TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  void nextQuestion() {
    if (_activeStep < _dotCount - 1) {
      _activeStep++;
      if (_activeStep == 3) {
        _saver = _weightSliderController.initialWeight;
        //_weightSliderController.jumpTo(_weightSliderController.initialWeight);
      }
      if (_activeStep == 4) {
        _saver = _heightSliderController.initialWeight;
        //_heightSliderController.jumpTo(_heightSliderController.initialWeight);
      }
      _groupButtonController.unselectAll();
      _ispressed = false;
    }
    if (_activeStep == _dotCount - 1) {
      //TO-DO
      //handle saving quiz answers
      Navigator.of(context).pushReplacementNamed(HomePageScreen.routeName);
    }
    setState(() {});
  }

  void previousQuestion() {
    _activeStep--;
    setState(() {});
  }

  bool _ispressed = false;
  int _activeStep = 0;
  final _dotCount = 5;
  final _groupButtonController = GroupButtonController();
  final _weightSliderController =
      WeightSliderController(initialWeight: 70, minWeight: 0, interval: 0.1);
  final _heightSliderController =
      WeightSliderController(initialWeight: 170, minWeight: 0, interval: 1);
  double _saver = 0.0;
  @override
  Widget build(BuildContext context) {
    //List<Widget> steps = getSteps(context);
    return Scaffold(
      body: Container(
        decoration: BOX_DECORATION,
        height: double.infinity,
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getSteps(context),
              controlButtons(context),
              DotStepper(
                activeStep: _activeStep,
                dotCount: _dotCount,
                dotRadius: 6,
                spacing: 6,
                shape: Shape.circle,
                fixedDotDecoration: const FixedDotDecoration(
                    color: Colors.white, strokeColor: Colors.white),
                indicator: Indicator.worm,
                indicatorDecoration: IndicatorDecoration(
                    color: MY_COLOR.shade700, strokeColor: MY_COLOR.shade900),
              ),
            ]),
      ),
    );
  }
}
