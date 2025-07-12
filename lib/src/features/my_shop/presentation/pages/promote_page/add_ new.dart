import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPromotion extends StatefulWidget {
  const NewPromotion({super.key});

  @override
  State<NewPromotion> createState() => _NewPromotionState();
}

class _NewPromotionState extends State<NewPromotion> {
  int _currentPage = 0;
  String? _selectedField;
  int? _productCount;
  File? _selectedImage;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _fields = ['Field A', 'Field B', 'Field C'];
  final List<int> _productCounts = [1, 2, 3, 4, 5];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    DateTime now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          // Page Slider
          Container(
            height: 300,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    'Page ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),

          // Field Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Field',
                border: OutlineInputBorder(),
              ),
              value: _selectedField,
              items: _fields.map((field) {
                return DropdownMenuItem(
                  value: field,
                  child: Text(field),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedField = value;
                });
              },
            ),
          ),

          // Product Count Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Select Product Count',
                border: OutlineInputBorder(),
              ),
              value: _productCount,
              items: _productCounts.map((count) {
                return DropdownMenuItem(
                  value: count,
                  child: Text('$count Products'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _productCount = value;
                });
              },
            ),
          ),

          // // Image Selector
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: ElevatedButton.icon(
          //     onPressed: _pickImage,
          //     icon: const Icon(Icons.image),
          //     label: const Text('Select Image'),
          //   ),
          // ),
          // if (_selectedImage != null)
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Image.file(
          //       _selectedImage!,
          //       height: 100,
          //       width: 100,
          //       fit: BoxFit.cover,
          //     ),
          //   ),

          // Date Selectors

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Select Image'),
            ),
          ),
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                _selectedImage!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ElevatedButton(
            onPressed: () => _pickDate(isStartDate: true),
            child: const Text('Start Date'),
          ),
          ElevatedButton(
            onPressed: () => _pickDate(isStartDate: false),
            child: const Text('End Date'),
          ),

          const SizedBox(height: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Selected Field: ${_selectedField ?? 'None'}'),
                    Text('Product Count: ${_productCount ?? 'None'}'),
                    Text(
                        'Start Date: ${_startDate != null ? _startDate!.toLocal().toString().split(' ')[0] : 'Not Selected'}'),
                    Text(
                        'End Date: ${_endDate != null ? _endDate!.toLocal().toString().split(' ')[0] : 'Not Selected'}'),
                    if (_selectedImage != null) const Text('Image: Selected'),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
