import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/utils/constants/app_colors.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/review_model.dart';
import '../view_model/review_notifier.dart';

class ReviewView extends ConsumerStatefulWidget {
  final int productId;

  const ReviewView({super.key, required this.productId});

  @override
  ConsumerState<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends ConsumerState<ReviewView> {
  double selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reviewNotifierProvider.notifier).loadReviews(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewsState = ref.watch(reviewNotifierProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Reviews & Ratings',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          leading: const BackButton(color: Colors.black),
        ),

        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.rate_review),
          label: const Text('Add Review'),
          onPressed: () {
            showAddReviewSheet(context);
          },
        ),

        body: reviewsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (err, _) => Center(
            child: Text(
              "Something went wrong $err",
              style: TextStyle(color: Colors.red),
            ),
          ),

          data: (reviews) => buildReviewBody(context, reviews),
        ),
      ),
    );
  }

  Widget buildReviewBody(
    BuildContext context,
    List<ProductReviewModel> reviews,
  ) {
    final avgRating = reviews.isEmpty
        ? 0.0
        : reviews.map((e) => e.rating).reduce((a, b) => a + b) / reviews.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ratings and reviews are verified.',
            style: TextStyle(color: AppColors.textPrimary),
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  children: [
                    ratingRow(5, reviews),
                    ratingRow(4, reviews),
                    ratingRow(3, reviews),
                    ratingRow(2, reviews),
                    ratingRow(1, reviews),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          RatingBarIndicator(
            rating: avgRating,
            itemSize: 22,
            itemBuilder: (_, _) =>
                const Icon(Icons.star, color: AppColors.primary),
          ),

          Text(
            "${reviews.length} reviews",
            style: const TextStyle(color: AppColors.textPrimary),
          ),

          const SizedBox(height: 20),

          ...reviews.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: UserReviewCards(
                userName: e.user.name,
                rating: e.rating.toDouble(),
                reviewDate: e.createdAt,
                reviewText: e.comment,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ratingRow(int star, List<ProductReviewModel> reviews) {
    final total = reviews.length;
    final count = reviews.where((e) => e.rating == star).length;

    final value = total == 0 ? 0.0 : count / total;

    return RatingProgressIndicator(text: star, value: value);
  }

  // --------------------------------------------------------------------------
  // BOTTOM SHEET — Add Review
  // --------------------------------------------------------------------------
  void showAddReviewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rate Your Experience',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                RatingBar(
                  initialRating: 0,
                  minRating: 1,
                  allowHalfRating: false,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 40,
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: AppColors.primary),
                    half: const Icon(Icons.star_half, color: AppColors.primary),
                    empty: const Icon(
                      Icons.star_border,
                      color: AppColors.primary,
                    ),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      selectedRating = rating;
                    });
                  },
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write your review here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');

                        if (token == null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Required'),
                              content: const Text(
                                'Please log in to add a review.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        await ref
                            .read(reviewNotifierProvider.notifier)
                            .submitReview(
                              menuItemId: widget.productId,
                              rating: selectedRating,
                              comment: reviewController.text,
                            );
                        Navigator.pop(context);
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "Submit Review",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserReviewCards extends StatelessWidget {
  const UserReviewCards({
    super.key,
    required this.userName,
    required this.rating,
    required this.reviewDate,
    required this.reviewText,
  });

  final String userName;
  final double rating;
  final String reviewDate;
  final String reviewText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://imgs.search.brave.com/7p-MC2-TJ5Vg4FozPjkuOrugYZpPKCr73_P26JbJN3w/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzExLzY4LzUwLzU3/LzM2MF9GXzExNjg1/MDU3OTRfSUJDRWlh/ZnNJckhGSjA5ZTY1/UDJ2aDUxMTVDMVhJ/N2UuanBn',
              ),
            ),
            const SizedBox(width: 8),
            Text(userName, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: rating,
              itemSize: 20,
              itemBuilder: (_, _) =>
                  const Icon(Icons.star, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            Text(reviewDate, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        SizedBox(height: 8),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: ReadMoreText(
            reviewText,
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimExpandedText: 'show less',
            trimCollapsedText: 'show more',
            moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            lessStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class RatingProgressIndicator extends StatelessWidget {
  const RatingProgressIndicator({
    super.key,
    required this.text,
    required this.value,
  });
  final int text;
  final double value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            text.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              color: AppColors.primary,
              backgroundColor: AppColors.grey300,
              borderRadius: BorderRadius.circular(7),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
