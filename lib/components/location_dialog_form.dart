import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/services/graphql_service.dart';
import 'package:shop_app/size_config.dart';
import 'package:collection/collection.dart';

AddressComponent? getSpecificComponent(PlacesDetailsResponse detail, key) {
  if (key is String) {
    return detail.result.addressComponents
        .firstWhereOrNull((c) => c.types.contains(key));
  } else {
    return detail.result.addressComponents
        .firstWhereOrNull((c) => c.types.any((type) => key.contains(type)));
  }
}

class LocationDialogForm extends StatefulWidget {
  @override
  _LocationDialogFormState createState() => _LocationDialogFormState();
}

class _LocationDialogFormState extends State<LocationDialogForm> {
  final _addressController = TextEditingController();
  final _streetNumberController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _extraDetailsController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PlacesDetailsResponse? detail;

  String? validateAddress(PlacesDetailsResponse detail) {
    final country = getSpecificComponent(detail, "country");
    final state = getSpecificComponent(detail, "administrative_area_level_1");
    final street = getSpecificComponent(detail, "route");
    final city = getSpecificComponent(
        detail, ["administrative_area_level_2", "locality"]);

    if (country == null) {
      return 'Country is missing in the address';
    } else if (state == null) {
      return 'State is missing in the address';
    } else if (city == null) {
      return 'City is missing in the address';
    } else if (street == null) {
      return 'Street name is missing in the address';
    }

    return null;
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final currentStreetNumber =
          getSpecificComponent(detail!, "street_number")?.longName;

      final country = getSpecificComponent(detail!, "country")?.longName;
      final state =
          getSpecificComponent(detail!, ["administrative_area_level_1"])
              ?.longName;
      final city = getSpecificComponent(
          detail!, ["administrative_area_level_2", "locality"])?.longName;
      final streetAddress = getSpecificComponent(detail!, "route")?.longName;
      final zipCode = _postalCodeController.text;
      final streetNumber = _streetNumberController.text;
      final apartment = _apartmentController.text;
      final extraDetails = _extraDetailsController.text;

      try {
        await graphQLQueryHandler("saveUserAddress", {
          "country": country,
          "state": state,
          "city": city,
          "street_address": streetAddress,
          "street_number": streetNumber,
          "zip_code": zipCode,
          "apartment": apartment,
          "extra_details": extraDetails,
          "user_id": GlobalManager().userId
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your address has been successfully added')),
        );

        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving address. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Address'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(16)),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.location_on, size: 50, color: kPrimaryColor),
                SizedBox(height: getProportionateScreenHeight(50)),
                TextFormField(
                  controller: _addressController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid address';
                    }

                    return validateAddress(detail!);
                  },
                  readOnly: true,
                  onTap: () async {
                    Prediction? prediction = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: dotenv.get("GOOGLE_MAPS_API_KEY"),
                      mode: Mode.overlay,
                      language: "en",
                      types: ["address"],
                      components: [],
                      strictbounds: false,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    );
                    if (prediction != null) {
                      GoogleMapsPlaces _places = GoogleMapsPlaces(
                          apiKey: dotenv.get("GOOGLE_MAPS_API_KEY"));
                      detail = await _places
                          .getDetailsByPlaceId(prediction.placeId!);
                      final streetNumber =
                          getSpecificComponent(detail!, "street_number");

                      if (streetNumber?.longName != null) {
                        _streetNumberController.text = streetNumber!.longName;
                        String addressWithoutStreetNumber = prediction
                            .description!
                            .replaceFirst(streetNumber.longName, '')
                            .trim();
                        _addressController.text = addressWithoutStreetNumber;
                      } else {
                        _addressController.text = prediction.description!;
                      }
                      final zipCode =
                          getSpecificComponent(detail!, "postal_code")
                              ?.longName;
                      if (zipCode != null) {
                        _postalCodeController.text = zipCode;
                      }
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter address',
                    suffixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _streetNumberController,
                        textAlign: TextAlign.center,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Missing number';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Street Number',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 15.0),
                        ),
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _apartmentController,
                        decoration: InputDecoration(
                          hintText: 'Apartment',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 15.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                TextFormField(
                  controller: _postalCodeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Missing postal code';
                    }

                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Postal Code'),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                TextFormField(
                  controller: _extraDetailsController,
                  decoration:
                      InputDecoration(hintText: 'Specific Instructions'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: TextButton(
          child: Text('Add', style: TextStyle(color: kTextColor)),
          onPressed: _onSubmit,
        ),
      ),
    );
  }
}
