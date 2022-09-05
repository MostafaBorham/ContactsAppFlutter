import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class SimBoardPage extends StatefulWidget {
  const SimBoardPage({Key? key}) : super(key: key);

  @override
  State<SimBoardPage> createState() => _SimBoardPageState();
}

class _SimBoardPageState extends State<SimBoardPage> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return _buildPage();
  }

  Widget _buildPage() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIMBoard',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sim_card_outlined,
                        color: Colors.white54,
                        size: screenSize.height * 0.1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Please grant SIMBoard relevant permissions',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.white54),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          AppSettings.openDeviceSettings();
                        },
                        style: TextButton.styleFrom(primary: Colors.green),
                        child: const Text('TURN ON'),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
