import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../models/user.dart';

class DashboardMainScreen extends StatelessWidget {
  DashboardMainScreen({super.key});
  User _user = User.instance;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: deviceSize.width,
            height: deviceSize.height,
            color: Colors.white,
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
                      'Rashood',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    subtitle: Text(
                      '3 days streak',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Padding(
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Padding(
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Padding(
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Padding(
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Padding(
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
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
