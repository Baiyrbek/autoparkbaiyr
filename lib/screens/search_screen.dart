import 'package:dodoshautopark/constants/lang_strings.dart';
import 'package:dodoshautopark/utils/cutom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../block/main_screen/home_page/brands_widget/brands_block.dart';
import '../block/main_screen/home_page/brands_widget/brands_event.dart';
import '../block/main_screen/home_page/brands_widget/brands_state.dart';
import '../block/main_screen/home_page/random_ads_bottom_sheet/random_ads_block.dart';
import '../block/main_screen/home_page/random_ads_bottom_sheet/random_ads_event.dart';
import '../block/search_screen/search_screen_block.dart';
import '../block/search_screen/search_screen_event.dart';
import '../block/search_screen/search_screen_state.dart';
import 'filter_result_ads_screen.dart';
import 'search_screen/custom_text_input.dart';
import 'search_screen/dropdown_button_bubble.dart';
import 'search_screen/search_brands_screen.dart';
import 'search_screen/toggle_button_group.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BrandsBloc>().add(GetLoadedBrands());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.black),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                CustomTopBar(() => Navigator.of(context).pop()),
                SizedBox(height: 24),
                Column(
                  children: [
                    CustomTextInput(
                      _controller,
                      () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    BlocProvider.value(
                              value: context.read<RandomAdsBloc>()
                                ..add(FetchRandomAds()),
                              child: FilterResultAdsScreen(
                                title: _controller.text,
                              ),
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(-1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 300),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ToggleButtonGroup(selectedIndex: searchState.selectedIndex),
                    SizedBox(height: 20),
                    BlocBuilder<BrandsBloc, BrandsState>(
                      builder: (context, brandsState) {
                        String displayText = '${STRINGS[LANG]?["brand"]}';

                        if (searchState.selectedBrandId != "0" &&
                            brandsState is BrandsLoaded) {
                          final selectedBrand = brandsState.brands.firstWhere(
                            (brand) =>
                                brand['id'].toString() ==
                                searchState.selectedBrandId,
                            orElse: () =>
                                {'name': '${STRINGS[LANG]?["brand"]}'},
                          );
                          displayText = selectedBrand['name'];
                        }

                        return DropdownButtonBubble(
                          text: displayText,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        BlocProvider.value(
                                  value: context.read<SearchBloc>(),
                                  child: SearchBrandsScreen(),
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin =
                                      Offset(-1.0, 0.0); // Start from right
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 300),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<SearchBloc>()
                              .add(PerformSearch(_controller.text));
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                String? title;
                                if (searchState.selectedBrandId != "0") {
                                  final brandsState =
                                      context.read<BrandsBloc>().state;
                                  if (brandsState is BrandsLoaded) {
                                    final selectedBrand =
                                        brandsState.brands.firstWhere(
                                      (brand) =>
                                          brand['id'].toString() ==
                                          searchState.selectedBrandId,
                                      orElse: () => {
                                        'name':
                                            '${STRINGS[LANG]?["search_results"]}'
                                      },
                                    );
                                    title = selectedBrand['name'];
                                  }
                                }

                                return BlocProvider.value(
                                  value: context.read<RandomAdsBloc>()
                                    ..add(FetchRandomAds()),
                                  child: FilterResultAdsScreen(
                                    title: title,
                                  ),
                                );
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin =
                                    Offset(-1.0, 0.0); // Start from left
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                        ),
                        child: Text(
                          '${STRINGS[LANG]?["find"]}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
