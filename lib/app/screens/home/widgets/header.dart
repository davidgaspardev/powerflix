import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _openMenu = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black
      ),

      child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: _openMenu ? 250 : 45,
          child: Align(
            alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _openMenu = !_openMenu;
                  });
                },
                child: Image.asset(
                  "lib/app/assets/image/logo.png",
                  height: 45,
                ),
              ),
          )
      ),
    );
  }
}