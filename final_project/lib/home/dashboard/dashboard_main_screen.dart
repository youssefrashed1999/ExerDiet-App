import 'package:final_project/home/dashboard/change_goal_screen.dart';
import 'package:final_project/home/dashboard/change_password_screen.dart';
import 'package:final_project/home/dashboard/change_ratios_screen.dart';
import 'package:final_project/home/dashboard/change_username_screen.dart';
import 'package:final_project/home/dashboard/set_calories_screen.dart';
import 'package:final_project/home/dashboard/set_water_intake_screen.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/open_screen.dart';
import '../../constants.dart';
import '../../models/user.dart';

class DashboardMainScreen extends StatelessWidget {
  DashboardMainScreen({super.key});
  User user = User.instance;
  void _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACCESS_KEY);
    await prefs.remove(REFRESH_KEY);
    Navigator.of(context).pushReplacementNamed(OpenScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: deviceSize.width,
            height: deviceSize.height,
            color: Colors.grey.shade200,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: deviceSize.width,
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                    title: Text(
                      'Update Personal data',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      'your streak is : ' + user.dailyStreak.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(ChangePasswordScreen.routeName),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.privacy_tip_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Change password',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(ChangeUsernameScreen.routeName),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.keyboard,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Change username',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(ChangeGoalScreen.routeName),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.track_changes,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Goal',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(SetCaloriesScreen.routeName),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.whatshot_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Custom calories',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(ChangeRatiosScreen.routeName),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Custom ratios',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(SetWaterIntakeScreen.routeName),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.water_drop_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Custom Water Intake',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: deviceSize.width * 0.7,
                child: ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
