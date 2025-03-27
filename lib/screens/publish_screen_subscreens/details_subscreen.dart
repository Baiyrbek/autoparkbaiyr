import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/lang_strings.dart';
import '../../block/publish_screen/publish_bloc.dart';
import '../../block/publish_screen/publish_event.dart';
import '../../block/publish_screen/publish_state.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    context.read<PublishBloc>().add(GetAllModelsEvent());
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<PublishBloc>().state;
    if (_priceController.text != state.price) {
      _priceController.text = state.price ?? '';
    }
    if (_descriptionController.text != state.description) {
      _descriptionController.text = state.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                STRINGS[LANG]?['details'] ?? 'Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                STRINGS[LANG]?['fill_details'] ?? 'Fill in the details of your car',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              if (state.error != null && state.currentPage == 1)
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
              _buildTextField(
                label: STRINGS[LANG]?['brand'] ?? 'Brand',
                value: state.selectedBrand,
                onChanged: (value) {
                  context.read<PublishBloc>().add(UpdateBrandEvent(value));
                },
                items: state.brands.map((brand) => brand['name'] as String).toList(),
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: STRINGS[LANG]?['model'] ?? 'Model',
                value: state.selectedModel,
                onChanged: (value) {
                  context.read<PublishBloc>().add(UpdateModelEvent(value));
                },
                items: state.models,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: STRINGS[LANG]?['year'] ?? 'Year',
                value: state.selectedYear,
                onChanged: (value) {
                  context.read<PublishBloc>().add(UpdateYearEvent(value));
                },
                items: state.years,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: STRINGS[LANG]?['price_in_dollars'] ?? 'Price',
                value: state.price,
                onChanged: (value) {
                  context.read<PublishBloc>().add(UpdatePriceEvent(value));
                },
                items: null,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: STRINGS[LANG]?['description'] ?? 'Description',
                value: state.description,
                onChanged: (value) {
                  context.read<PublishBloc>().add(UpdateDescriptionEvent(value));
                },
                items: null,
                maxLines: 3,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String? value,
    required List<String>? items,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: items != null
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      dropdownColor: Colors.black,
                      hint: Text(
                        value ?? 'Select',
                        style: const TextStyle(color: Colors.white54),
                      ),
                      items: items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          onChanged(newValue);
                        }
                      },
                    ),
                  )
                : TextField(
                    onChanged: onChanged,
                    keyboardType: keyboardType,
                    maxLines: maxLines ?? 1,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      border: InputBorder.none,
                      hintText: value ?? (STRINGS[LANG]?['enter'] ?? 'Enter'),
                      hintStyle: const TextStyle(color: Colors.white54),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}