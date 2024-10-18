import 'dart:io';

import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/widgets/text_fields.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/detail_sections.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ConfirmationForm extends StatelessWidget {
  final CarUpdateModel car;
  const ConfirmationForm({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);
    return ListView(
      children: [
        60.0.spaceX,
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Ctext(
            'Images:',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              crossAxisCount: 2,
            ),
            itemCount: car.images.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    image: DecorationImage(
                        image: FileImage(File(car.images[index])))),
                height: 120,
                width: 120,
                child: IconButton(
                    onPressed: () {
                      context
                          .read<CarCreateProvider>()
                          .deleteImage(car.images[index]);
                    },
                    icon: const Icon(Icons.delete)),
              );
            },
          ),
        ),
        const ThickDevider(),
        SubSec(
          title: "Price ",
          name: car.price.toString(),
        ),

        SubSec(
          title: "Make ",
          name: car.make,
        ),

        SubSec(
          title: "Model ",
          name: car.model,
        ),

        SubSec(
          title: "Year ",
          name: car.year.toString(),
        ),

        SubSec(
          title: "Milage ",
          name: car.mileage.toString(),
        ),

        SubSec(
          title: "Transmission ",
          name: car.transmission,
        ),

        SubSec(
          title: "Fuel ",
          name: car.fuel,
        ),

        SubSec(
          title: "Location ",
          name: car.location,
        ),

        const ThickDevider(),
        DetailsSec(
          th: th,
          details: car.features,
        ),
        const ThickDevider(),
        DescSec(
          th: th,
          description: car.description,
        ),
        Consumer2<CarCreateProvider, UserProvider>(
            builder: (context, cp, up, _) {
          return Padding(
            padding: const EdgeInsets.all(28.0),
            child: OutlineButton(
              icon: Icons.done,
              label: "Confirm",
              onPressed: () async {
                List<String> images = await cp.uploadImages(cp.carData!.images);

                print('New images: $images');
                cp.eitherFailureOrCarData(
                    value: CarModel(
                        id: const Uuid().v7(),
                        title:
                            "${car.make} ${car.model} ${car.year} ${car.location}",
                        make: car.make,
                        model: car.model,
                        year: car.year,
                        color: car.color,
                        price: car.price,
                        mileage: car.mileage,
                        description: car.description,
                        features: car.features,
                        images: car.images,
                        location: car.location,
                        transmission: car.transmission,
                        fuel: car.fuel,
                        sellerId: up.firebaseUser!.uid,
                        createdAt: car.createdAt,
                        updatedAt: DateTime.now()));
                Navigator.popAndPushNamed(context, "/");
              },
            ),
          );
        })
        // const ThickDevider(),
        // const LocationSec(),
      ],
    );
  }
}

class ImageUploadForm extends StatelessWidget {
  const ImageUploadForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CarCreateProvider>(builder: (context, cp, _) {
      return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Icon(
              Icons.drive_folder_upload,
              size: 80,
            ),
            GestureDetector(
              onTap: () {
                cp.pickImage();
              },
              child: const SpContainer(
                height: 60,
                width: 200,
                child: Center(child: Ctext('Upload Images')),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                ),
                itemCount: cp.carData!.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        image: DecorationImage(
                            image: FileImage(File(cp.carData!.images[index])))),
                    height: 120,
                    width: 120,
                    child: IconButton(
                        onPressed: () {
                          cp.deleteImage(cp.carData!.images[index]);
                        },
                        icon: const Icon(Icons.delete)),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}

class LocationForm extends StatelessWidget {
  const LocationForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 400,
      child: Column(
        children: [
          CTextField(
            labelText: 'Location',
            onChanged: (value) =>
                context.read<CarCreateProvider>().updateLocation(value),
          ),
          CTextField(
            keyboardType: const TextInputType.numberWithOptions(),
            labelText: 'Price',
            onChanged: (value) => context.read<CarCreateProvider>().updatePrice(
                  double.parse(value),
                ),
          ),
        ],
      ),
    );
  }
}

class CarDetailForm extends StatelessWidget {
  const CarDetailForm({
    super.key,
    required this.cp,
  });
  final CarCreateProvider cp;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 400,
      child: ListView(
        children: [
          CustomTextField(
            labelText: 'Brand',
            hintText: 'Toyota',
            onChanged: (value) => cp.updateMake(value),
          ),
          CustomTextField(
            labelText: 'Model',
            hintText: 'Innova Crysta',
            onChanged: (value) => cp.updateModel(value),
          ),
          CustomTextField(
            keyboardType: const TextInputType.numberWithOptions(),
            hintText: '2016*',
            labelText: 'Year',
            onChanged: (value) => cp.updateYear(int.parse(value)),
          ),
          CDropDown(
            onChanged: (value) => cp.updateTransmission(value),
            label: "Transmission",
            items: const [
              'Manual',
              'Automatic',
              'Hybride',
            ],
          ),
          CDropDown(
            onChanged: (value) => cp.updateFuel(value),
            label: 'Fual',
            items: const [
              'Diesel',
              ' Petrole',
              ' Electric',
              ' Hybrid',
              ' CNG',
              ' Other',
            ],
          ),
          CustomTextField(
            keyboardType: const TextInputType.numberWithOptions(),
            hintText: '13000+',
            labelText: 'KM Driven',
            onChanged: (value) => cp.updateMileage(int.parse(value)),
          ),
          CustomTextField(
            keyboardType: TextInputType.multiline,
            labelText: 'Describe what you are selling',
            hintText: 'A detailed description',
            onChanged: (value) => cp.updateDescription(value),
          ),
        ],
      ),
    );
  }
}

class FeturesForm extends StatelessWidget {
  const FeturesForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController fc = TextEditingController();
    return Consumer<CarCreateProvider>(builder: (context, cp, _) {
      return Container(
        margin: const EdgeInsets.all(15),
        height: 400,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List<Widget>.generate(cp.carData!.features.length,
                    (int index) {
                  return Chip(
                    onDeleted: () {
                      cp.deleteFet(cp.carData!.features[index]);
                    },
                    label: Text(context
                        .watch<CarCreateProvider>()
                        .carData!
                        .features[index]),
                    backgroundColor: Colors.lightBlue[100],
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 180,
                    child: CTextField(
                      controller: fc,
                      labelText: 'Add Feture',
                      hintText: 'Panoramic Roof',
                    )),
                FloatingActionButton(
                  onPressed: () {
                    cp.addFeature(fc.text);
                    fc.clear();
                  },
                  elevation: 0,
                  child: const Icon(Icons.add),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
