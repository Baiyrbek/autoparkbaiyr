import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/api_url.dart';
import '../screens/ad_detail_screen.dart';

Widget _buildImageSkeleton() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: double.infinity,
      height: 152,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget AdsItemCard(ad, img, images) {
  return Builder(
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => AdDetailScreen(adId: ad['id']),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: img != null
                      ? '${IMG_URL['ads_img_preview']}$img'
                      : 'https://via.placeholder.com/120',
                  width: double.infinity,
                  height: 152,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildImageSkeleton(),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 152,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                  memCacheWidth: null,
                  memCacheHeight: null,
                  maxWidthDiskCache: null,
                  maxHeightDiskCache: null,
                  fadeInDuration: Duration(milliseconds: 300),
                  fadeOutDuration: Duration(milliseconds: 300),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '${ad['brand'] ?? 'AutoPark'} ${ad['model'] ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 2),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '${ad['about'] ?? 'AutoPark'}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 2),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Text(
                  '${ad['price'] ?? '0'} ${ad['price_cur'] == '0' ? 'сом' : '\$'} ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
