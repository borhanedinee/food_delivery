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
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Search Location'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search location (e.g., Oran, Algeria)...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
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
                      } else {}
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to fetch locations: $e');
                    }
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  width: double.maxFinite,
                  child: searchResults.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final result = searchResults[index];
                            final displayName =
                                result['display_name'] ?? 'Unknown Location';
                            return ListTile(
                              title: Text(displayName),
                              onTap: () async {
                                await controller.updateUserAddress(displayName);
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
  );
}
