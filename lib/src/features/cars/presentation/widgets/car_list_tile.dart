import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/home/widget.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as ta;

class CarLisTile extends StatelessWidget {
  final CarEntity car;
  const CarLisTile({super.key, required this.car});
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    final sz = MediaQuery.of(context).size;
    // SellerModel seller = Provider.of<UserProvider>(context).seller!;
    // print(":::::   ${car.updatedAt!}   :::::::::::::::::::::::::::::::");
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/carDetails", arguments: car);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        color: th.splashColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: th.scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CNImageWidget(
                img: car.images!.isEmpty ? '' : Ac.baseUrl + car.images!.first,
                height: 195,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDef(
                    'AED ${car.price}',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: th.primaryColor,
                  ),
                  Ctext(
                    ta.format(car.updatedAt!),
                    color: th.primaryColor.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              TextDef(
                "${car.make!} ${car.model!}",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 5,
              ),
              TextDef(
                "${car.year!}, ${car.transmission!}, ${car.fuel!}",
                fontSize: 16,
              ),

              const SpaceY(20),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 15,
                  ),
                  const SpaceX(10),
                  TextDef(car.location!)
                ],
              ),
              // const Divider(),
              // SizedBox(
              //   height: 40,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       CNImageWidget(
              //         img: car.images!.isEmpty
              //             ? ''
              //             : Ac.baseUrl + car.images!.first,
              //         height: 35,
              //       ),
              //       Container(
              //         decoration: BoxDecoration(
              //           border: Border.all(),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: TextButton.icon(
              //           onPressed: () {},
              //           icon: const Icon(Icons.phone),
              //           label: const Ctext('Call'),
              //         ),
              //       ),
              //       const SpaceX(10),
              //       Container(
              //         decoration: BoxDecoration(
              //           border: Border.all(),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: TextButton.icon(
              //           onPressed: () {},
              //           icon: const Icon(Icons.chat),
              //           label: const Ctext('Chat'),
              //         ),
              //       ),
              //       const SizedBox(width: 5),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 5,
              ),
              // const ThickDevider(),
            ],
          ),
        ),
      ),
    );
  }
}

class CarListLoadingTile extends StatelessWidget {
  const CarListLoadingTile({super.key});
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    final sz = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.read<CarsProvider>().eitherFailureOrCars();
        Navigator.pushNamed(context, "/carDetails");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: th.splashColor,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: th.scaffoldBackgroundColor,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomContainer(
                    height: 200,
                    width: sz.width,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Ctext(
                        'AED 00000',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: th.primaryColor,
                      ),
                      Ctext(
                        '2 days ago',
                        color: th.primaryColor.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomContainer(
                    height: 30,
                    width: 400,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const CustomContainer(
                    height: 20,
                    width: 400,
                  ),
                  const SpaceY(20),
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 15,
                      ),
                      SpaceX(20),
                      CustomContainer(
                        height: 20,
                        width: 180,
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.phone),
                            label: const Ctext('Call'),
                          ),
                        ),
                        const SpaceX(10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.chat),
                            label: const Ctext('Chat'),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // const ThickDevider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarShortListLoadingTile extends StatelessWidget {
  const CarShortListLoadingTile({super.key});
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    final sz = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.read<CarsProvider>().eitherFailureOrCars();
        Navigator.pushNamed(context, "/carDetails");
      },
      child: Container(
        width: sz.width,
        padding: const EdgeInsets.all(10),
        color: th.splashColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: th.scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.all(10),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                height: 100,
                width: 100,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer(
                    height: 20,
                    width: 250,
                  ),
                  SpaceY(10),
                  CustomContainer(
                    height: 20,
                    width: 200,
                  ),
                  SpaceY(20),
                  CustomContainer(
                    height: 20,
                    width: 100,
                  ),
                ],
              ),
              // Ctext(
              //   'AED 00000',
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold,
              //   color: th.primaryColor,
              // ),

              // const SizedBox(
              //   height: 5,
              // ),

              // const SpaceY(20),
              // const Row(
              //   children: [
              //     Icon(
              //       Icons.location_on,
              //       size: 15,
              //     ),
              //     SpaceX(20),
              //     CustomContainer(
              //       height: 20,
              //       width: 180,
              //     ),
              //   ],
              // ),
              // const Divider(),
              // SizedBox(
              //   height: 40,
              //   child: Row(
              //  crossAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(
              //           border: Border.all(),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: TextButton.icon(
              //           onPressed: () {},
              //           icon: const Icon(Icons.phone),
              //           label: const Ctext('Call'),
              //         ),
              //       ),
              //       const SpaceX(10),
              //       Container(
              //         decoration: BoxDecoration(
              //           border: Border.all(),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: TextButton.icon(
              //           onPressed: () {},
              //           icon: const Icon(Icons.chat),
              //           label: const Ctext('Chat'),
              //         ),
              //       ),
              //       const SizedBox(width: 5),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // const ThickDevider(),
            ],
          ),
        ),
      ),
    );
  }
}

class CarShortListTile extends StatelessWidget {
  final CarEntity car;
  final VoidCallback? onTap;
  final Widget? delete;
  const CarShortListTile({
    super.key,
    required this.car,
    this.onTap,
    this.delete,
  });
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    final sz = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap ??
          () {
            // context.read<CarsProvider>().eitherFailureOrCars();
            // if (car != null) {
            Navigator.pushNamed(context, "/carUpdate", arguments: car);
            // }
          },
      child: Container(
        width: sz.width,
        padding: const EdgeInsets.all(10),
        color: th.splashColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: th.scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(car.images!.isEmpty
                        ? ''
                        : "${Ac.baseUrl}${car.images!.first}")),
                height: 100,
                width: 100,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextDef("${car.make} ${car.model}"),
                  const SpaceY(10),
                  TextDef("${car.year}, ${car.transmission}"),
                  const SpaceY(20),
                  TextDef("AED ${car.price}"),
                ],
              ),
              const Spacer(),
              delete ?? const SizedBox(),
              // Ctext(
              //   'AED 00000',
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold,
              //   color: th.primaryColor,
              // ),

              // const SizedBox(
              //   height: 5,
              // ),

              // const SpaceY(20),
              // const Row(
              //   children: [
              //     Icon(
              //       Icons.location_on,
              //       size: 15,
              //     ),
              //     SpaceX(20),
              //     CustomContainer(
              //       height: 20,
              //       width: 180,
              //     ),
              //   ],
              // ),
              // const Divider(),
              // SizedBox(
              //   height: 40,
              //   child: Row(
              //  crossAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(
              //           border: Border.all(),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: TextButton.icon(
              //           onPressed: () {},
              //           icon: const Icon(Icons.phone),
              //           label: const Ctext('Call'),
              //         ),
              //       ),
              //       const SpaceX(10),
              //       Container(
              //         decoration: BoxDecoration(
              //           border: Border.all(),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: TextButton.icon(
              //           onPressed: () {},
              //           icon: const Icon(Icons.chat),
              //           label: const Ctext('Chat'),
              //         ),
              //       ),
              //       const SizedBox(width: 5),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // const ThickDevider(),
            ],
          ),
        ),
      ),
    );
  }
}
