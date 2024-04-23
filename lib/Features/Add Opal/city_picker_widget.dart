import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CityPickerWidget extends StatefulWidget {
  final Function(String? city, String? country) onCitySelected;

  const CityPickerWidget({Key? key, required this.onCitySelected})
      : super(key: key);

  @override
  State<CityPickerWidget> createState() => _CityPickerWidgetState();
}

class _CityPickerWidgetState extends State<CityPickerWidget> {
  String? _cityName;
  String? _countryName;
  bool _showCityAndCountry = true;

  //Getting the position
  Future<Map<String, String?>> getCurrentCityAndCountry() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled'); //Added
      return Future.error('Location sevices are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied'); // Added
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied'); // Added
      return Future.error(
          'Location permissions are permanently denied, we cannot get the city for you');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: false,
          timeLimit: const Duration(seconds: 5));
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String? city = placemarks[0].administrativeArea;
      String? country = placemarks[0].country;

      if (city == null || city.isEmpty) {
        return {'city': '', 'country': country};
      } else {
        return {'city': city, 'country': country};
      }
    } catch (e) {
      print('Error getting city: $e'); // Added
      return {'city': 'Unknown', 'country': 'Unknown'};
    }
  }

  void _updateCityAndCountry() async {
    print('Tapped on CityPickerWidget');
    Map<String, String?> locationInfo = await getCurrentCityAndCountry();
    setState(() {
      _cityName = locationInfo['city'];
      _countryName = locationInfo['country'];
    });
    print('City and Country name obtained: $_cityName, $_countryName');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: InkWell(
                onTap: _updateCityAndCountry,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      !_showCityAndCountry
                          ? 'Tap to get location of this Opal'
                          : (_cityName != null ? '$_cityName, ' : ''),
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                    Text(
                      !_showCityAndCountry
                          ? ''
                          : (_countryName ??
                              'Tap to get location of this Opal'),
                      softWrap: true,
                      style: TextStyle(
                        color: _countryName != null
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Show current location of this Opal',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                Spacer(),
                Switch(
                  value: _showCityAndCountry,
                  onChanged: (bool value) {
                    setState(() {
                      _showCityAndCountry = value;
                    });
                  },
                  activeColor: Colors.green.shade300,
                  inactiveTrackColor: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
