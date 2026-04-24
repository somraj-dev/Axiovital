import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'location_service.dart';
import 'address_details_sheet.dart';

class ConfirmLocationPage extends StatefulWidget {
  final String? query;
  final bool useCurrentLocation;
  final Address? editAddress;

  const ConfirmLocationPage({
    super.key,
    this.query,
    this.useCurrentLocation = false,
    this.editAddress,
  });

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

class _ConfirmLocationPageState extends State<ConfirmLocationPage> {
  String _address = 'Fetching location...';
  String _subAddress = '';
  bool _isLoading = true;
  Position? _position;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    if (widget.useCurrentLocation) {
      final pos = await LocationService().getCurrentPosition();
      if (pos != null) {
        _position = pos;
        await _getAddressFromLatLng(pos.latitude, pos.longitude);
      } else {
        setState(() {
          _address = 'Location not found';
          _isLoading = false;
        });
      }
    } else if (widget.query != null) {
      try {
        List<Location> locations = await locationFromAddress(widget.query!);
        if (locations.isNotEmpty) {
          final loc = locations.first;
          _position = Position(
            latitude: loc.latitude,
            longitude: loc.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
          await _getAddressFromLatLng(loc.latitude, loc.longitude);
        }
      } catch (e) {
        setState(() {
          _address = widget.query!;
          _isLoading = false;
        });
      }
    } else if (widget.editAddress != null) {
      setState(() {
        _address = widget.editAddress!.name;
        _subAddress = widget.editAddress!.fullAddress;
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      setState(() {
        _address = place.subLocality ?? place.locality ?? 'Selected Location';
        _subAddress = '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea} (${place.postalCode})';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _address = 'Unknown Location';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Confirm delivery area',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          // Mock Map View
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 100, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Map View Placeholder', style: TextStyle(color: Colors.grey.shade600)),
                  if (_position != null) ...[
                    const SizedBox(height: 8),
                    Text('${_position!.latitude.toStringAsFixed(4)}, ${_position!.longitude.toStringAsFixed(4)}', 
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ],
              ),
            ),
          ),
          
          // Marker
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Your order will be delivered here',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const Icon(Icons.location_on, color: Color(0xFFFF5247), size: 48),
              ],
            ),
          ),
          
          // Use Current Location Button
          Positioned(
            bottom: 180,
            right: 0, left: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => _initLocation(),
                icon: const Icon(Icons.my_location, size: 18),
                label: const Text('Use current location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ),
          
          // Bottom Info Box
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.black87, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_address, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 4),
                            Text(_subAddress, style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Change', style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddressDetailsSheet(
                            preFilledAddress: _subAddress,
                            city: _address,
                            editAddress: widget.editAddress,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5247),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Confirm location and continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
