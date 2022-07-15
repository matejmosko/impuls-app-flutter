import 'package:flutter/material.dart';
import 'package:scenickazatva_app/providers/counter_bloc.dart';
import 'package:scenickazatva_app/widgets/decrement.dart';
import 'package:scenickazatva_app/widgets/increment.dart';
import 'package:provider/provider.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = Provider.of<CounterBloc>(context);

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(counterBloc.counter.toString(),style: TextStyle(fontSize: 62),),
              IncrementButton(),
              DecrementButton(),
            ],
          ),
        ),
      ),
    );
  }
}
