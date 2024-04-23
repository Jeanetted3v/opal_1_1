import 'package:flutter/material.dart';
import 'package:opal_1_1/Models/opal_model.dart';

import '../../Models/user_model.dart';
import 'card_widget.dart';


class CardScreen extends StatefulWidget {
  // final user = UserModel(
  //   userName: 'Jeanette',
  //   aboutMe: '',
  //   isOnline: true,
    
  //   profilePic: '',
  //   company: '',
  //   skills: [],
  //   uid: '',
  // );
  CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: CardWidget(opals: opalList),
          ),
        ),
      );
}