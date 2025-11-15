import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'package:mobile/utils/constants/app_colors.dart';
import 'package:mobile/features/cart/viewmodels/cart_provider.dart';
import 'package:mobile/features/product/models/product_details_model.dart';
import 'package:mobile/features/product/repository/product_repository.dart';
import 'package:mobile/features/cart/views/cart_page.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  int _selectedQuantity = 1;

  ProductDetailsModel? _details;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ProductRepository();
      final details = await repo.fetchProductDetails(widget.product.id);
      setState(() {
        _details = details;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<bool> _ensureLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      final goToLogin = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login required'),
          content: const Text('Please login to add items to your cart.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Login'),
            ),
          ],
        ),
      );
      if (goToLogin == true) {
        Navigator.pushNamed(context, '/login');
      }
      return false;
    }
    return true;
  }

  Future<void> _addToCart() async {
    final ok = await _ensureLoggedIn();
    if (!ok) return;
    try {
      await ref
          .read(cartProvider.notifier)
          .addToCart(
            menuItemId: widget.product.id,
            quantity: _selectedQuantity,
          );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to cart')));
      // Optional: open cart
      // Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add to cart: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: BackButton(color: Colors.black),
        ),
        body: Center(child: Text('Error: $_error')),
      );
    }

    final product =
        _details ??
        ProductDetailsModel.fromJson({
          'id': widget.product.id,
          'category_id': widget.product.categoryId,
          'category_name': widget.product.categoryName ?? 'Uncategorized',
          'name': widget.product.name,
          'description': widget.product.description,
          'base_price': widget.product.basePrice,
          'images': widget.product.images,
          'is_available': widget.product.isAvailable,
        });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildImageGalleryWithDetails(product)),
              SliverToBoxAdapter(child: _buildDetailsSection(product)),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: _buildIconButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: _buildIconButton(
              icon: Icons.favorite_border,
              onPressed: () {},
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(product),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProductDetailsModel product) {
    final price = double.tryParse(product.basePrice) ?? 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quantity selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _selectedQuantity > 1
                        ? () => setState(() => _selectedQuantity--)
                        : null,
                    splashRadius: 20,
                  ),
                  Text(
                    '$_selectedQuantity',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _selectedQuantity++),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _addToCart,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_shopping_cart_outlined),
                    const SizedBox(width: 8),
                    Text(
                      'Add (${_selectedQuantity}) • \$${(price * _selectedQuantity).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGalleryWithDetails(ProductDetailsModel product) {
    final hasMultipleImages = product.images.length > 1;

    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: product.images.length,
            itemBuilder: (context, index) {
              final imageUrl =
                  'http://backend.test/storage/${product.images[index]}';
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Image not available',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Image Indicators (Dots)
          if (hasMultipleImages)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  product.images.length,
                  (index) => _buildImageIndicator(index),
                ),
              ),
            ),

          // Thumbnail Navigation (if multiple images)
          if (hasMultipleImages)
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: _buildThumbnailStrip(),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnailStrip() {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.images.length,
        itemBuilder: (context, index) {
          final imageUrl =
              'http://backend.test/storage/${widget.product.images[index]}';
          final isSelected = index == _currentImageIndex;

          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, size: 30),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageIndicator(int index) {
    final isActive = index == _currentImageIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(90),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(70), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.restaurant, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            widget.product.categoryName ?? 'Uncategorized',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.product.isAvailable
            ? Colors.green.shade50
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.product.isAvailable ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            widget.product.isAvailable ? 'Available' : 'Out of Stock',
            style: TextStyle(
              color: widget.product.isAvailable
                  ? Colors.green.shade700
                  : Colors.red.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF2D3142)),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDetailsSection(ProductDetailsModel product) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Badge
            _buildCategoryBadge(),
            const SizedBox(height: 16),

            // Product Name
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Price and Availability Row
            Row(
              children: [
                Text(
                  '\$${widget.product.basePrice}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                _buildAvailabilityChip(),
              ],
            ),
            const SizedBox(height: 24),

            // Divider
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: 24),

            // Description Header
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 12),

            // Description Text
            Text(
              widget.product.description,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            // Divider
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: 24),

            // Review Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3142),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.pushNamed(
                      'reviews',
                      pathParameters: {
                        'menuItemId': widget.product.id.toString(),
                      },
                    );
                  },
                  icon: Icon(Icons.arrow_forward, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
