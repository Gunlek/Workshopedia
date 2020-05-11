import 'dart:ui';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flexshop/model/workshop.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flexshop/model/category.dart';
import 'package:flexshop/model/machine.dart';
import 'package:flexshop/ui/machine_view.dart';
import 'package:flexshop/api/category_api.dart';
import 'package:flexshop/api/machine_api.dart';

class WorkshopView extends StatelessWidget {
  final Workshop workshop;

  WorkshopView({Key key, @required this.workshop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return buquageListPageStateful(title: this.title, eventid: this.eventid,);
    return WorkshopViewStateful(workshop: this.workshop);
  }
}

class WorkshopViewStateful extends StatefulWidget {
  final Workshop workshop;

  WorkshopViewStateful({Key key, @required this.workshop}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WorkshopViewState();
  }
}

class WorkshopViewState extends State<WorkshopViewStateful> with SingleTickerProviderStateMixin {
//class WorkshopView extends StatelessWidget {

  final double _spaceBetweenTwoCategory = 40;

  Workshop workshop;
  List<Category> _categories;
  List<Machine> machines;

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  //WorkshopView({this.workshop});

  @override
  void initState() {
    super.initState();

    MachineAPI.getAllMachines(
      onDone: (int status, dynamic data){
        List<Machine> macList = List<Machine>();
        for (final elem in data){macList.add(Machine.fromMapObject(elem));}
        setState(() {
          this.machines = macList;
        });
      }
    );

    CategoryAPI.getCategoriesFromWorkshopId(
      id: widget.workshop.id,
      onDone: (int status, dynamic data){
        List<Category> catList = List<Category>();
        for (final elem in data){catList.add(Category.fromMapObject(elem));}
        setState(() {
          this._categories = catList;
        });
      }
    );
    this.workshop = widget.workshop;

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_categories = categories.where((cat) => cat.workshop == workshop.id).toList();
    
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 33, 33, 1.0),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
          color: Color.fromRGBO(33, 33, 33, 1.0),
          shape: CircularNotchedRectangle(),
          notchMargin: 7.0,
          child: SizedBox(
            height: 45,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {}, // TODO: Add QR code scan
        child: FaIcon(FontAwesomeIcons.qrcode),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: Hero(
              tag: workshop.id.toString(),
              child: Image.network(
                  workshop.image=="none"? "assets/images/default/default_ateliers.jpg" : workshop.image,
                  fit: BoxFit.cover, color: Color.fromRGBO(0, 0, 0, 0.5), colorBlendMode: BlendMode.darken)
            ),
          ),
          
          Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 3),
              Container(
                  height: 2 * MediaQuery.of(context).size.height / 3,
                  child: FlareActor(
                  "assets/animations/loading.flr",
                  animation: "Loop",
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                )
              ),
            ],
          ),

          SlideTransition(
            position: _offsetAnimation,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          workshop.title.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height / 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 1.0),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(MediaQuery.of(context).size.width / 6)
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 3 / 4+25,
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(MediaQuery.of(context).size.width / 6)),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 30,),
                                  _waitToBuildCategory(context),
                                  SizedBox(height: 80),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ],
            )
          ),
        ],
      )
    );
  }

  Widget _waitToBuildCategory(BuildContext context){
    if (this._categories==null) {return CircularProgressIndicator();}
    else{return Column(children: <Widget>[
      for(Category category in _categories)
        _buildCategory(context, category)
    ],);}
  }

  Widget _buildCategory(BuildContext context, Category category) {
    List<Machine> categoryMachines = machines.where((mach) => mach.category == category.id).toList();

    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                  color: Color.fromRGBO(112, 112, 112, 1.0),
                  width: 2.0,
                ))
              ),
              child: Text(
                category.title,
                style: TextStyle(fontSize: 30),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryMachines.length,
            itemBuilder: (BuildContext context, int i) {
              return GestureDetector(
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MachineView(machine: categoryMachines[i])))},     // TODO: Open machine detail
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            categoryMachines[i].image=="none" ? "assets/images/default/default_machine.jpg" : categoryMachines[i].image,
                            fit: BoxFit.cover, color: Color.fromRGBO(0, 0, 0, 0.5), colorBlendMode: BlendMode.darken,),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(categoryMachines[i].title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).textScaleFactor * 20)),
                            Text(categoryMachines[i].brand, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).textScaleFactor * 20)),
                            Text(categoryMachines[i].reference, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).textScaleFactor * 20)),
                          ],
                        )
                      ],
                    )
                  ),
                )
              );
            }
          ),
        ),
        SizedBox(height: _spaceBetweenTwoCategory),
      ],
    );
  }
}
