import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/header.dart';
import '../components/footer.dart';

final supabase = Supabase.instance.client;

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLoading = true;
  String title = '';
  String imageUrl = '';
  String description = '';
  String category = '';

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  Future<void> _fetchDetailData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await supabase
          .from('menu_items')
          .select()
          .eq('id', widget.id)
          .single();

      if (kDebugMode) {
        print('Detail response: $response');
      }

      if (response != null) {
        final String imagePath = response['image_url'] as String;
        final publicUrl = supabase
            .storage
            .from('menu-images')
            .getPublicUrl(imagePath.split('/').last);

        setState(() {
          title = response['name'] as String;
          imageUrl = publicUrl;
          category = response['category'] as String;
          description = response['description']
              .toString()
              .replaceAll(r'\n\n', '\n\n    ')  // Add space after line break
              .replaceAll(r'\n', ' ')            // Replace single \n with space
              .replaceAll(r'  ', ' ');           // Normalize spaces
          isLoading = false;
        });
      }

    } catch (error) {
      if (kDebugMode) {
        print('Error fetching detail: $error');
      }
      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load detail: ${error.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildShimmerLoading() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: category == 'Drinks' ? 200 : 282,
            height: category == 'Drinks' ? 300 : 230,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                4,
                    (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: RefreshIndicator(
        onRefresh: _fetchDetailData,
        color: Colors.red,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: kToolbarHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  _buildShimmerLoading()
                else
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: category == 'Drinks' ? 200 : 282,
                          height: category == 'Drinks' ? 300 : 230,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: category == 'Drinks' ? 200 : 282,
                                height: category == 'Drinks' ? 300 : 230,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: category == 'Drinks' ? 200 : 282,
                                height: category == 'Drinks' ? 300 : 230,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                CustomBottomNavigation(
                  selectedIndex: 0,
                  onItemTapped: (index) {
                    // Handle item tap logic if needed
                  },
                  isBackgroundVisible: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}