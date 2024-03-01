import 'dart:async';

import 'package:flutter/material.dart';

typedef OnChange = void Function(int i);

class Swiper extends StatefulWidget {
  late final List<Widget> children;
  final OnChange? onChange;
  final int duration;
  final double height;
  final bool show;
  final bool auto;

  Swiper(
      {Key? key,
      required this.children,
      this.onChange,
      this.duration = 3000,
      this.height = 200,
      this.auto = true,
      this.show = true})
      : super(key: key);

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  late PageController _pageController;
  late Timer _timer;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(
      keepPage: true,
    );
    if (widget.auto) {
      _timer = Timer(Duration(milliseconds: widget.duration), () {
        currentIndex == widget.children.length - 1
            ? currentIndex = 0
            : currentIndex++;
        setState(() {});
        print("c:$currentIndex");
        _pageController.jumpToPage(currentIndex);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (o) {
              widget.onChange!(o);
              if (widget.auto) {
                _timer.cancel();
                currentIndex = o;
                _timer = Timer(Duration(milliseconds: widget.duration), () {
                  currentIndex == widget.children.length - 1
                      ? currentIndex = 0
                      : currentIndex++;
                  setState(() {});
                  _pageController.jumpToPage(currentIndex);
                });
                setState(() {});
              } else {
                currentIndex = o;
              }
            },
            children: widget.children,
          ),
          Positioned(
              bottom: 10,
              child: Offstage(
                offstage: widget.show ? false : true,
                child: Row(
                  children: List.generate(
                      widget.children.length,
                      (index) => Container(
                            height: 10,
                            width: 10,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(360)),
                                color: currentIndex == index
                                    ? Colors.blue
                                    : Colors.grey),
                          )),
                ),
              ))
        ],
      ),
    );
  }
}
