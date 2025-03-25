import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/lang_strings.dart';
import '../block/publish_screen/publish_bloc.dart';
import '../block/publish_screen/publish_event.dart';
import '../block/publish_screen/publish_state.dart';
import 'publish_screen_subscreens/photo_subscreen.dart';
import 'publish_screen_subscreens/details_subscreen.dart';
import 'publish_screen_subscreens/region_subscreen.dart';
import 'publish_screen_subscreens/checking_subscreen.dart';

class PublishScreen extends StatelessWidget {
  final String type;

  const PublishScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          STRINGS[LANG]?['publish'] ?? 'Publish',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<PublishBloc, PublishState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildProgressIndicator(state.currentPage),
              Expanded(
                child: _buildCurrentPage(context, state.currentPage),
              ),
              _buildNavigationButtons(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator(int currentPage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentPage ? Colors.white : Colors.white24,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentPage(BuildContext context, int currentPage) {
    switch (currentPage) {
      case 0:
        return PhotoScreen();
      case 1:
        return DetailsScreen();
      case 2:
        return RegionScreen();
      case 3:
        return CheckingSubscreen();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons(BuildContext context, PublishState state) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.currentPage > 0)
            ElevatedButton.icon(
              onPressed: () {
                context.read<PublishBloc>().add(PreviousPageEvent());
              },
              icon: Icon(Icons.arrow_back, color: Colors.black),
              label: Text(
                STRINGS[LANG]?['back'] ?? 'Back',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            SizedBox.shrink(),
          if (state.currentPage < 3)
            ElevatedButton.icon(
              onPressed: () {
                context.read<PublishBloc>().add(NextPageEvent());
              },
              icon: Icon(Icons.arrow_forward, color: Colors.black),
              label: Text(
                STRINGS[LANG]?['next'] ?? 'Next',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            ElevatedButton(
              onPressed: () {
                context.read<PublishBloc>().add(SubmitPublishEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    STRINGS[LANG]?['publish'] ?? 'Publish',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
