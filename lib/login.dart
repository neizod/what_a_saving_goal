// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  var _profiles = ['A', 'B', 'C', 'D'];   // XXX dummy data within code

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      setState(() {
        // Redraw so that the username label reflects the focus state
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        // Redraw so that the password label reflects the focus state
      });
    });

    getProfiles().whenComplete(() => setState((){}));
  }

  Future<void> getProfiles() async {
    var box = await Hive.openBox('data');
    _profiles = box.get('profiles');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _buildGridCards(4, context),
        ),
      ),
    );
  }

  List<Card> _buildGridCards(int count, BuildContext context) {
    List<Card> cards = List.generate(
      count,
      (int index) => Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pop(context);
          },
          child: Column(
            children: <Widget>[
              AspectRatio(aspectRatio: 18.0/11.0,
              child: Image.asset('assets/dummy-profile.png'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Text('${_profiles[index]}'),
              ),
            ],
          ),
        ),
      ),
    );
    return cards;
  }
}
