import 'package:dodoshautopark/screens/main_screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../block/counter/counter_block.dart';
import '../block/counter/counter_event.dart';
import '../block/counter/counter_state.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      body: HomePage()
    );
  }
}




class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              BlocBuilder<CounterBloc, CounterState>(
                builder: (context, state) {
                  return Text(
                    'Counter: ${state.value}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () =>
                        context.read<CounterBloc>().add(IncrementCounter()),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () =>
                        context.read<CounterBloc>().add(DecrementCounter()),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
  }
}