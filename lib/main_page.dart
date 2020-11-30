import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'leopard_page.dart';
import 'styles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PageOffsetNotifier with ChangeNotifier {
  double _offset;
  double _page;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }
  double get offset => _offset;
  double get page => _page;
}

// class MapAnimationNotifier with ChangeNotifier{
//   AnimationController _animationController;
//   MapAnimationNotifier(this._animationController){
//     //print('sssssssssss' + _animationController.toString());
//     _animationController.addListener(_onAnimationControllerChanged);
//   }
//
//   void _onAnimationControllerChanged(){
//     notifyListeners();
//   }
//
//   double get value => _animationController.value;
//
//   void forward() => _animationController.forward();
//   @override
//   void dispose() {
//     _animationController.removeListener(_onAnimationControllerChanged);
//     super.dispose();
//   }
// }

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  double get maxHeight => 400.0 + 32 + 24;
  final PageController _pageController = PageController();
  AnimationController _animationController;
  AnimationController _mapAnimationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 1000),
    );
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('bbb' + _animationController.value.toString());
    return ChangeNotifierProvider(
      builder: (_) {
        print('aaa');
        return PageOffsetNotifier(_pageController);
      },
      child: ListenableProvider.value(
        value: _animationController,
        child: Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView(
                    controller: _pageController,
                    physics: ClampingScrollPhysics(),
                    children: [
                      // Text('text 1'),
                      // Text('text 2'),
                      LeopardPage(),
                      VulturePage(),
                    ],
                  ),
                  LeopardImage(),
                  VultureImage(),
                  AppBar(),
                  ShareButton(),
                  PageIndicator(),
                  ArrowIcon(),
                  TravelDetailsLabel(),
                  StartCampLabel(),
                  StartTimeLabel(),
                  BaseCampLabel(),
                  BaseTimeLabel(),
                  DistanceLabel(),
                  HorizontalTravelDots(),
                  MapButton(),
                  VerticalTravelDots(),
                  VultureIconLabel(),
                  LeopardIconLabel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details){
    _animationController.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details){
    if(_animationController.isAnimating || _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;
    if(flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));

    else if(flingVelocity > 0.0)
      _animationController.fling(velocity: math.max(-2.0, -flingVelocity));

    else
      _animationController.fling(velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Row(
          children: [
            Text(
              'SY',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Spacer(),
            Icon(
              Icons.menu,
            ),
          ],
        ),
      ),
    );
  }
}

class VultureImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        //print(notifier.offset);
        return Positioned(
          left:
              1.25 * MediaQuery.of(context).size.width - 0.88 * notifier.offset,
          child: Transform.scale(
            scale: 1 - 0.1 * animation.value,
            child: Opacity(
              opacity: 1 - 0.6 * animation.value,
              child: child,
            ),
          ),
        );
      },
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 90.0),
          child: Image(
            image: AssetImage('assets/vulture.png'),
            height: MediaQuery.of(context).size.height / 3,
          ),
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() == 0 ? white : lightGrey,
                  ),
                  height: 8,
                  width: 8,
                ),
                SizedBox(
                  width: 18,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() != 0 ? white : lightGrey,
                  ),
                  height: 8,
                  width: 8,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ArrowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child){
        return Positioned(
          top: 128.0 + (1 - animation.value) * ( 400 + 32 - 4),
          right: 24,
          child: child,
        );
      },
      child: Icon(Icons.keyboard_arrow_up),
    );
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20.0,
      bottom: 16.0,
      child: Icon(Icons.share),
    );
  }
}

class VulturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: VultureCircle());
  }
}


class TravelDetailsLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          top: 128.0 + (1 - animation.value) * (400 + 32 - 4),
          left: 24 + MediaQuery.of(context).size.width - notifier.offset,
          child: Opacity(
              opacity: math.max(0, 4 * notifier.page - 3), child: child),
        );
      },
      child: Text(
        'Travel Details',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}

class StartCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 126.0 + 400 + 32 + 24 + 16,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          left: opacity * 24.0,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Start Camp',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class StartTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 126.0 + 400 + 32 + 24 + 16 + 40,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          left: opacity * 24.0,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '02:40 pm',
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      ),
    );
  }
}

class BaseCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 128.0 +32 + 16 + 4 + (1 - animation.value) * (400 + 32 - 4),
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Base Camp',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class BaseTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 128.0 +32 + 16 + 44 + (1 - animation.value) * (400 + 32 - 4),
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '07:20 am',
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      ),
    );
  }
}

class DistanceLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        double opacity = math.max(0, 4 * notifier.page - 3);
        return Positioned(
          top: 126.0 + 400 + 32 + 24 + 16 + 40,
          width: (MediaQuery.of(context).size.width),
          //right: opacity * 24.0,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Center(
        child: Text(
          '72 km',
          style: TextStyle(
              fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      bottom: 8,
      child: Consumer<PageOffsetNotifier>(
        builder: (context, notifier, child) {
          double opacity = math.max(0, 4 * notifier.page - 3);
          return Opacity(
            opacity: opacity,
            child: child,
          );},
            child: FlatButton(
              onPressed: () {
                Provider.of<AnimationController>(context).forward();
              },
              child: Text('ON MAP'),
            ),
          ),
    );
  }
}

class VultureCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double multiplier;
        if(animation.value == 0)
          multiplier = math.max(0, 4 * notifier.page - 3);
        else
          multiplier = math.max(0, 1 - 6 * animation.value);
        double size = MediaQuery.of(context).size.width * 0.5 * multiplier;
        return Container(
          margin: EdgeInsets.only(bottom: 250),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        height: size,
        width: size,
      );
      },
    );
  }
}

class VerticalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child){
        if(animation.value < 1/6)
          return Container();
        double startTop = 128.0 + 400 + 32 + 24 + 16 + 6 + 6;
        double bottom = MediaQuery.of(context).size.height - startTop - 25;
        double endTop = 128.0 +32 + 16 + 8;
        double top = endTop + (1 - (1.2 * (animation.value - 1/6))) * (400 + 32 - 4);
        double oneThird = (startTop - endTop) / 3;

        return Positioned(
          top: top,
          bottom: bottom,
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 2,
                  height: double.infinity,
                  color: Colors.white,
                ),

                Positioned(
                  top: top > oneThird + endTop? 0 : oneThird + endTop - top,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainBlack,
                      border: Border.all(color: white, width: 2.5)
                    ),
                    height: 8,
                    width: 8,
                  ),
                ),
                Positioned(
                  top: top > 2 * oneThird + endTop? 0 : 2 * oneThird + endTop - top,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainBlack,
                        border: Border.all(color: white, width: 2.5)
                    ),
                    height: 8,
                    width: 8,
                  ),
                ),
                // Align(
                //   alignment: Alignment(0, 0.33),
                //   child: Container(
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: mainBlack,
                //         border: Border.all(color: white, width: 2.5)
                //     ),
                //     height: 8,
                //     width: 8,
                //   ),
                // ),
                Align(
                  alignment: Alignment(0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainBlack,
                        border: Border.all(color: white, width: 1)
                    ),
                    height: 8,
                    width: 8,
                  ),
                ),
                Align(
                  alignment: Alignment(0, -1),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    height: 8,
                    width: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class HorizontalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double spacingFactor;
        double opacity;
        if(animation.value == 0){
          spacingFactor = math.max(0, 4 * notifier.page - 3);
          opacity = spacingFactor;
        }else{
          spacingFactor = math.max(0, 1 - 6 * animation.value);
          opacity = 1;
        }
        return Positioned(
          top: 128.0 + 400 + 32 + 24 + 16 + 6,
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: spacingFactor * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    height: 4,
                    width: 4,
                  ),
                  //SizedBox(width: 4),
                  Container(
                    margin: EdgeInsets.only(right: spacingFactor * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    height: 4,
                    width: 4,
                  ),
                  //SizedBox(width: 4,),
                  Container(
                    margin: EdgeInsets.only(right: spacingFactor * 40),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white)),
                    height: 8,
                    width: 8,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: spacingFactor * 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    height: 8,
                    width: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class VultureIconLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child){
        double startTop = 128.0 + 400 + 32 + 24 + 16 + 6 + 6;
        double bottom = MediaQuery.of(context).size.height - startTop - 25;
        double endTop = 128.0 +32 + 16 + 8;
        double top = endTop + (1 - (1.2 * (animation.value - 1/6))) * (400 + 32 - 4);
        double oneThird = (startTop - endTop) / 3;
        double opacity;
        if(animation.value < 2/3)
          opacity = 0;
        else
          opacity = 3 * (animation.value - 2/3);

        return Positioned(
          top: endTop + 2 * oneThird - 28 - 16 - 7,
          right: 10 + opacity * 16,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: SmallAnimalIconLabel(isVulture: true, showLine: true,),
    );
  }
}

class LeopardIconLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child){
        double startTop = 128.0 + 400 + 32 + 24 + 16 + 6 + 6;
        double bottom = MediaQuery.of(context).size.height - startTop - 25;
        double endTop = 128.0 +32 + 16 + 8;
        double top = endTop + (1 - (1.2 * (animation.value - 1/6))) * (400 + 32 - 4);
        double oneThird = (startTop - endTop) / 3;
        double opacity;
        if(animation.value < 3/4)
          opacity = 0;
        else
          opacity = 4 * (animation.value - 3/4);

        return Positioned(
          top: endTop + oneThird - 28 - 16 - 7,
          left: 10 + opacity * 16,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: SmallAnimalIconLabel(isVulture: false, showLine: true,),
    );
  }
}

class SmallAnimalIconLabel extends StatelessWidget {
  final bool isVulture;
  final bool showLine;

  const SmallAnimalIconLabel({Key key, this.isVulture, this.showLine}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(showLine && isVulture)
          Container(
            margin: EdgeInsets.only(bottom: 8),
            width: 16,
            height: 1,
            color: white,
          ),
        SizedBox(width: 24,),
        Column(
          children: [
            Image.asset(isVulture ? 'assets/vultures.png' : 'assets/leopards.png', width: 28, height: 28,),
            SizedBox(height: 24),
            Text(isVulture ? 'Vultures' : 'Leopards', style: TextStyle(fontSize: 14),)
          ],
        ),
        SizedBox(width: 24,),
        if(showLine && !isVulture)
          Container(
            margin: EdgeInsets.only(bottom: 8),
            width: 16,
            height: 1,
            color: white,
          ),
      ],
    );
  }
}