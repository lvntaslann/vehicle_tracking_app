import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:vehicle_tracking_app/pages/homepage.dart';
import 'package:vehicle_tracking_app/pages/profile.dart';
import 'package:vehicle_tracking_app/pages/settings.dart';


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller = PersistentTabController(initialIndex: 1);

    List<Widget> pages = [
    
      const Profile(),
      const Homepage(),
      const Settings(),
    ];

    List<PersistentBottomNavBarItem> navBarItems = [
      
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person,color: Colors.white,),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey[500],
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home,color: Colors.white,),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary:  Colors.grey[500],
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings,color: Colors.white,),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey[700],
      ),
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: pages,
        items: navBarItems,
        backgroundColor: Color(0xFF4B69FF),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: 65,
        navBarStyle: NavBarStyle.style3,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
          colorBehindNavBar: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, -3),
            ),
          ],
        ),
      ),
    );
  }
}