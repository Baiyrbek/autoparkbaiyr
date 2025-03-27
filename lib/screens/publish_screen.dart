import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dodoshautopark/block/publish_screen/publish_bloc.dart';
import 'package:dodoshautopark/block/publish_screen/publish_event.dart';
import 'package:dodoshautopark/block/publish_screen/publish_state.dart';
import 'package:dodoshautopark/screens/publish_screen_subscreens/photo_subscreen.dart';
import 'package:dodoshautopark/screens/publish_screen_subscreens/details_subscreen.dart';
import 'package:dodoshautopark/screens/publish_screen_subscreens/region_subscreen.dart';
import 'package:dodoshautopark/screens/publish_screen_subscreens/checking_subscreen.dart';
import 'package:dodoshautopark/screens/main_screen.dart';
import 'package:dodoshautopark/constants/lang_strings.dart';

class PublishScreen extends StatelessWidget {
  const PublishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PublishBloc(),
      child: BlocBuilder<PublishBloc, PublishState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: state.showSuccessModal || state.showErrorModal
                ? null
                : AppBar(
                    backgroundColor: Colors.black,
                    title: Text(
                      STRINGS[LANG]?['publish'] ?? 'Publish',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            body: Stack(
              children: [
                _buildCurrentPage(),
                if (state.isLoading)
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            STRINGS[LANG]?['uploading'] ?? 'Uploading...',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: state.showSuccessModal || state.showErrorModal
                ? null
                : _buildNavigationButtons(context),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPage() {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        Widget page;
        switch (state.currentPage) {
          case 0:
            page = PhotoScreen();
            break;
          case 1:
            page = DetailsScreen();
            break;
          case 2:
            page = RegionScreen();
            break;
          case 3:
            page = const CheckingSubscreen();
            break;
          default:
            page = PhotoScreen();
        }

        return Container(
          padding: const EdgeInsets.only(
              top: 16.0, bottom: 32.0, left: 16.0, right: 16.0),
          child: Stack(
            children: [
              page,
              if (state.showSuccessModal) _buildSuccessModal(context),
              if (state.showErrorModal)
                _buildErrorModal(context, state.error ?? ''),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuccessModal(BuildContext context) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        return Positioned.fill(
          child: Container(
            color: Colors.black,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      STRINGS[LANG]?['success'] ?? 'Success!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      STRINGS[LANG]?['ad_published'] ??
                          'Your ad has been published successfully.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Clear all routes and navigate to MainScreen
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MainScreen()),
                          (route) => false,
                        );
                      },
                      child: Text(STRINGS[LANG]?['back_to_main'] ??
                          'Back to Main Menu'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorModal(BuildContext context, String error) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    STRINGS[LANG]?['error'] ?? 'Error',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Clear all routes and navigate to MainScreen
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                        STRINGS[LANG]?['back_to_main'] ?? 'Back to Main Menu'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
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
                  iconAlignment: IconAlignment.end,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Colors.black),
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
      },
    );
  }
}
