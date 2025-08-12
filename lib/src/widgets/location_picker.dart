import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const String googleApiKey = 'AIzaSyBJPJF2kvkLCgrdMjjw8JvYnho47PR7HWM';

class LocationPicker extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng, String) onLocationSelected;
  final String title;

  const LocationPicker({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
    this.title = 'Select Location',
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _address = '';
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _markers.add(Marker(
        markerId: const MarkerId('selected'),
        position: _selectedLocation!,
      ));
      _reverseGeocode(_selectedLocation!);
    } else {
      _determinePosition();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('selected'),
        position: _selectedLocation!,
      ));
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
    _reverseGeocode(_selectedLocation!);
  }

  Future<void> _searchPlace(String input) async {
    if (input.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    // Add a small delay to avoid too many API calls
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() => _isSearching = true);

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=$googleApiKey&language=en&types=geocode',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _searchResults = data['predictions'] ?? [];
            _isSearching = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _selectPlace(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey&language=en',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];
      final address = data['result']['formatted_address'] ?? '';
      final latLng = LatLng(lat, lng);
      setState(() {
        _selectedLocation = latLng;
        _address = address;
        _markers.clear();
        _markers.add(Marker(
          markerId: const MarkerId('selected'),
          position: latLng,
        ));
        _searchResults = [];
        _searchController.text = address;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleApiKey&language=en',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        setState(() {
          _address = data['results'][0]['formatted_address'];
          _searchController.text = _address;
        });
      }
    }
  }

  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('selected'),
        position: position,
      ));
    });
    await _reverseGeocode(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _determinePosition,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a place or address',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchResults = [];
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blue.shade300, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: _searchPlace,
                ),
                if (_isSearching)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Searching...'),
                      ],
                    ),
                  ),
                if (_searchResults.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          leading:
                              const Icon(Icons.location_on, color: Colors.grey),
                          title: Text(
                            result['description'] ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                          onTap: () => _selectPlace(result['place_id']),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _selectedLocation == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation!,
                          zoom: 15,
                        ),
                        onMapCreated: (controller) =>
                            _mapController = controller,
                        markers: _markers,
                        onTap: _onMapTap,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                      ),
                      // Custom zoom controls
                      Positioned(
                        right: 16,
                        top: 16,
                        child: Column(
                          children: [
                            FloatingActionButton.small(
                              heroTag: 'zoomIn',
                              onPressed: () {
                                _mapController?.animateCamera(
                                  CameraUpdate.zoomIn(),
                                );
                              },
                              child: const Icon(Icons.add),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton.small(
                              heroTag: 'zoomOut',
                              onPressed: () {
                                _mapController?.animateCamera(
                                  CameraUpdate.zoomOut(),
                                );
                              },
                              child: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Select This Location'),
            onPressed: _selectedLocation == null
                ? null
                : () {
                    widget.onLocationSelected(_selectedLocation!, _address);
                    Navigator.pop(context);
                  },
          ),
        ),
      ),
    );
  }
}
