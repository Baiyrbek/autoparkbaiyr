import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../block/main_screen/home_page/brands_widget/brands_block.dart';
import '../../block/main_screen/home_page/brands_widget/brands_event.dart';
import '../../block/main_screen/home_page/brands_widget/brands_state.dart';
import '../../block/search_screen/search_screen_block.dart';
import '../../block/search_screen/search_screen_event.dart';
import '../../constants/api_url.dart';
import '../../constants/lang_strings.dart';

Widget _buildSkeletonItem() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 16,
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

class SearchBrandsScreen extends StatefulWidget {
  const SearchBrandsScreen({Key? key}) : super(key: key);

  @override
  _SearchBrandsScreenState createState() => _SearchBrandsScreenState();
}

class _SearchBrandsScreenState extends State<SearchBrandsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BrandsBloc>().add(GetLoadedBrands()); // Fetch cached brands
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${STRINGS[LANG]?["autoBrand"]}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<BrandsBloc, BrandsState>(
        builder: (context, state) {
          if (state is BrandsLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 10, // Show 10 skeleton items while loading
              itemBuilder: (context, index) => _buildSkeletonItem(),
            );
          } else if (state is BrandsLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.brands.length,
              itemBuilder: (context, index) {
                final brand = state.brands[index];
                return _buildBrandItem(brand);
              },
            );
          } else if (state is BrandsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return const Center(
              child: Text(
                "No brands available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBrandItem(Map<String, dynamic> brand) {
    return GestureDetector(
      onTap: () {
        final searchBloc = context.read<SearchBloc>();
        searchBloc.add(SetSelectedBrandId(brand['id'].toString()));
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Brand Image
            ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: CachedNetworkImage(
                imageUrl: '$GLOBAL_URL/admin/img/brands/${brand['img']}',
                width: 58,
                height: 58,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 29,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.image, color: Colors.white),
                ),
                memCacheWidth: null,
                memCacheHeight: null,
                maxWidthDiskCache: null,
                maxHeightDiskCache: null,
                fadeInDuration: Duration(milliseconds: 300),
                fadeOutDuration: Duration(milliseconds: 300),
              ),
            ),
            const SizedBox(width: 12),

            // Brand Name
            Expanded(
              child: Text(
                brand['name'],
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
