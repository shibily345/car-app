import 'dart:io';
import 'dart:convert';

import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CarUpdatePage extends StatefulWidget {
  const CarUpdatePage({required this.thisCar, super.key});
  final CarEntity thisCar;

  @override
  State<CarUpdatePage> createState() => _CarUpdatePageState();
}

class _CarUpdatePageState extends State<CarUpdatePage> {
  CarModel? upCar;
  List<String> _makes = [];
  List<String> _models = [];
  String? _selectedMake;
  String? _selectedModel;
  bool _isLoading = false;
  bool _isDeleting = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateCar(context);
    _loadMakesAndModels();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        updateCar(context);
      });
    });
  }

  Future<void> _loadMakesAndModels() async {
    final String data =
        await rootBundle.loadString('assets/data/vehicles.json');
    final jsonResult = json.decode(data);
    setState(() {
      _makes = List<String>.from(jsonResult['brands'].map((b) => b['brand']));
      if (upCar != null && upCar!.make != null && upCar!.make!.isNotEmpty) {
        _selectedMake = upCar!.make;
        _models = List<String>.from(jsonResult['brands']
            .firstWhere((b) => b['brand'] == _selectedMake)['models']);
        if (upCar!.model != null && upCar!.model!.isNotEmpty) {
          _selectedModel = upCar!.model;
        }
      }
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    return Consumer<CarCreateProvider>(builder: (context, cp, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Update Car'),
          centerTitle: true,
          backgroundColor: th.colorScheme.surface,
          elevation: 0,
        ),
        floatingActionButton: _isLoading || _isDeleting
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'update',
                    backgroundColor: th.primaryColor,
                    icon: const Icon(Icons.update, color: Colors.white),
                    label: const Text('Update',
                        style: TextStyle(color: Colors.white)),
                    onPressed: _isLoading ? null : () => _onUpdate(cp),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton.extended(
                    heroTag: 'delete',
                    backgroundColor: Colors.red,
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                    onPressed: _isDeleting ? null : () => _onDelete(cp),
                  ),
                ],
              ),
        body: _isLoading || _isDeleting
            ? const Center(child: CircularProgressIndicator())
            : upCar != null
                ? Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildImageGrid(cp, th),
                        const SizedBox(height: 24),
                        _buildDropdownField(
                          label: 'Make',
                          value: _selectedMake,
                          items: _makes,
                          onChanged: (val) async {
                            setState(() {
                              _selectedMake = val;
                              _selectedModel = null;
                              _models = [];
                            });
                            final String data = await rootBundle
                                .loadString('assets/data/vehicles.json');
                            final jsonResult = json.decode(data);
                            setState(() {
                              _models = List<String>.from(jsonResult['brands']
                                  .firstWhere(
                                      (b) => b['brand'] == val)['models']);
                            });
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please select a make'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Model',
                          value: _selectedModel,
                          items: _models,
                          onChanged: (val) =>
                              setState(() => _selectedModel = val),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please select a model'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          controller: _yearController,
                          label: 'Year',
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter year' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          controller: _priceController,
                          label: 'Price',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter price' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          controller: _mileageController,
                          label: 'Mileage',
                          icon: Icons.speed,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter mileage' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          controller: _colorController,
                          label: 'Color',
                          icon: Icons.color_lens,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter color' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          controller: _locationController,
                          label: 'Location',
                          icon: Icons.location_on,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter location' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          controller: _descController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 3,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Enter description'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        const ThickDevider(),
                        const FeturesForm(),
                        const ThickDevider(),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
      );
    });
  }

  Widget _buildImageGrid(CarCreateProvider cp, ThemeData th) {
    // Get images from the provider (which includes both existing and newly picked images)
    final allImages = cp.car?.images ?? upCar?.images ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Images',
                style: th.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => cp.pickImage(),
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: th.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: allImages.length,
          itemBuilder: (context, index) {
            String url = allImages[index];
            bool isFile = !url.startsWith('/uploads');
            String finalUrl = isFile ? url : '${Ac.baseUrl}$url';
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: isFile
                          ? FileImage(File(finalUrl))
                          : NetworkImage(finalUrl) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        final updatedImages = List<String>.from(allImages);
                        updatedImages.removeAt(index);
                        upCar = upCar!.copyWith(images: updatedImages);
                        cp.updateCarData(upCar!);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(180),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }

  Future<void> _onUpdate(CarCreateProvider cp) async {
    if (!_formKey.currentState!.validate() || upCar == null) return;
    setState(() => _isLoading = true);
    try {
      // Get all images (existing + newly picked) from the provider
      final allImages = cp.car?.images ?? upCar!.images ?? [];
      List<String> images = await cp.uploadImages(allImages);
      final updatedCar = upCar!.copyWith(
        make: _selectedMake,
        model: _selectedModel,
        year: int.tryParse(_yearController.text) ?? DateTime.now().year,
        price: double.tryParse(_priceController.text) ?? 0.0,
        mileage: int.tryParse(_mileageController.text) ?? 0,
        color: _colorController.text.trim(),
        location: _locationController.text.trim(),
        description: _descController.text.trim(),
        images: images,
        updatedAt: DateTime.now(),
      );
      cp.eitherFailureOrUpdateCarData(value: updatedCar);
      if (mounted && cp.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Car updated successfully!'),
            backgroundColor: Theme.of(context).primaryColor,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating car: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onDelete(CarCreateProvider cp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Car'),
        content: const Text(
            'Are you sure you want to delete this car? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _isDeleting = true);
    try {
      cp.eitherFailureOrDeleteCarData(value: widget.thisCar.id ?? '');
      if (mounted && cp.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Car deleted successfully!'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting car: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  void updateCar(BuildContext ctx) {
    final carData = CarModel(
      id: widget.thisCar.id ?? '',
      title: widget.thisCar.title ?? '',
      make: widget.thisCar.make ?? '',
      model: widget.thisCar.model ?? '',
      year: widget.thisCar.year ?? DateTime.now().year,
      color: widget.thisCar.color ?? '',
      price: widget.thisCar.price ?? 0.0,
      mileage: widget.thisCar.mileage ?? 0,
      description: widget.thisCar.description ?? '',
      features: widget.thisCar.features ?? [],
      images: widget.thisCar.images ?? [],
      location: widget.thisCar.location ?? '',
      transmission: widget.thisCar.transmission ?? '',
      fuel: widget.thisCar.fuel ?? '',
      sellerId: widget.thisCar.sellerId ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    Provider.of<CarCreateProvider>(context, listen: false)
        .updateCarData(carData);
    upCar = carData;
    _priceController.text = carData.price?.toString() ?? '';
    _yearController.text = carData.year?.toString() ?? '';
    _mileageController.text = carData.mileage?.toString() ?? '';
    _colorController.text = carData.color ?? '';
    _locationController.text = carData.location ?? '';
    _descController.text = carData.description ?? '';
  }
}
