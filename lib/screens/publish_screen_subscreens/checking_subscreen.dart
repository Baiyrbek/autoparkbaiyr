import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/lang_strings.dart';
import '../../block/publish_screen/publish_bloc.dart';
import '../../block/publish_screen/publish_state.dart';

class CheckingSubscreen extends StatelessWidget {
  const CheckingSubscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(STRINGS[LANG]?['brand'] ?? 'Brand'),
                _buildInfoBox(state.selectedBrand),
                const SizedBox(height: 24),
                _buildSectionTitle(STRINGS[LANG]?['model'] ?? 'Model'),
                _buildInfoBox(state.selectedModel),
                const SizedBox(height: 24),
                _buildSectionTitle(STRINGS[LANG]?['year'] ?? 'Year'),
                _buildInfoBox(state.selectedYear),
                const SizedBox(height: 24),
                _buildSectionTitle(STRINGS[LANG]?['price'] ?? 'Price'),
                _buildInfoBox(state.price),
                const SizedBox(height: 24),
                _buildSectionTitle(STRINGS[LANG]?['description'] ?? 'Description'),
                _buildInfoBox(state.description),
                const SizedBox(height: 24),
                _buildSectionTitle(STRINGS[LANG]?['region'] ?? 'Region'),
                _buildInfoBox(state.selectedRegion),
                const SizedBox(height: 24),
                if (state.selectedImages.isNotEmpty) ...[
                  _buildSectionTitle(STRINGS[LANG]?['images'] ?? 'Images'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              state.selectedImages[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoBox(String? value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        value ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
} 