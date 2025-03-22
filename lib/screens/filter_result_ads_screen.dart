import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../block/main_screen/home_page/random_ads_bottom_sheet/random_ads_block.dart';
import '../block/main_screen/home_page/random_ads_bottom_sheet/random_ads_event.dart';
import '../block/main_screen/home_page/random_ads_bottom_sheet/random_ads_state.dart';
import '../constants/lang_strings.dart';
import '../utils/ads_item_card.dart';
import '../utils/custom_top_bar.dart';

Widget _buildSkeletonCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 152,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Container(
              width: 120,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(height: 2),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Container(
              width: 80,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              width: 60,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class FilterResultAdsScreen extends StatelessWidget {
  final String? title;

  const FilterResultAdsScreen({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomTopBar(
            title: title ?? '${STRINGS[LANG]?["search_results"]}',
          ),
          
          // Content
          Expanded(
            child: BlocBuilder<RandomAdsBloc, RandomAdsState>(
              builder: (context, state) {
                if (state is RandomAdsLoading) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: List.generate(8, (index) => _buildSkeletonCard()),
                    ),
                  );
                } else if (state is RandomAdsLoaded) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: SingleChildScrollView(
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: (List<Map<String, dynamic>>.from(state.ads)..shuffle()).map((ad) {
                          final img = (ad['img'] != null && ad['img'].isNotEmpty)
                              ? jsonDecode(ad['img'])[0]
                              : null;
                          final List<String> images = (jsonDecode(ad['img']) as List)
                              .where((element) => element != null && element.toString().isNotEmpty)
                              .map((e) => e.toString())
                              .toList();
                          return AdsItemCard(ad, img, images);
                        }).toList(),
                      ),
                    ),
                  );
                } else if (state is RandomAdsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No internet connection",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RandomAdsBloc>().add(FetchRandomAds());
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Retry",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Center(child: Text("Some error"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
