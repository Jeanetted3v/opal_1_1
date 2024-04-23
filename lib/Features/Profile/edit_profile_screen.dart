import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:opal_1_1/Features/Auth/auth_controller.dart';
import 'package:opal_1_1/Features/Profile/profile_screen.dart';
import 'package:opal_1_1/Widgets/Chips/ChipData/lookingfor_tags_chipdatalist.dart';
import 'package:opal_1_1/Widgets/Chips/ChipData/user_tags_chipdatalist.dart';
import 'package:opal_1_1/Widgets/Chips/custom_chip_input_field.dart';
import 'package:opal_1_1/Widgets/Chips/select_chips_screen.dart';
import 'package:opal_1_1/Widgets/Chips/show_select_chips_screen.dart';
import 'package:opal_1_1/Widgets/custom_textfield.dart';
import '../Add Opal/city_picker_widget.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static const routeName = '/edit-profile-screen';
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  List<String> selectedUserTagsChips = [];
  List<String> selectedLookingForTagsChips = [];
  String? selectedUserCity;
  String? selectedUserCountry;
  //List<File?> _selectedImages = List<File?>.filled(9, null);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await ref.read(authControllerProvider).getUserData();
    if (userData != null) {
      setState(() {
      _nameController.text = userData.userName;
      _companyController.text = userData.company ?? ''; 
      _aboutMeController.text = userData.aboutMe;
      selectedUserCountry = userData.userCountry ?? '';
      selectedUserCity = userData.userCity ?? '';
      selectedUserTagsChips = userData.userTags;
      selectedLookingForTagsChips = userData.lookingForTags;
    });
    } else {
      // Handle case where user data is null
    }
    } catch (e) {
      // Handle error when fetching user data
    print('Error loading user data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _companyController.dispose();
    _aboutMeController.dispose();
  }

  //Need to add in for camera
  // void selectImage() async {
  //   image = await pickImageFromGallery(context);
  //   setState(() {});
  // }


  //Storing User Data to Firebase
  Future<void> _storeUserData() async {
    String userName = _nameController.text.trim();
    String? company = _companyController.text.isEmpty ? null : _companyController.text.trim();
    String aboutMe = _aboutMeController.text.trim();
    String? userCountry = selectedUserCountry;
    String? userCity = selectedUserCity;
    List<String> userTags = selectedUserTagsChips;
    List<String> lookingForTags = selectedLookingForTagsChips; 

    if (userName.isNotEmpty) {
      await ref.read(authControllerProvider).saveUserDataToFirebase(
          context,userName, image, company, userCountry, userCity, aboutMe, userTags, lookingForTags);
    }
    //Need to have dialog box to show Data successfuly saved and pop to profile screen
  }

  //Navigate to ProfileScreen
  void navigateToProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, ProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; //screen size

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.grey.shade800,
          elevation: 0,
          toolbarHeight: 40,
          title: const Text('Edit Profile'),

          //Tick Icon
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                  onPressed:() async {
                    _storeUserData(); 
                    Navigator.of(context).pop();
                    //dialog box: profile successfully updated
                    }, 
                  icon: const Icon(Icons.done)),
            ),
          ]),
      body: SafeArea(
        child: ListView(
            children:[
            const SizedBox(height: 10),

            //Profile Pic
            Center(
              child: Stack(
                children: [
                  //Avatar Profile Picture
                  image == null
                      ? CircleAvatar(
                          //backgroundColor: Colors.grey,
                          backgroundImage: const NetworkImage(
                              'https://images.unsplash.com/photo-1676076798686-cbe8d0d07dff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'),
                          radius: size.height / 14,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: size.height / 14,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.add_a_photo)),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            //Name Field, mandatory
            CustomTextfield(
              textEditingController: _nameController,
              hintText: 'Individual\'s name',
              textInputType: TextInputType.text,
              subTitle: 'name*',
              maxLength: 80,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            const SizedBox(height: 20),

            //Company field, not mandatory
            CustomTextfield(
              textEditingController: _companyController,
              hintText: 'add company u r representing',
              textInputType: TextInputType.text,
              subTitle: 'company',
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            SizedBox(height: size.height / 20),

            //AboutMe field, mandatory
            CustomTextfield(
              textEditingController: _aboutMeController,
              hintText: 'About me*',
              textInputType: TextInputType.text,
              maxLines: 5,
              maxLength: 500,
              subTitle: 'about me',
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            const SizedBox(height: 20),

            //Location
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'LOCATION',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CityPickerWidget(onCitySelected: (city, country) {
              setState(() {
                selectedUserCity = city;
                selectedUserCountry = country;
              });
            }),

            const SizedBox(height: 20),

            //Select userTags Chips
                CustomChipInputField(
                  subTitle: 'I am...',
                  hintText: selectedUserTagsChips.isEmpty
                      ? 'Tap to select tags best describe u'
                      : '',
                  onTap: () {
                    List<ChipData> chipDataList = getUserTagsChipDataList();
                    showSelectChipsScreen(
                      context: context,
                      chipDataList: chipDataList,
                      alreadySelectedChips: selectedUserTagsChips,
                      maxChips: 5,
                    ).then((result) {
                      if (result != null) {
                        setState(() {
                          selectedUserTagsChips =
                              result.map((chipData) => chipData.label).toList();
                        });
                      }
                    });
                  },
                  selectedChips: selectedUserTagsChips,
                ),

                const SizedBox(height: 20),

            //Select lookingForTags Chips
                CustomChipInputField(
                  subTitle: 'Looking For',
                  hintText: selectedUserTagsChips.isEmpty
                      ? 'Tap to select tags u r looking for here'
                      : '',
                  onTap: () {
                    List<ChipData> chipDataList = getLookingForTagsChipDataList();
                    showSelectChipsScreen(
                      context: context,
                      chipDataList: chipDataList,
                      alreadySelectedChips: selectedLookingForTagsChips,
                      maxChips: 5,
                    ).then((result) {
                      if (result != null) {
                        setState(() {
                          selectedLookingForTagsChips =
                              result.map((chipData) => chipData.label).toList();
                        });
                      }
                    });
                  },
                  selectedChips: selectedLookingForTagsChips,
                ),

                const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}