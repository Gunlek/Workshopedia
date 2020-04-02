import 'package:flexshop/ui/workshop_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void initState(){
    this.controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    this.animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);

    Future.delayed(Duration(milliseconds: 100)).then((value) => this.controller.forward());

    super.initState();
  }

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: FadeTransition(
        opacity: this.animation,
        child: BottomAppBar(
          color: Color.fromRGBO(33, 33, 33, 1.0),
          shape: CircularNotchedRectangle(),
          notchMargin: 7.0,
          child: SizedBox(
            height: 45,
          )
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FadeTransition(
        opacity: this.animation,
        child: FloatingActionButton(
          onPressed: () => {},      // TODO: Add QR code scan
          child: FaIcon(FontAwesomeIcons.qrcode),
        ),
      ),
      body: FadeTransition(
        opacity: this.animation,
        child: WorkshopList()
      ),
    );
  }
}