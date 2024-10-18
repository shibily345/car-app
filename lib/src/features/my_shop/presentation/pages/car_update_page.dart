import 'dart:io';

import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/detail_sections.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarUpdatePage extends StatefulWidget {
  const CarUpdatePage({
    required this.thisCar,
    super.key,
  });
  final CarEntity thisCar;

  @override
  State<CarUpdatePage> createState() => _CarUpdatePageState();
}

class _CarUpdatePageState extends State<CarUpdatePage> {
  CarUpdateModel? upCar;
  @override
  void initState() {
    super.initState();
    updateCar(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<CarCreateProvider>().clearAll();
      setState(() {
        updateCar(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    return Consumer<CarCreateProvider>(builder: (context, cp, _) {
      return Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                20.spaceX,
                OutlineButton(
                  onPressed: () async {
                    // cp.updateImageNames(
                    List<String> images =
                        await cp.uploadImages(cp.carData!.images);

                    print('New images: $images');
                    cp.eitherFailureOrUpdateCarData(
                        value: CarModel(
                            id: upCar!.id,
                            title:
                                "${upCar!.make} ${upCar!.model} ${upCar!.year} ${upCar!.location}",
                            make: upCar!.make,
                            model: upCar!.model,
                            year: upCar!.year,
                            color: upCar!.color,
                            price: upCar!.price,
                            mileage: upCar!.mileage,
                            description: upCar!.description,
                            features: upCar!.features,
                            images: upCar!.images,
                            location: upCar!.location,
                            transmission: upCar!.transmission,
                            fuel: upCar!.fuel,
                            sellerId: upCar!.sellerId,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now()));
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  width: 230,
                  icon: Icons.update,
                  label: "Update",
                ),
                const Spacer(),
                OutlineButton(
                  onPressed: () {
                    cp.eitherFailureOrDeleteCarData(value: widget.thisCar.id!);
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  icon: Icons.delete,
                  label: "Delete",
                ),
                20.spaceX,

                // Spacer(),
              ],
            ),
          ),
          body: upCar != null
              ? ListView(
                  children: [
                    60.0.spaceX,
                    GestureDetector(
                      onTap: () {
                        cp.pickImage();
                      },
                      child: const SpContainer(
                        height: 60,
                        width: 200,
                        child: Center(child: Ctext('add New Images')),
                      ),
                    ),
                    10.spaceX,
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 5,
                          crossAxisCount: 2,
                        ),
                        itemCount: upCar!.images.length,
                        itemBuilder: (BuildContext context, int index) {
                          String url = upCar!.images[index];
                          debugPrint(url);
                          String finalUrl = "";
                          bool isFile = false;
                          if (!url.startsWith('/uploads')) {
                            finalUrl = url;
                            isFile = true;
                          } else {
                            finalUrl = '${Ac.baseUrl}$url';
                          }
                          return Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).splashColor,
                                image: DecorationImage(
                                    image: isFile
                                        ? FileImage(File(finalUrl))
                                        : NetworkImage(finalUrl))),
                            height: 120,
                            width: 120,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<CarCreateProvider>()
                                        .deleteImage(upCar!.images[index]);
                                  });
                                },
                                icon: const Icon(Icons.delete)),
                          );
                        },
                      ),
                    ),
                    const ThickDevider(),
                    EditSection(
                      keyboard: const TextInputType.numberWithOptions(),
                      onChanged: (value) {
                        cp.updatePrice(double.parse(value));
                      },
                      title: "Price ",
                      name: upCar!.price.toString(),
                    ),

                    EditSection(
                      onChanged: (value) {
                        cp.updateMake(value);
                      },
                      title: "Make ",
                      name: upCar!.make,
                    ),

                    EditSection(
                      onChanged: (value) {
                        cp.updateModel(value);
                      },
                      title: "Model ",
                      name: upCar!.model,
                    ),

                    EditSection(
                      keyboard: TextInputType.number,
                      onChanged: (value) {
                        cp.updateYear(int.parse(value));
                      },
                      title: "Year ",
                      name: upCar!.year.toString(),
                    ),

                    EditSection(
                      keyboard: TextInputType.number,
                      onChanged: (value) {
                        cp.updateMileage(int.parse(value));
                      },
                      title: "Milage ",
                      name: upCar!.mileage.toString(),
                    ),

                    // EditSection(
                    //   onChanged: (value) {},
                    //   title: "Transmission ",
                    //   name: upCar!.transmission,
                    // ),

                    // EditSection(
                    //   onChanged: (value) {},
                    //   title: "Fuel ",
                    //   name: upCar!.fuel,
                    // ),

                    EditSection(
                      onChanged: (value) {
                        cp.updateLocation(value);
                      },
                      title: "Location ",
                      name: upCar!.location,
                    ),

                    const ThickDevider(),
                    // UpDetailsSec(
                    //   cp: cp,
                    //   th: th,
                    //   details: upCar!.features,
                    // ),
                    const FeturesForm(),
                    const ThickDevider(),
                    DescSec(
                      th: th,
                      description: upCar!.description,
                    ),
                    EditSection(
                      onChanged: (value) {
                        cp.updateDescription(value);
                      },
                      title: "Description ",
                      name: upCar!.description,
                    ),

                    // const ThickDevider(),
                    // const LocationSec(),
                  ],
                )
              : Container());
    });
  }

  void updateCar(BuildContext ctx) {
    Provider.of<CarCreateProvider>(context, listen: false).carData =
        CarUpdateModel(
            id: widget.thisCar.id!,
            title: widget.thisCar.title!,
            make: widget.thisCar.make!,
            model: widget.thisCar.model!,
            year: widget.thisCar.year!,
            color: widget.thisCar.color!,
            price: widget.thisCar.price!,
            mileage: widget.thisCar.mileage!,
            description: widget.thisCar.description!,
            features: widget.thisCar.features!,
            images: widget.thisCar.images!,
            location: widget.thisCar.location!,
            transmission: widget.thisCar.transmission!,
            fuel: widget.thisCar.fuel!,
            sellerId: widget.thisCar.sellerId!,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());

    upCar = Provider.of<CarCreateProvider>(context, listen: false).carData!;
    print(upCar);
  }
}
