import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/utils/constants/app_colors.dart';
import 'package:mobile/utils/constants/app_sizes.dart';
import 'package:readmore/readmore.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Reviews & Ratings',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          leading: BackButton(color: Colors.black),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Rate Your Experience',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          glowColor: AppColors.grey400,
                          itemCount: 5,
                          itemSize: 40,
                          ratingWidget: RatingWidget(
                            full: const Icon(
                              Icons.star,
                              color: AppColors.primary,
                            ),
                            half: const Icon(
                              Icons.star_half,
                              color: AppColors.primary,
                            ),
                            empty: const Icon(
                              Icons.star_border,
                              color: AppColors.primary,
                            ),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Feedback is important to us. Please let us know about your experience.",
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      maxLines: 3,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Write your review here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          icon: const Icon(Icons.rate_review),
          label: const Text('Add Review'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Ratings and reviews are verified and are from people who use the same type of device that you use.',
                style: TextStyle(color: AppColors.textPrimary),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        '4.5',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          RatingProgressIndicator(text: 5, value: 0.7),
                          RatingProgressIndicator(text: 4, value: 0.5),
                          RatingProgressIndicator(text: 3, value: 0.4),
                          RatingProgressIndicator(text: 2, value: 0.3),
                          RatingProgressIndicator(text: 1, value: 0.1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    RatingBarIndicator(
                      rating: 4.5,
                      itemSize: 20,
                      itemBuilder: (_, _) =>
                          const Icon(Icons.star, color: AppColors.primary),
                    ),
                    Text(
                      '113,2',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: UserReviewCards(
                  userName: 'Jhon Doe',
                  rating: 4.5,
                  reviewDate: '10 Nov 2025',
                  reviewText:
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                ),
              ),
            ],
          ),
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
        ReadMoreText(
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
