import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/user_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/profile_controller.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';

class ManageProfileScreen extends StatelessWidget {
  const ManageProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fontScale = screenSize.width / 400; // Base scaling factor

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Manage Profile',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16 * fontScale,
              ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: GetBuilder<ProfileController>(
          builder: (controller) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenSize.height * 0.04),
                Container(
                  padding: EdgeInsets.all(screenSize.width * 0.005),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screenSize.width * 0.1),
                    child: Image.asset(
                      'assets/images/rania_avatar.png',
                      width: screenSize.width * 0.2, // Smaller, responsive size
                      height: screenSize.width * 0.2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: screenSize.width * 0.2,
                        height: screenSize.width * 0.2,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.broken_image,
                          size: 30 * fontScale,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  currentUser?.name ?? 'Guest',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * fontScale,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenSize.height * 0.04),
                // Name Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * fontScale,
                          ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(fontSize: 12 * fontScale),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.04,
                          vertical: screenSize.height * 0.015,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
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
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    // Phone Field
                    Text(
                      'Phone',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * fontScale,
                          ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(fontSize: 12 * fontScale),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.04,
                          vertical: screenSize.height * 0.015,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
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
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    // Email Field
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * fontScale,
                          ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(fontSize: 12 * fontScale),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.04,
                          vertical: screenSize.height * 0.015,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
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
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    // Gender Field
                    Text(
                      'Gender',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * fontScale,
                          ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    DropdownButtonFormField<String>(
                      value: controller.selectedGender ?? 'Female',
                      onChanged: (value) {
                        controller.updateGender(value!);
                      },
                      items: controller.genderOptions.map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(
                            gender,
                            style: TextStyle(
                                fontSize: 14 * fontScale, color: Colors.black),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.04,
                          vertical: screenSize.height * 0.015,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
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
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: screenSize.height * 0.06, // Smaller height
                      child: controller.isUpdatingLoading
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: controller.updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Save Changes',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14 * fontScale,
                                    ),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
