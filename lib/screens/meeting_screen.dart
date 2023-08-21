import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  bool isAddFormVisible = false;
  TextEditingController date = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                color: Colors.purple,
              ),
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            if (isAddFormVisible)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          suffixIcon: IconButton(
                            onPressed: () async {
                              Location location = new Location();

                              bool _serviceEnabled;
                              PermissionStatus _permissionGranted;
                              LocationData _locationData;

                              _serviceEnabled = await location.serviceEnabled();
                              if (!_serviceEnabled) {
                                _serviceEnabled =
                                    await location.requestService();
                                if (!_serviceEnabled) {
                                  return;
                                }
                              }

                              _permissionGranted =
                                  await location.hasPermission();
                              if (_permissionGranted ==
                                  PermissionStatus.denied) {
                                _permissionGranted =
                                    await location.requestPermission();
                                if (_permissionGranted !=
                                    PermissionStatus.granted) {
                                  return;
                                }
                              }

                              _locationData = await location.getLocation();
                              // _locationData.
                              locationController.text =
                                  _locationData.latitude.toString() +
                                      " " +
                                      _locationData.longitude.toString();
                            },
                            icon: Icon(Icons.location_on),
                          ),
                        ),
                      ),
                      TextField(
                        controller: date,
                        decoration: InputDecoration(
                          labelText: 'Date Time',
                          suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () async {
                                var dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1999),
                                    lastDate: DateTime.now());
                                date.text = DateFormat('dd-MM-yyyy hh:mm')
                                    .format(dateTime!);
                                // dateTime.then(
                                //     (value) => date.text = value.toString());
                              }),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Note'),
                        maxLines: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              isAddFormVisible = false;
                              setState(() {});
                            },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              isAddFormVisible = false;
                              setState(() {});
                            },
                            child: Text('Save'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    ListTile(title: Text('Meeting note')),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isAddFormVisible = true;
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
