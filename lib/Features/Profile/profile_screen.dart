
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opal_1_1/Features/Auth/auth_controller.dart';
import 'package:opal_1_1/Features/Profile/edit_profile_screen.dart';
import 'package:opal_1_1/Features/Profile/setting_screen.dart';
import 'package:opal_1_1/Models/user_model.dart';
import 'package:opal_1_1/Widgets/loader.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  //File? image;
  //UserModel? _userModel;

  void navigateToEditProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, EditProfileScreen.routeName);
  }

  void navigateToSettingsScreen(BuildContext context) {
    Navigator.pushNamed(context, SettingScreen.routeName);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadUserData(); // Load user data when the screen initializes
  // }
  Future<UserModel?> _loadUserData() async {
  // Implement the logic to fetch user data here
  // For example, it might involve calling a method on your authControllerProvider
  return ref.read(authControllerProvider).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.grey.shade800,
          elevation: 0,
          toolbarHeight: 40,
          title: const Text('Profile'),
        //settings Icon
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                navigateToSettingsScreen(context);
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),

      body: FutureBuilder<UserModel?>(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          // Data loaded successfully, build the profile UI
          UserModel userModel = snapshot.data!;
          return SafeArea(

        //Scroll View
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and User Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userModel.profilePic != null  
                        ? NetworkImage(userModel.profilePic!) as ImageProvider
                        : const AssetImage('assets/gray_man.png'),
                  ),

                  const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            userModel.userName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            softWrap: true, 
                          ),
                           Text(
                                'Company: ${userModel.company ?? ''}',
                                style: const TextStyle(fontSize: 14),
                                softWrap: true, 
                              ),
                          
                          Text(
                            'AboutMe: ${userModel.aboutMe}',
                            style: const TextStyle(fontSize: 14),
                            softWrap: true, 
                          ),

                          //UI: maybe change to chips
                          Text(
                            'Tags: ${userModel.userTags.join(', ')}',
                            style: const TextStyle(fontSize: 12),
                            softWrap: true, 
                          ),

                          Text(
                            'Looking for: ${userModel.lookingForTags.join(', ')}',
                            style: const TextStyle(fontSize: 12),
                            softWrap: true, 
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Edit Profile Button
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,top: 7),
              child: ElevatedButton(
                onPressed: () {
                  navigateToEditProfileScreen(context);
                },
                child: Text('Edit Profile',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade100),),
                style: ElevatedButton.styleFrom(
                  // Set the button's fill color
                  backgroundColor: Colors.blue.shade300, 
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  // Making the button longer by setting minimum size
                  minimumSize: Size(double.infinity, 8), // double.infinity makes it as wide as the parent
                ),
              ),
            ),


            // Cards Grid
            GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Disables GridView's own scrolling
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                padding: const EdgeInsets.all(10),
                children: List.generate(
                  10, // Replace 6 with the number of cards you want to display
                  (index) => Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 40),
                        Text('Placeholder'),
                      ],
                    ),
                  ),
                ),
              ),
            
          ],
        ),
        ),);
        } else{
          // Handle the case where there is no data
          return Center(child: Text("No user data available"));
        }
        },
      ),
  );    }
}




//           child: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             //Profile Pic
//             Stack(
//               children: [
//                 //Avatar Profile Picture
//                 image == null
//                     ? CircleAvatar(
//                         //backgroundColor: Colors.grey,
//                         backgroundImage: const NetworkImage(
//                             'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png'),
//                         radius: size.height / 14,
//                       )
//                     : CircleAvatar(
//                         backgroundImage: FileImage(image!),
//                         radius: size.height / 14,
//                       ),
//                 Positioned(
//                   bottom: -10,
//                   left: 80,
//                   child: IconButton(
//                       onPressed: () {}, icon: const Icon(Icons.add_a_photo)),
//                 )
//               ],
//             ),

//             const SizedBox(height: 10),

//             //UserName
//             //Need to add a verified tick, Icons.done
//             const SizedBox(
//               child: Text(
//                 'Username',
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),

//             //Edit Profile Button
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: SizedBox(
//                 width: size.width / 1.7,
//                 height: 35,
//                 child: CustomButton(
//                   text: 'Edit Profile',
//                   onPressed: () =>
//                       //Navigate to EditProfileScreen
//                       navigateToEditProfileScreen(context),
//                 ),
//               ),
//             ),

//             const Divider(),

//             //Grid View of OpalCards
//           ],
//         ),
//       )),
//     );
//   }
// }