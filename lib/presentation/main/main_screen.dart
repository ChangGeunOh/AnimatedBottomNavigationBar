import 'package:animated_bottom/common/const/rive_bottom.dart';
import 'package:animated_bottom/common/utils/rive_utils.dart';
import 'package:animated_bottom/domain/rive_data.dart';
import 'package:animated_bottom/presentation/bell/bell_screen.dart';
import 'package:animated_bottom/presentation/chat/chat_screen.dart';
import 'package:animated_bottom/presentation/component/animated_bar_item.dart';
import 'package:animated_bottom/presentation/search/search_screen.dart';
import 'package:animated_bottom/presentation/timer/timer_screen.dart';
import 'package:animated_bottom/presentation/user/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int indexSelected = 0;

  void tabListener() {
    setState(() {
      indexSelected = controller.index;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: bottomNavs.length, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: Color(0xff324a5c),
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                bottomNavs.length,
                (index) => GestureDetector(
                  onTap: () {
                    controller.animateTo(index);
                    bottomNavs[index].input!.change(true);
                    Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        bottomNavs[index].input!.change(false);
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBarItem(
                          isActive: index == indexSelected),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: Opacity(
                          opacity: index == indexSelected ? 1 : 0.5,
                          child: RiveAnimation.asset(
                            bottomNavs.first.src,
                            artboard: bottomNavs[index].artboard,
                            onInit: (artboard) {
                              StateMachineController controller =
                                  RiveUtils.getRiveController(
                                artboard,
                                stateMachineName:
                                    bottomNavs[index].stateMachineName,
                              );
                              bottomNavs[index].input =
                                  controller.findSMI('active') as SMIBool;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          ChatScreen(),
          SearchScreen(),
          TimerScreen(),
          BellScreen(),
          UserScreen(),
        ],
      ),
    );
  }
}



