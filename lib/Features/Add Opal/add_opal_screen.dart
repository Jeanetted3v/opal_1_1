import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:opal_1_1/Widgets/Chips/custom_chip_input_field.dart';
import 'package:opal_1_1/Widgets/dialog_box.dart';

import '../../Common/providers.dart';
import '../../Common/utils/image_picker.dart';
import '../../Widgets/Chips/ChipData/industry_pri_chipdatalist.dart';
import '../../Widgets/Chips/select_chips_screen.dart';
import '../../Widgets/Chips/ChipData/selling_or_buying_chipdatalist.dart';
import '../../Widgets/Chips/show_select_chips_screen.dart';
import '../../Widgets/Chips/ChipData/tags_chipdatalist.dart';
import '../../Widgets/custom_textfield.dart';
import 'city_picker_widget.dart';



class AddOpalScreen extends ConsumerStatefulWidget {
  final String? opalId;
  final bool isEditMode;

  AddOpalScreen({this.opalId, this.isEditMode = false});
  @override
  ConsumerState<AddOpalScreen> createState() => _AddOpalScreenState();
}

class _AddOpalScreenState extends ConsumerState<AddOpalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _opalTitle = TextEditingController();
  final TextEditingController _aboutThisOpal = TextEditingController();
  late String opalId;
  List<String> selectedIndustryPriChips = [];
  List<String> selectedSellingBuyingChips = [];
  String? selectedCity;
  String? selectedCountry;
  List<String> selectedTagsChips = [];
  final List<File?> _selectedImages = List<File?>.filled(9, null);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Check if an opalId was passed. If not, generate a new one.
    if (widget.isEditMode && widget.opalId != null) {
      // If in edit mode and an opalId is provided, use it
      opalId = widget.opalId!;
    } else {
      // Otherwise, generate a new opalId
      opalId = FirebaseFirestore.instance.collection('opals').doc().id;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void selectImage(int index) async {
    print("SelectImage called with index: $index");
    File? selectedImage = await showImagePickerOptions(context);
    print("Selected image: $selectedImage");
    if (selectedImage != null && mounted) {
      setState(() {
        _selectedImages[index] = selectedImage;
      });
    }
  }

  // Saving Opal Data to Firebase
  Future<void> _saveOpalData() async {
    // Extract data from controllers and widgets
    final user = ref.read(currentUserProvider);
    DocumentSnapshot userProfile =
        await ref.read(userProfileProvider(user!.uid).future);

    String uid = user.uid;
    String userName = userProfile['userName'];
    bool isOnline = userProfile['isOnline']; //Is this necessary?
    String opalTitle = _opalTitle.text;
    String aboutOpal = _aboutThisOpal.text;
    List<String> industry = selectedIndustryPriChips;
    List<String> sellingOrBuying = selectedSellingBuyingChips;
    String? country = selectedCountry;
    String? city = selectedCity;
    List<String> opalTags = selectedTagsChips;
    List<File> opalPics =
        _selectedImages.where((image) => image != null).toList().cast<File>();

    // Call the saveOpal function from the OpalController
    await ref.read(opalControllerProvider).saveOpalDataToFirebase(
        userName: userName,
        uid: uid,
        opalTitle: opalTitle,
        opalId: opalId,
        opalPics: opalPics,
        isOnline: isOnline,
        country: country,
        city: city,
        aboutOpal: aboutOpal,
        industry: industry,
        sellingOrBuying: sellingOrBuying,
        opalTags: opalTags,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.grey.shade800,
          elevation: 0,
          toolbarHeight: 40,
          title: const Text('Edit Opal'),

          //Tick Icon / Done
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                  onPressed: () {
                    _saveOpalData();
                    
                    showDialogBox(
                      context: context,
                      title: 'Success',
                      text: 'Opal saved successfully!',
                      actions: [{
                        'text': 'Ok',
                        'onPressed': () { _tabController.animateTo(1);},
                        'style': const TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 20)}],
                      );
                  },
                  icon: const Icon(Icons.done)),
            ),
          ]),
      body: Column(
        children: [
          SizedBox(height: size.height / 19,
            child: ValueListenableBuilder<int>(
              valueListenable:
                  _tabController.animation!.drive(IntTween(begin: 0, end: 1)),
              builder: (BuildContext context, int value, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Edit and Preview Button
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => _tabController.animateTo(0),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                                color: value == 0
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade400,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(width: size.width / 4),
                        TextButton(
                          onPressed: () => _tabController.animateTo(1),
                          child: Text(
                            'Preview',
                            style: TextStyle(
                                color: value == 1
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade400,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(thickness: 1),

          //Body of Photos and areas to be filled in.
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildEditView(),
                buildPreviewView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditView() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Photos
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(9, (index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: InkWell(
                    onTap: () {
                      if (_selectedImages[index] != null) {
                        // If an image is selected, delete it
                        setState(() {
                          _selectedImages[index] = null;
                        });
                      } else {
                        // If no image is selected, open the image picker
                        selectImage(index);
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 3,
                                offset: Offset(2, 2),
                              ),
                            ],
                            image: _selectedImages[index] != null
                                ? DecorationImage(
                                    image: FileImage(_selectedImages[index]!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            _selectedImages[index] != null
                                ? Icons.cancel_rounded
                                : Icons.add_circle_outline_outlined,
                            color: Colors.pink.shade200,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            //Text fields for users to fill in
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                CustomTextfield(
                  textEditingController: _opalTitle,
                  hintText: 'Opportunity title',
                  textInputType: TextInputType.text,
                  subTitle: 'Title',
                  maxLength: 80,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                ),
                const SizedBox(height: 20),

                //About Opal
                CustomTextfield(
                  textEditingController: _aboutThisOpal,
                  hintText: 'Describe this opportunity',
                  textInputType: TextInputType.text,
                  subTitle: 'ABOUT',
                  maxLength: 500,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                ),
                const SizedBox(height: 20),

                //Select City
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
                    selectedCity = city;
                    selectedCountry = country;
                  });
                }),

                const SizedBox(height: 20),

                //Select Industry Primary
                CustomChipInputField(
                  subTitle: 'Industry',
                  hintText: selectedIndustryPriChips.isEmpty
                      ? 'Tap to select industry'
                      : '',
                  onTap: () {
                    List<ChipData> chipDataList = getIndustryPriChipDataList();
                    showSelectChipsScreen(
                      context: context,
                      chipDataList: chipDataList,
                      alreadySelectedChips: selectedIndustryPriChips,
                      maxChips: 1,
                    ).then((result) {
                      if (result != null) {
                        setState(() {
                          selectedIndustryPriChips =
                              result.map((chipData) => chipData.label).toList();
                        });
                      }
                    });
                  },
                  selectedChips: selectedIndustryPriChips,
                ),

                const SizedBox(height: 20),

                //Select Sub-sector

                //Selling or Buying?
                CustomChipInputField(
                  subTitle: 'Selling or Buying?',
                  hintText: selectedSellingBuyingChips.isEmpty
                      ? 'To sell or buy a product or service?'
                      : '',
                  onTap: () {
                    List<ChipData> chipDataList =
                        getSellingBuyingChipDataList();
                    showSelectChipsScreen(
                            context: context,
                            chipDataList: chipDataList,
                            alreadySelectedChips: selectedSellingBuyingChips,
                            maxChips: 1)
                        .then((result) {
                      if (result != null) {
                        setState(() {
                          selectedSellingBuyingChips =
                              result.map((chipData) => chipData.label).toList();
                        });
                      }
                    });
                  },
                  selectedChips: selectedSellingBuyingChips,
                ),

                const SizedBox(height: 20),

                //Tags
                CustomChipInputField(
                  subTitle: 'Tags',
                  hintText: selectedTagsChips.isEmpty
                      ? 'Tap to choose tags to optimize searching'
                      : '',
                  onTap: () {
                    List<ChipData> chipDataList = getTagsChipDataList();
                    showSelectChipsScreen(
                            context: context,
                            chipDataList: chipDataList,
                            alreadySelectedChips: selectedTagsChips,
                            maxChips: 5)
                        .then((result) {
                      if (result != null) {
                        setState(() {
                          selectedTagsChips =
                              result.map((chipData) => chipData.label).toList();
                        });
                      }
                    });
                  },
                  selectedChips: selectedTagsChips,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPreviewView() {
    return Center(
      child: Text('Preview will be shown here'),
    );
  }
}