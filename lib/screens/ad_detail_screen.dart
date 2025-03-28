import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../block/ad_detail_screen/ad_detail_bloc.dart';
import '../block/ad_detail_screen/ad_detail_event.dart';
import '../block/ad_detail_screen/ad_detail_repository.dart';
import '../block/ad_detail_screen/ad_detail_state.dart';
import '../utils/custom_top_bar.dart';
import '../constants/api_key.dart';
import 'ad_detail_screen/full_screen_image_view.dart';

class AdDetailScreen extends StatelessWidget {
  final String adId;

  const AdDetailScreen({
    Key? key,
    required this.adId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdDetailBloc(
        repository: AdDetailRepository(),
        adId: adId,
      )..add(LoadAdDetailEvent(adId)),
      child: _AdDetailView(adId: adId),
    );
  }
}

class _AdDetailView extends StatelessWidget {
  final String adId;

  const _AdDetailView({required this.adId});

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AdDetailBloc, AdDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AdDetailBloc>().add(RetryLoadEvent(adId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.adInfo == null) {
            return const Center(child: Text('No data available'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTopBar(title: 'Auto Park'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    state.adInfo!['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.width * 270) / 300,
                  child: SizedBox.expand(
                    child: FlutterCarousel(
                      items: state.images
                          .map((url) => GestureDetector(
                                onTap: () => _showFullScreenImage(
                                  context,
                                  url,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          (MediaQuery.of(context).size.width *
                                                  270) /
                                              300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        height: (MediaQuery.of(context).size.width * 270) / 300,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          context.read<AdDetailBloc>().add(
                                UpdateImageIndexEvent(index),
                              );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.adInfo!['price']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16),
                                  const SizedBox(width: 4),
                                  Text(state.adInfo!['location']),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 4),
                                  Text(state.adInfo!['date']),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[100],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.bookmark,
                                size: 42,
                              ),
                              color: state.isInFavorite
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              onPressed: () {
                                context.read<AdDetailBloc>().add(
                                      ToggleFavoriteEvent(),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Описание',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(state.adInfo!['description']),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final phoneNumber =
                                state.adInfo!['phone'] ?? '+996550822249';
                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path: phoneNumber,
                            );
                            if (await canLaunchUrl(launchUri)) {
                              await launchUrl(launchUri);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Невозможно позвонить'),
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.phone,
                              size: 24, color: Colors.white),
                          label: const Text(
                            'Позвонить',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
