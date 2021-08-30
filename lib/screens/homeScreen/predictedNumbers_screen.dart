import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './predictedNumbersView.dart';
import './notSubscribedView.dart';
import '../../provider/userDataProvider.dart';

class PredictedNumbers extends StatefulWidget {
  final AnimationController mainScreenAnimationController;

  PredictedNumbers({required this.mainScreenAnimationController});

  @override
  _PredictedNumbersState createState() => _PredictedNumbersState();
}

class _PredictedNumbersState extends State<PredictedNumbers>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  
  @override
  void initState() {
    animationController = widget.mainScreenAnimationController;
    animationController.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: Consumer<UserDataProvider>(
        builder: (context, userData, _) {
          if (userData.user.isSubscribed == 0) {
            return NotSubscribed();
          }
          return PredictedNumbersView();
        },
      ),
      builder: (context, child) {
        return FadeTransition(
          opacity: animation as Animation<double>,
          child: Transform(
            transform:
                Matrix4.translationValues(0, 30 * (1.0 - animation.value), 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Your Recommeded Numbers',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                  child: Container(
                    //height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(80.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*/*  borderRadius: BorderRadius.all(
                                          Radius.circular(100.0),
                                        ),*/ */
/*140 +(360 - 140) * (1.0 - animation.value) */

/*
Color(0xFF2633C5),
HexColor("#8A98E8"),
HexColor("#8A98E8") */
//30 * (1.0 - animation.value)
