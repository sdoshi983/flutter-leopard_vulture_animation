import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'main_page.dart';

class LeopardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('leopard page');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 110.0,
        ),
        The72Text(),
        SizedBox(
          height: 32.0,
        ),
        TravelDescriptionLabel(),
        SizedBox(
          height: 18.0,
        ),
        LeopardDescription()
      ],
    );
  }
}

class LeopardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        print(notifier.offset);
        return Positioned(
          left: -0.88 * notifier.offset,
          width: MediaQuery.of(context).size.width * 1.65,
          child: Transform.scale(
            alignment: Alignment(0.4, 0),
            scale: 1 - 0.1 * animation.value,
            child: Opacity(
              opacity: 1 - 0.6 * animation.value,
              child: child,
            ),
          ),
        );
      },
      child: IgnorePointer(
        child: Image(
          image: AssetImage('assets/leopard.png'),
        ),
      ),
    );
  }
}

class TravelDescriptionLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
            opacity: math.max(0, 1 - 4 * notifier.page), child: child);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 50.0),
        child: Text(
          'Travel Description',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class LeopardDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
            opacity: math.max(0, 1 - 4 * notifier.page), child: child);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 50.0),
        child: Text(
          'The leopard is indistinguishable by well camouflaged fur, opportunistic hunting behaviour broad diet and strength',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class The72Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('the 72 text');
    //return Container();
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        print(notifier.offset);
        //return Container();
        return Transform.translate(
          offset: Offset(-40.0 - 0.5 * notifier.offset, 0),
          child: child,
        );
      },
      child: Container(
        alignment: Alignment.topLeft,
        child: RotatedBox(
          quarterTurns: 1,
          child: SizedBox(
            // height: 200,
            width: 450.0,
            child: FittedBox(
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              child: Text(
                '72',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //fontSize: 350
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return Image(
      image: AssetImage('assets/leopard.png'),
    );
  }
}
