import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.person_2_rounded,
                  size: 50,
                ),
                title: Text(
                  "About me",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {},
              ),
              Divider(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.star_border_purple500_rounded,
                  size: 50,
                ),
                title: Text("Goal", style: TextStyle(fontSize: 20)),
                onTap: () {},
              ),
              Divider(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.link_rounded,
                  size: 50,
                ),
                title: Text("Google Fit", style: TextStyle(fontSize: 20)),
                onTap: () {},
              ),
              Divider(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline_rounded,
                  size: 50,
                ),
                title: Text("About", style: TextStyle(fontSize: 20)),
                onTap: () {},
              )
            ],
          ),
        ));
  }
}
