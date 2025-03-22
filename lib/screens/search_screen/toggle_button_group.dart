import 'package:dodoshautopark/constants/lang_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../block/search_screen/search_screen_block.dart';
import '../../block/search_screen/search_screen_event.dart';

class ToggleButtonGroup extends StatelessWidget {
  final int selectedIndex;

  const ToggleButtonGroup({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Color(0x339D9D9D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: List.generate(3, (index) {
          final bool isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<SearchBloc>().add(SelectButton(index)),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Color(0x78FDFDFD) : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    STRINGS[LANG]!["toggle_button"][index]!,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          );
        }).insertDividers(selectedIndex),
      ),
    );
  }
}

extension DividerLogic on List<Widget> {
  List<Widget> insertDividers(int selectedIndex) {
    if (selectedIndex == 1) return this; // No dividers for center selection

    return [
      this[0],
      if (selectedIndex != 0)
        VerticalDivider(
          color: Colors.white,
          width: 2,
          indent: 8,
          endIndent: 8,
        ),
      this[1],
      if (selectedIndex != 2)
        VerticalDivider(
          color: Colors.white,
          width: 2,
          indent: 8,
          endIndent: 8,
        ),
      this[2],
    ];
  }
}
