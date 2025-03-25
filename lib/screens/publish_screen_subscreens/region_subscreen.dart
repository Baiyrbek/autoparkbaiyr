import 'package:flutter/material.dart';
import '../../constants/lang_strings.dart';
import '../../constants/constaint_def.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../block/publish_screen/publish_bloc.dart';
import '../../block/publish_screen/publish_event.dart';
import '../../block/publish_screen/publish_state.dart';

class RegionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              STRINGS[LANG]?['region'] ?? 'Region',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              STRINGS[LANG]?['select_region'] ?? 'Select the region where your car is located',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            if (state.error != null && state.currentPage == 2)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.error!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var region in GlobalVars.region) ...[
                      GestureDetector(
                        onTap: () {
                          context.read<PublishBloc>().add(UpdateRegionEvent(region));
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: state.selectedRegion == region ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: state.selectedRegion == region ? Colors.white : Colors.white24,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              region,
                              style: TextStyle(
                                color: state.selectedRegion == region ? Colors.black : Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 