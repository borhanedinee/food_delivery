import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery/presentaion/controllers/profile_controller.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<void> showLocationSearchDialog(BuildContext context) async {
  final controller = Get.find<ProfileController>();
  final TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];

  await showDialog(
    context: context,
    builder: (context) {
      final screenSize = MediaQuery.of(context).size;
      final fontScale = screenSize.width / 400; // Base scaling factor

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenSize.height * 0.6, // Limit dialog height
            maxWidth: screenSize.width * 0.9, // Limit dialog width
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // Adjust for keyboard
                    left: screenSize.width * 0.04,
                    right: screenSize.width * 0.04,
                    top: screenSize.height * 0.02,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search Location',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16 * fontScale,
                                ),
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search location (e.g., Oran, Algeria)',
                          hintStyle: TextStyle(fontSize: 12 * fontScale),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20 * fontScale,
                            color: AppColors.primaryColor,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.04,
                            vertical: screenSize.height * 0.015,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 14 * fontScale),
                        onChanged: (value) async {
                          if (value.isEmpty) {
                            setState(() {
                              searchResults = [];
                            });
                            return;
                          }

                          // Make API request to Nominatim
                          try {
                            final response = await http.get(
                              Uri.parse(
                                'https://nominatim.openstreetmap.org/search?q=$value&format=json&addressdetails=1&limit=5',
                              ),
                              headers: {
                                'User-Agent':
                                    'WonderFood (your.email@example.com)', // Required by Nominatim
                              },
                            );

                            if (response.statusCode == 200) {
                              setState(() {
                                searchResults = jsonDecode(response.body);
                              });
                            } else {
                              Get.snackbar(
                                  'Error', 'Failed to fetch locations');
                            }
                          } catch (e) {
                            Get.snackbar(
                                'Error', 'Failed to fetch locations: $e');
                          }
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      SizedBox(
                        height: screenSize.height *
                            0.25, // Responsive height for ListView
                        width: double.infinity,
                        child: searchResults.isEmpty
                            ? Center(
                                child: Text(
                                  'No results found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 12 * fontScale,
                                        color: Colors.grey[600],
                                      ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  final result = searchResults[index];
                                  final displayName = result['display_name'] ??
                                      'Unknown Location';
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenSize.width * 0.02,
                                      vertical: screenSize.height * 0.005,
                                    ),
                                    title: Text(
                                      displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 12 * fontScale,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () async {
                                      await controller
                                          .updateUserAddress(displayName);
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.back(); // Close the dialog
                          },
                          child: Text(
                            'Cancel',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12 * fontScale,
                                      color: AppColors.primaryColor,
                                    ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.04,
                              vertical: screenSize.height * 0.015,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
