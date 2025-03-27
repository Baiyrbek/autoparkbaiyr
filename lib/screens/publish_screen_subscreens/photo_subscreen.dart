import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/lang_strings.dart';
import '../../block/publish_screen/publish_bloc.dart';
import '../../block/publish_screen/publish_event.dart';
import '../../block/publish_screen/publish_state.dart';
import 'dart:io';

class PhotoScreen extends StatefulWidget {
  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PublishBloc>().add(GetBrandsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              STRINGS[LANG]?['add_photos'] ?? 'Add Photos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${state.selectedImages.length}/8 ${STRINGS[LANG]?['photos_selected'] ?? 'photos selected'}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            if (state.error != null && state.currentPage == 0)
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
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildAddPhotoButton(context);
                  }
                  return _buildPhotoItem(state.selectedImages[index - 1]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddPhotoButton(BuildContext context) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        final bool canAddMore = state.selectedImages.length < 8;
        
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => _pickImages(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  canAddMore ? Icons.add_photo_alternate_outlined : Icons.refresh,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  canAddMore 
                    ? (STRINGS[LANG]?['add_photos_button'] ?? 'Add Photo')
                    : (STRINGS[LANG]?['choose_again'] ?? 'Choose Again'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImages(BuildContext context) async {
    final bloc = context.read<PublishBloc>();
    final newImages = await bloc.pickImages();
    
    if (newImages.isNotEmpty) {
      final state = bloc.state;
      final updatedImages = state.selectedImages.isEmpty 
          ? newImages.map((path) => File(path)).toList()
          : [...state.selectedImages, ...newImages.map((path) => File(path))];
      
      bloc.add(UpdateImagesEvent(updatedImages.map((file) => file.path).toList()));
    }
  }

  Widget _buildPhotoItem(File imageFile) {
    return BlocBuilder<PublishBloc, PublishState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: () {
                  final newImages = List<File>.from(state.selectedImages)
                    ..remove(imageFile);
                  context.read<PublishBloc>().add(UpdateImagesEvent(newImages.map((file) => file.path).toList()));
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 