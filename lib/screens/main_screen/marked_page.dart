import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dodoshautopark/block/main_screen/home_page/random_ads_bottom_sheet/random_ads_block.dart';
import 'package:dodoshautopark/block/main_screen/home_page/random_ads_bottom_sheet/random_ads_state.dart';
import 'package:dodoshautopark/block/main_screen/home_page/random_ads_bottom_sheet/random_ads_event.dart';
import 'package:dodoshautopark/constants/lang_strings.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../utils/ads_item_card.dart';

class MarkedPage extends StatelessWidget {
  const MarkedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RandomAdsBloc()..add(FetchRandomAds()),
      child: BlocBuilder<RandomAdsBloc, RandomAdsState>(
        builder: (context, state) {
          if (state is RandomAdsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RandomAdsError) {
            return Center(child: Text(state.message));
          }

          if (state is RandomAdsLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: STRINGS[LANG]?['marked_ads'] ?? 'Marked Ads',
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: state.ads.take(2).map((ad) {
                        final List<String> images =
                            (jsonDecode(ad['img']) as List)
                                .where((element) =>
                                    element != null &&
                                    element.toString().isNotEmpty)
                                .map((e) => e.toString())
                                .toList();
                        final img = (ad['img'] != null && ad['img'].isNotEmpty)
                            ? images[0]
                            : null;
                        return AdsItemCard(ad, img, images);
                      }).toList(),
                    ),
                  ),
                  _buildSection(
                    title:
                        STRINGS[LANG]?['recently_viewed'] ?? 'Recently Viewed',
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: state.ads.sublist(3, 7).map((ad) {
                        final List<String> images =
                            (jsonDecode(ad['img']) as List)
                                .where((element) =>
                                    element != null &&
                                    element.toString().isNotEmpty)
                                .map((e) => e.toString())
                                .toList();
                        final img = (ad['img'] != null && ad['img'].isNotEmpty)
                            ? images[0]
                            : null;
                        return AdsItemCard(ad, img, images);
                      }).toList(),
                    ),
                  ),
                  _buildSection(
                    title: STRINGS[LANG]?['my_favorites'] ?? 'My Favorites',
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        dynamic ad = state.ads[index + 6];
                        final List<String> images =
                            (jsonDecode(ad['img']) as List)
                                .where((element) =>
                                    element != null &&
                                    element.toString().isNotEmpty)
                                .map((e) => e.toString())
                                .toList();
                        final img = (ad['img'] != null && ad['img'].isNotEmpty)
                            ? images[0]
                            : null;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: AdsItemCard(ad, img, images),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // Widget _buildAdCard(Map<String, dynamic> ad) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ClipRRect(
  //           borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
  //           child: Image.network(
  //             ad['image_url'] ?? '',
  //             height: 120,
  //             width: double.infinity,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 ad['title'] ?? '',
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 '${ad['price']}',
  //                 style: const TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.green,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
